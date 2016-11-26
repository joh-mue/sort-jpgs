#!/usr/bin/ruby

require 'exifr'
require 'fileutils'
require 'date'
require 'optparse'
require 'logger'

FORMAT = "%y-%m-%d %H:%M:%S"

def parse_options
  opts = { source: './', output: './', move: false }

  optparse = OptionParser.new do |parser|
    # banner that is displayed at the top
    parser.banner = "Usage: \b
    sort_jpgs [-h] [-s SOURCE_PATH] -o OUTPUT_PATH\n\n"

    ### options and what they do
    parser.on('-s', '--source-path DIR', 'Set the directory that contains files to be sorted. Default is PWD') do |source|
      opts[:source] = source
    end

    parser.on('-o', '--output-path DIR', 'Set the directory that the files will be written to.') do |output|
      opts[:output] = output
    end

    parser.on('-m', '--move', 'Move files instead of copying them.') do
      opts[:move] = true
    end

    parser.on('-t', '--threshold VALUE', Integer,'Set the size threshold that a picture has to meet in kB.') do |threshold|
      opts[:threshold] = threshold.to_i
    end

    # This displays the help screen
    parser.on_tail('-h', '--help', 'Display this screen.' ) do
      puts parser
      exit
    end
  end
  optparse.parse!
  opts
end

def increment_filebasename(existing_files)
  base = File.basename(existing_files.first, '.jpg').split('-').first
  count = 1
  if existing_files.size > 1
    count = existing_files.map { |file| File.basename(file, '.jpg') }
      .select { |name| name.include? '-' }
      .map { |name| name.split('-').last.to_i }
      .sort
      .last
      .succ
  end
  "#{base}-#{count}.jpg"
end

# create directories if nonexistant
def create_target_dir(pic, output)
  year = pic.date_time.to_s[0,4] # e.g. "2013"
  month = pic.date_time.to_s[5,2]
  day = pic.date_time.to_s[8,2] # 2012-08-13
  target_dir = File.join(opts[:output], model, year, month, day)
  if !Dir.exist?(target_dir) then FileUtils.mkdirs target_dir end
  target_dir
end

# check if file already exists and create appropriate file_basename
def create_file_basename(pic, target_dir)
  existing_files = Dir.glob File.join(target_dir, "#{pic.date_time.to_i}*")
  if existing_files > 0
    increment_filebasename(existing_files, file_basename)
  else
    "#{pic.date_time.to_i}"
  end
end

def handle_file(move, file, target_dir, file_basename)
  if move
    FileUtils.move(file, File.join(target_dir, file_basename + ".jpg"))
  else
    FileUtils.copy(file, File.join(target_dir, file_basename + ".jpg"))
  end
  statistics[:moved_or_copied] += 1
end

if __FILE__ == $PROGRAM_NAME
  $LOG = Logger.new("sort_jpgs_#{Time.now.to_i}.log")
  
  opts = parse_options
  statistics = new Hash(0)

  files = Dir.glob File.join(source_path, "*/*.jpg")

  $LOG.info(Time.now.strftime(FORMAT))  { "Log file for sort_jpgs from #{Time.now}" }
  $LOG.info(Time.now.strftime(FORMAT))  { "#{files.count} files where found." }

  files.each do |file|
    begin
      pic = EXIFR::JPEG.new(file)
      statistics[pic.model] += 1
      target_dir = create_target_dir(pic, opts[:output])
      create_file_basename(pic, target_dir)
      handle_file(opts[:move], file, target_dir, file_basename)
    rescue
      $LOG.error "Exception was raised while handling #{file}. (probably an EXIFR::MalformedJPEG exception)"
    end
  end

  $LOG.info(Time.now.strftime(FORMAT))  { "#{statistics[:moved_or_copied]} files were moved/copied." }
  $LOG.info(Time.now.strftime(FORMAT))  { statistics }
end
