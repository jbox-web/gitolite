require 'spec_helper'

describe Gitolite::SSHKey do

  key_dir    = ssh_key_files_dir
  output_dir = '/tmp'
  # output_dir = File.join(File.dirname(File.dirname(__FILE__)), 'tmp')

  describe "#from_string" do
    it 'should construct an SSH key from a string' do
      key = File.join(key_dir, 'bob.pub')
      key_string = File.read(key)
      s = SSHKey.from_string(key_string, "bob")

      expect(s.owner).to eq 'bob'
      expect(s.location).to eq ""
      expect(s.blob).to eq key_string.split[1]
    end

    it 'should raise an ArgumentError when an owner isnt specified' do
      key_string = "not_a_real_key"
      expect(lambda { SSHKey.from_string(key_string) }).to raise_error
    end

    it 'should have a location when one is specified' do
      key = File.join(key_dir, 'bob.pub')
      key_string = File.read(key)
      s = SSHKey.from_string(key_string, "bob", "kansas")

      expect(s.owner).to eq 'bob'
      expect(s.location).to eq "kansas"
      expect(s.blob).to eq key_string.split[1]
    end

    it 'should raise an ArgumentError when owner is nil' do
      expect(lambda { SSHKey.from_string("bad_string", nil) }).to raise_error
    end

    it 'should raise an ArgumentError when we get an invalid SSHKey string' do
      expect(lambda { SSHKey.from_string("bad_string", "bob") }).to raise_error
    end
  end

  describe "#from_file" do
    it 'should load a key from a file' do
      key = File.join(key_dir, 'bob.pub')
      s = SSHKey.from_file(key)
      key_string = File.read(key).split

      expect(s.owner).to eq "bob"
      expect(s.blob).to eq key_string[1]
    end

    it 'should load a key with a location from a file' do
      key = File.join(key_dir, 'bob@desktop.pub')
      s = SSHKey.from_file(key)
      expect(s.owner).to eq 'bob'
      expect(s.location).to eq 'desktop'
    end

    it 'should load a key with owner and location from a file' do
      key = File.join(key_dir, 'joe-bob@god-zilla.com@desktop.pub')
      s = SSHKey.from_file(key)
      expect(s.owner).to eq 'joe-bob@god-zilla.com'
      expect(s.location).to eq 'desktop'
    end
  end

  describe '#owner' do
    it 'owner should be bob for bob.pub' do
      key = File.join(key_dir, 'bob.pub')
      s = SSHKey.from_file(key)
      expect(s.owner).to eq 'bob'
    end

    it 'owner should be bob for bob@desktop.pub' do
      key = File.join(key_dir, 'bob@desktop.pub')
      s = SSHKey.from_file(key)
      expect(s.owner).to eq 'bob'
    end

    it 'owner should be bob@zilla.com for bob@zilla.com.pub' do
      key = File.join(key_dir, 'bob@zilla.com.pub')
      s = SSHKey.from_file(key)
      expect(s.owner).to eq 'bob@zilla.com'
    end

    it "owner should be joe-bob@god-zilla.com for joe-bob@god-zilla.com@desktop.pub" do
      key = File.join(key_dir, 'joe-bob@god-zilla.com@desktop.pub')
      s = SSHKey.from_file(key)
      expect(s.owner).to eq 'joe-bob@god-zilla.com'
    end

    it "owner should be bob.joe@test.zilla.com for bob.joe@test.zilla.com@desktop.pub" do
      key = File.join(key_dir, 'bob.joe@test.zilla.com@desktop.pub')
      s = SSHKey.from_file(key)
      expect(s.owner).to eq 'bob.joe@test.zilla.com'
    end

    it "owner should be bob+joe@test.zilla.com for bob+joe@test.zilla.com@desktop.pub" do
      key = File.join(key_dir, 'bob+joe@test.zilla.com@desktop.pub')
      s = SSHKey.from_file(key)
      expect(s.owner).to eq 'bob+joe@test.zilla.com'
    end

    it 'owner should be bob@zilla.com for bob@zilla.com@desktop.pub' do
      key = File.join(key_dir, 'bob@zilla.com@desktop.pub')
      s = SSHKey.from_file(key)
      expect(s.owner).to eq 'bob@zilla.com'
    end

    it 'owner should be jakub123 for jakub123.pub' do
      key = File.join(key_dir, 'jakub123.pub')
      s = SSHKey.from_file(key)
      expect(s.owner).to eq 'jakub123'
    end

    it 'owner should be jakub123@foo.net for jakub123@foo.net.pub' do
      key = File.join(key_dir, 'jakub123@foo.net.pub')
      s = SSHKey.from_file(key)
      expect(s.owner).to eq 'jakub123@foo.net'
    end

    it 'owner should be joe@sch.ool.edu for joe@sch.ool.edu' do
      key = File.join(key_dir, 'joe@sch.ool.edu.pub')
      s = SSHKey.from_file(key)
      expect(s.owner).to eq 'joe@sch.ool.edu'
    end

    it 'owner should be joe@sch.ool.edu for joe@sch.ool.edu@desktop.pub' do
      key = File.join(key_dir, 'joe@sch.ool.edu@desktop.pub')
      s = SSHKey.from_file(key)
      expect(s.owner).to eq 'joe@sch.ool.edu'
    end
  end

  describe '#location' do
    it 'location should be "" for bob.pub' do
      key = File.join(key_dir, 'bob.pub')
      s = SSHKey.from_file(key)
      expect(s.location).to eq ''
    end

    it 'location should be "desktop" for bob@desktop.pub' do
      key = File.join(key_dir, 'bob@desktop.pub')
      s = SSHKey.from_file(key)
      expect(s.location).to eq 'desktop'
    end

    it 'location should be "" for bob@zilla.com.pub' do
      key = File.join(key_dir, 'bob@zilla.com.pub')
      s = SSHKey.from_file(key)
      expect(s.location).to eq ''
    end

    it 'location should be "desktop" for bob@zilla.com@desktop.pub' do
      key = File.join(key_dir, 'bob@zilla.com@desktop.pub')
      s = SSHKey.from_file(key)
      expect(s.location).to eq 'desktop'
    end

    it 'location should be "" for jakub123.pub' do
      key = File.join(key_dir, 'jakub123.pub')
      s = SSHKey.from_file(key)
      expect(s.location).to eq ''
    end

    it 'location should be "" for jakub123@foo.net.pub' do
      key = File.join(key_dir, 'jakub123@foo.net.pub')
      s = SSHKey.from_file(key)
      expect(s.location).to eq ''
    end

    it 'location should be "" for joe@sch.ool.edu' do
      key = File.join(key_dir, 'joe@sch.ool.edu.pub')
      s = SSHKey.from_file(key)
      expect(s.location).to eq ''
    end

    it 'location should be "desktop" for joe@sch.ool.edu@desktop.pub' do
      key = File.join(key_dir, 'joe@sch.ool.edu@desktop.pub')
      s = SSHKey.from_file(key)
      expect(s.location).to eq 'desktop'
    end

    it 'location should be "foo-bar" for bob@foo-bar.pub' do
      key = File.join(key_dir, 'bob@foo-bar.pub')
      s = SSHKey.from_file(key)
      expect(s.location).to eq 'foo-bar'
    end
  end

  describe '#keys' do
    it 'should load ssh key properly' do
      key = File.join(key_dir, 'bob.pub')
      s = SSHKey.from_file(key)
      parts = File.read(key).split #should get type, blob, email

      expect(s.type).to eq parts[0]
      expect(s.blob).to eq parts[1]
      expect(s.email).to eq parts[2]
    end
  end

  describe '#email' do
    it 'should use owner if email is missing' do
      key = File.join(key_dir, 'jakub123@foo.net.pub')
      s = SSHKey.from_file(key)
      expect(s.owner).to eq s.email
    end
  end

  describe '#new' do
    it 'should create a valid ssh key' do
      type = "ssh-rsa"
      blob = Forgery::Basic.text(:at_least => 372, :at_most => 372)
      email = Forgery::Internet.email_address

      s = SSHKey.new(type, blob, email)

      expect(s.to_s).to eq [type, blob, email].join(' ')
      expect(s.owner).to eq email
    end

    it 'should create a valid ssh key while specifying an owner' do
      type = "ssh-rsa"
      blob = Forgery::Basic.text(:at_least => 372, :at_most => 372)
      email = Forgery::Internet.email_address
      owner = Forgery::Name.first_name

      s = SSHKey.new(type, blob, email, owner)

      expect(s.to_s).to eq [type, blob, email].join(' ')
      expect(s.owner).to eq owner
    end

    it 'should create a valid ssh key while specifying an owner and location' do
      type = "ssh-rsa"
      blob = Forgery::Basic.text(:at_least => 372, :at_most => 372)
      email = Forgery::Internet.email_address
      owner = Forgery::Name.first_name
      location = Forgery::Name.location

      s = SSHKey.new(type, blob, email, owner, location)

      expect(s.to_s).to eq [type, blob, email].join(' ')
      expect(s.owner).to eq owner
      expect(s.location).to eq location
    end
  end

  describe '#hash' do
    it 'should have two hash equalling one another' do
      type = "ssh-rsa"
      blob = Forgery::Basic.text(:at_least => 372, :at_most => 372)
      email = Forgery::Internet.email_address
      owner = Forgery::Name.first_name
      location = Forgery::Name.location

      hash_test = [owner, location, type, blob, email].hash
      s = SSHKey.new(type, blob, email, owner, location)

      expect(s.hash).to eq hash_test
    end
  end

  describe '#filename' do
    it 'should create a filename that is the <email>.pub' do
      type = "ssh-rsa"
      blob = Forgery::Basic.text(:at_least => 372, :at_most => 372)
      email = Forgery::Internet.email_address

      s = SSHKey.new(type, blob, email)

      expect(s.filename).to eq "#{email}.pub"
    end

    it 'should create a filename that is the <owner>.pub' do
      type = "ssh-rsa"
      blob = Forgery::Basic.text(:at_least => 372, :at_most => 372)
      email = Forgery::Internet.email_address
      owner = Forgery::Name.first_name

      s = SSHKey.new(type, blob, email, owner)

      expect(s.filename).to eq "#{owner}.pub"
    end

    it 'should create a filename that is the <email>@<location>.pub' do
      type = "ssh-rsa"
      blob = Forgery::Basic.text(:at_least => 372, :at_most => 372)
      email = Forgery::Internet.email_address
      location = Forgery::Basic.text(:at_least => 8, :at_most => 15)

      s = SSHKey.new(type, blob, email, nil, location)

      expect(s.filename).to eq "#{email}@#{location}.pub"
    end

    it 'should create a filename that is the <owner>@<location>.pub' do
      type = "ssh-rsa"
      blob = Forgery::Basic.text(:at_least => 372, :at_most => 372)
      email = Forgery::Internet.email_address
      owner = Forgery::Name.first_name
      location = Forgery::Basic.text(:at_least => 8, :at_most => 15)

      s = SSHKey.new(type, blob, email, owner, location)

      expect(s.filename).to eq "#{owner}@#{location}.pub"
    end
  end

  describe '#to_file' do
    it 'should write a "valid" SSH public key to the file system' do
      type = "ssh-rsa"
      blob = Forgery::Basic.text(:at_least => 372, :at_most => 372)
      email = Forgery::Internet.email_address
      owner = Forgery::Name.first_name
      location = Forgery::Basic.text(:at_least => 8, :at_most => 15)

      s = SSHKey.new(type, blob, email, owner, location)

      ## write file
      s.to_file(output_dir)

      ## compare raw string with written file
      expect(s.to_s).to eq File.read(File.join(output_dir, s.filename))
    end

    it 'should return the filename written' do
      type = "ssh-rsa"
      blob = Forgery::Basic.text(:at_least => 372, :at_most => 372)
      email = Forgery::Internet.email_address
      owner = Forgery::Name.first_name
      location = Forgery::Basic.text(:at_least => 8, :at_most => 15)

      s = SSHKey.new(type, blob, email, owner, location)

      expect(s.to_file(output_dir)).to eq File.join(output_dir, s.filename)
    end
  end

  describe '==' do
    it 'should have two keys equalling one another' do
      type = "ssh-rsa"
      blob = Forgery::Basic.text(:at_least => 372, :at_most => 372)
      email = Forgery::Internet.email_address

      s1 = SSHKey.new(type, blob, email)
      s2 = SSHKey.new(type, blob, email)

      expect(s1).to eq s2
    end
  end
end
