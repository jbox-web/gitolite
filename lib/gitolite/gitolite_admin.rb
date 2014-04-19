module Gitolite
  class GitoliteAdmin

    attr_accessor :gl_admin

    CONFIG_FILE = "gitolite.conf"
    CONF_DIR    = "conf"
    KEY_DIR     = "keydir"
    DEBUG       = false
    TIMEOUT     = 10

    # Gitolite gem's default commit message
    DEFAULT_COMMIT_MSG = "Committed by the gitolite gem"

    class << self

      # Checks to see if the given path is a gitolite-admin repository
      # A valid repository contains a conf folder, keydir folder,
      # and a configuration file within the conf folder
      def is_gitolite_admin_repo?(dir)
        # First check if it is a git repository
        begin
          Grit::Repo.new(dir)
        rescue Grit::NoSuchPathError, Grit::InvalidGitRepositoryError
          return false
        end

        # If we got here it is a valid git repo,
        # now check directory structure
        File.exists?(File.join(dir, 'conf')) &&
          File.exists?(File.join(dir, 'keydir')) &&
          !Dir.glob(File.join(dir, 'conf', '*.conf')).empty?
      end


      # This method will bootstrap a gitolite-admin repo
      # at the given path.  A typical gitolite-admin
      # repo will have the following tree:
      #
      # gitolite-admin
      #   conf
      #     gitolite.conf
      #   keydir
      def bootstrap(path, options = {})
        if self.is_gitolite_admin_repo?(path)
          if options[:overwrite]
            FileUtils.rm_rf(File.join(path, '*'))
          else
            return self.new(path)
          end
        end

        FileUtils.mkdir_p([File.join(path, "conf"), File.join(path, "keydir")])

        options[:perm]  ||= "RW+"
        options[:refex] ||= ""
        options[:user]  ||= "git"

        c = Config.init
        r = Config::Repo.new(options[:repo] || "gitolite-admin")
        r.add_permission(options[:perm], options[:refex], options[:user])
        c.add_repo(r)
        config = c.to_file(File.join(path, "conf"))

        gl_admin = Grit::Repo.init(path)
        gl_admin.git.native(:add, {:chdir => gl_admin.working_dir}, config)
        gl_admin.git.native(:commit, {:chdir => gl_admin.working_dir}, '-a', '-m', options[:message] || "Config bootstrapped by the gitolite gem")

        self.new(path)
      end

    end


    # Intialize with the path to
    # the gitolite-admin repository
    def initialize(path, options = {})
      @path = path

      @config_file = options[:config_file] || CONFIG_FILE
      @conf_dir    = options[:conf_dir] || CONF_DIR
      @key_dir     = options[:key_dir] || KEY_DIR
      @env         = options[:env] || {}

      @config_file_path = File.join(@path, @conf_dir, @config_file)
      @conf_dir_path    = File.join(@path, @conf_dir)
      @key_dir_path     = File.join(@path, @key_dir)

      Grit::Git.git_timeout = options[:timeout] || TIMEOUT
      Grit.debug = options[:debug] || DEBUG
      @gl_admin  = Grit::Repo.new(path)

      reload!
    end


    def config
      @config ||= load_config
    end


    def config=(config)
      @config = config
    end


    def ssh_keys
      @ssh_keys ||= load_keys
    end


    def add_key(key)
      raise "Key must be of type Gitolite::SSHKey!" unless key.instance_of? Gitolite::SSHKey
      ssh_keys[key.owner] << key
    end


    def rm_key(key)
      raise "Key must be of type Gitolite::SSHKey!" unless key.instance_of? Gitolite::SSHKey
      ssh_keys[key.owner].delete key
    end


    # This method will destroy all local tracked changes, resetting the local gitolite
    # git repo to HEAD and reloading the entire repository
    # Note that this will also delete all untracked files
    def reset!
      @gl_admin.git.native(:reset, {:env => @env, :chdir => @gl_admin.working_dir, :hard => true}, 'HEAD')
      @gl_admin.git.native(:clean, {:env => @env, :chdir => @gl_admin.working_dir, :d => true, :q => true, :f => true})
      reload!
    end


    # This method will destroy the in-memory data structures and reload everything
    # from the file system
    def reload!
      @ssh_keys = load_keys
      @config = load_config
    end


    # Writes all changed aspects out to the file system
    # will also stage all changes then commit
    def save(commit_message = DEFAULT_COMMIT_MSG, options = {})

      #Process config file (if loaded, i.e. may be modified)
      if @config
        new_conf = @config.to_file(@conf_dir_path)
        @gl_admin.git.native(:add, {:env => @env, :chdir => @gl_admin.working_dir}, new_conf)
      end

      #Process ssh keys (if loaded, i.e. may be modified)
      if @ssh_keys
        files = list_keys.map{|f| File.basename f}
        keys  = @ssh_keys.values.map{|f| f.map {|t| t.filename}}.flatten

        to_remove = (files - keys).map { |f| File.join(@key_dir, f) }
        to_remove.each do |key|
          @gl_admin.git.native(:rm, {:env => @env, :chdir => @gl_admin.working_dir}, key)
        end

        @ssh_keys.each_value do |key|
          # Write only keys from sets that has been modified
          next if key.respond_to?(:dirty?) && !key.dirty?
          key.each do |k|
            new_key = k.to_file(@key_dir_path)
            @gl_admin.git.native(:add, {:env => @env, :chdir => @gl_admin.working_dir}, new_key)
          end
        end
      end

      args = []

      if options.has_key?(:author) && !options[:author].empty?
        args << "--author='#{options[:author]}'"
      end

      @gl_admin.git.native(:commit, {:env => @env, :chdir => @gl_admin.working_dir}, '-a', '-m', commit_message, args.join(' '))
    end


    # Push back to origin
    def apply
      @gl_admin.git.native(:push, {:env => @env, :chdir => @gl_admin.working_dir}, "origin", "master")
    end


    # Commits all staged changes and pushes back to origin
    def save_and_apply(commit_message = DEFAULT_COMMIT_MSG)
      save(commit_message)
      apply
    end


    # Updates the repo with changes from remote master
    def update(options = {})
      options = {:reset => true, :rebase => false}.merge(options)

      reset! if options[:reset]

      @gl_admin.git.native(:pull, {:env => @env, :chdir => @gl_admin.working_dir, :rebase => options[:rebase]}, "origin", "master")

      reload!
    end


    private


    def load_config
      Config.new(@config_file_path)
    end


    def list_keys
      Dir.glob(@key_dir_path + '/**/*.pub')
    end


    # Loads all .pub files in the gitolite-admin
    # keydir directory
    def load_keys
      keys = Hash.new {|k,v| k[v] = DirtyProxy.new([])}

      list_keys.each do |key|
        new_key = SSHKey.from_file(key)
        owner = new_key.owner

        keys[owner] << new_key
      end

      # Mark key sets as unmodified (for dirty checking)
      keys.values.each{|set| set.clean_up!}

      keys
    end

  end
end
