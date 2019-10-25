require 'spec_helper'

RSpec.describe Gitolite::GitoliteAdmin do

  describe '#bootstrap' do
    it 'should bootstrap a gitolite-admin repository' do
      test_dir = File.join(OUTPUT_DIR, 'gitolite-admin-test1')
      opts = { :overwrite => false }
      gl_admin = Gitolite::GitoliteAdmin.bootstrap(test_dir, opts)

      expect(gl_admin).to be_a Gitolite::GitoliteAdmin
      expect(Gitolite::GitoliteAdmin.is_gitolite_admin_repo?(test_dir)).to be true
    end

    it 'should bootstrap (overwrite) a gitolite-admin repository' do
      test_dir = File.join(OUTPUT_DIR, 'gitolite-admin-test1')
      opts = { :overwrite => true }
      gl_admin = Gitolite::GitoliteAdmin.bootstrap(test_dir, opts)

      expect(gl_admin).to be_a Gitolite::GitoliteAdmin
      expect(Gitolite::GitoliteAdmin.is_gitolite_admin_repo?(test_dir)).to be true
    end
  end

  describe '#is_gitolite_admin_repo?' do
    it 'should detect a non gitolite-admin repository' do
      test_dir = OUTPUT_DIR
      expect(Gitolite::GitoliteAdmin.is_gitolite_admin_repo?(test_dir)).to be false
    end
  end

  describe '#save' do
    it 'should commit file to gitolite-admin repository' do
      test_dir = File.join(OUTPUT_DIR, 'gitolite-admin-test2')
      opts = { :overwrite => true }
      gl_admin = Gitolite::GitoliteAdmin.bootstrap(test_dir, opts)

      c = Gitolite::Config.new(File.join(CONFIG_FILES_DIR, 'complicated.conf'))
      c.filename = 'gitolite.conf'

      gl_admin.config = c
      gl_admin.save('new commit', author: 'Test <test@example.com>')

      new_file = File.join(test_dir, 'conf', c.filename)
      expect(File.file?(new_file)).to be true
    end
  end

end
