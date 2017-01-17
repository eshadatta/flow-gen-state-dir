require 'spec_helper'
require 'open3'
require 'pry'
require 'yaml'
require 'fileutils'
# make constants of path var
CMD = "ruby lib/make_dir.rb".freeze
ROOT_PATH = "test"

def set_vars
  state_dir_info = "install/.flow/state-dir.yml"
end

def set_cmd(file)
  cmd = "#{CMD} #{ROOT_PATH} #{file}"
  _,err,status = Open3.capture3(cmd)
end

def get_dirs
  file = set_vars
  chk_dirs = YAML.load_file(file)
  results = set_cmd(file)
  dirs = chk_dirs.keys.collect { |dir| "#{ROOT_PATH}/#{dir}" }
  [dirs,results]
end

def remove_dirs(dirs)
  dirs.each { |d|
    FileUtils.rm_rf(d)
  }
  FileUtils.remove_dir(ROOT_PATH)
end

describe "make_dir script" do
  it "errors out with the wrong number of arguments" do
    _, err, status = Open3.capture3(CMD)
    expect(err).to match(/incorrect number of arguments/)
  end

  it "errors out if directory information file does not exist" do
    file = "file.yml"
    _,err,status = set_cmd(file)
    expect(err).to match(/ERROR/)
  end

  it "creates expected directories when all arguments are valid" do
    dirs,results = get_dirs
    err = results[1]
    dirs.each { |dir|
      expect(File).to exist(dir)
      expect(err).to eq ""
    }
    remove_dirs(dirs)
  end
end
