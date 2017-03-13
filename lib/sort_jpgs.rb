# frozen_string_literal: true

require 'exifr'
require 'fileutils'
require 'date'
require 'logger'
require 'schlib/spinner'

module SortJPGS
  FORMAT = '%y-%m-%d %H:%M:%S'

  # This is where all the magic happens
  class Sorter
    def initialize(opts)
      @source = opts[:source]
      @output = opts[:output]
      @move = opts[:move]
      @threshold = opts[:threshold]
    end

    # rubocop:disable Metrics/AbcSize
    def run
      log = Logger.new("sort_jpgs_#{Time.now.to_i}.log")
      stats = Hash.new(0)

      files = Dir.glob File.join(@source, '*/*.jpg')
      log.info(time) { "SortJPGS log from #{Time.now} \n #{files.count} files where found." }

      Schlib::Spinner.wait_for do
        files.select { |file| File.size(file) >= @threshold }.each do |file|
          begin
            pic = EXIFR::JPEG.new(file)
            target_dir = create_target_dir(pic)
            filename = create_filename(pic, target_dir)
            handle_file(file, target_dir, filename)
            update_statistics(stats, pic.model)
          rescue EXIFR::MalformedJPEG => e
            log.error { "EXIFR::MalformedJPEG exception was raised while handling #{file}.\n#{e}" }
          end
        end
      end

      log.info(time) { "#{stats[:moved_or_copied]} files were moved/copied." }
      log.info(time) { stats }
    end
    # rubocop:enable Metrcis/AbcSize

    def time
      Time.now.strftime(FORMAT)
    end

    # create directories if nonexistant
    def create_target_dir(pic)
      year = pic.date_time.to_s[0, 4] # e.g. "2013"
      month = pic.date_time.to_s[5, 2] # 08
      day = pic.date_time.to_s[8, 2] # 2012-08-13
      target_dir = File.join(@output, pic.model, year, month, day)
      FileUtils.makedirs target_dir unless Dir.exist?(target_dir)
      target_dir
    end

    # check if file already exists and create appropriate filename
    def create_filename(pic, target_dir)
      existing_files = Dir.glob File.join(target_dir, "#{pic.date_time.to_i}*")
      if existing_files.empty?
        pic.date_time.to_i.to_s + '.jpg'
      else
        increment_filename(existing_files)
      end
    end

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

    def handle_file(file, target_dir, filename)
      if @move
        FileUtils.move(file, File.join(target_dir, filename))
      else
        FileUtils.copy(file, File.join(target_dir, filename))
      end
    end

    def update_statistics(statistics, camera_model)
      statistics[camera_model] += 1
      statistics[:moved_or_copied] += 1
    end
  end
end
