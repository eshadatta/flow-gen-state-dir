#!/usr/bin/ruby

require 'yaml'
require 'fileutils'

def chk_args
  raise RuntimeError, "incorrect number of arguments" if ARGV.size != 2
end

def create_dirs
  unless File.exist?(STATE_DIR_INFO)
    raise RuntimeError, "ERROR: #{STATE_DIR_INFO} does not exist"
  end

  dir_info = YAML.load_file(STATE_DIR_INFO)

  dir_info.keys.each { |dir|
    full_path = "#{ROOT_PATH}/#{dir}"
    unless Dir.exist?(full_path)
      begin
        puts "Creating directory: #{full_path}"
        FileUtils.mkdir_p(full_path)
      rescue RuntimeError => e
        puts e
      end
    end
  }
end

ROOT_PATH = ARGV[0]

STATE_DIR_INFO = ARGV[1]

chk_args
create_dirs
