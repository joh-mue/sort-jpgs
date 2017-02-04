#!/usr/bin/ruby
# frozen_string_literal: true

require 'exifr'
require 'fileutils'
require 'date'
require 'optparse'
require 'logger'
require 'schlib/spinner'

FORMAT = '%y-%m-%d %H:%M:%S'

# rubocop:disable Metrics/MethodLength
def parse_options
  opts = { source: './', output: './', move: false }

  optparse = OptionParser.new do |parser|
    parser.banner = "Usage: \bsort_jpgs [-h] [-s SOURCE_PATH] -o OUTPUT_PATH\n\n"

    ### options and what they do
    parser.on('-s', '--source-path DIR',
              'Set the directory that contains files to be sorted. Default is PWD') do |source|
      opts[:source] = source
    end

    parser.on('-o', '--output-path DIR',
              'Set the directory that the files will be written to.') do |output|
      opts[:output] = output
    end

    parser.on('-m', '--move', 'Move files instead of copying them.') do
      opts[:move] = true
    end

    parser.on('-t', '--threshold VALUE', Integer,
              'Set the minimum size that a picture has to be in kB.') do |threshold|
      opts[:threshold] = threshold.to_i * 1000
    end

    # This displays the help screen
    parser.on_tail('-h', '--help', 'Display this screen.') do
      puts parser
      exit
    end
  end

  optparse.parse!
  opts
end
# rubocop:enable Metrics/MethodLength

def increment_filename(existing_files)
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
  year = pic.date_time.to_s[0, 4] # e.g. "2013"
  month = pic.date_time.to_s[5, 2]
  day = pic.date_time.to_s[8, 2] # 2012-08-13
  target_dir = File.join(output, pic.model, year, month, day)
  FileUtils.mkdirs target_dir unless Dir.exist?(target_dir)
  target_dir
end

# check if file already exists and create appropriate file_basename
def create_file_basename(pic, target_dir)
  existing_files = Dir.glob File.join(target_dir, "#{pic.date_time.to_i}*")
  if existing_files > 0
    increment_filename(existing_files)
  else
    pic.date_time.to_i.to_s
  end
end

def handle_file(move, file, target_dir, file_basename)
  if move
    FileUtils.move(file, File.join(target_dir, file_basename + '.jpg'))
  else
    FileUtils.copy(file, File.join(target_dir, file_basename + '.jpg'))
  end
  statistics[:moved_or_copied] += 1
end

def time
  Time.now.strftime(FORMAT)
end

if __FILE__ == $PROGRAM_NAME
  Log = Logger.new("sort_jpgs_#{Time.now.to_i}.log")
  opts = parse_options
  statistics = new Hash(0)

  files = Dir.glob File.join(source_path, '*/*.jpg')
  Log.info(time) { "Log file for sort_jpgs from #{Time.now} \n #{files.count} files where found." }

  Schlib::Spinner.wait_for do
    files.select { |file| File.size(file) >= opts[:threshold] }.each do |file|
      begin
        pic = EXIFR::JPEG.new(file)
        statistics[pic.model] += 1
        target_dir = create_target_dir(pic, opts[:output])
        create_file_basename(pic, target_dir)
        handle_file(opts[:move], file, target_dir, file_basename)
      rescue EXIFR::MalformedJPEG => e
        Log.error { "EXIFR::MalformedJPEG exception was raised while handling #{file}.\n#{e}" }
      end
    end
  end

  Log.info(time) { "#{statistics[:moved_or_copied]} files were moved/copied." }
  Log.info(time) { statistics }
end
