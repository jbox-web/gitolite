module Helper

  def config_files_dir
    File.join(File.dirname(__FILE__), '..', 'fixtures', 'configs')
  end


  def ssh_key_files_dir
    File.join(File.dirname(__FILE__), '..', 'fixtures', 'keys')
  end

end
