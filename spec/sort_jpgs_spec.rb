# frozen_string_literal: true
require 'spec_helper'

describe SortJpgs do
  describe '#increment_filename' do
    it 'adds -1 if file exists' do
      files = ['/folder/12439870.jpg']
      expect(increment_filename(files)).to eq('12439870-1.jpg')
    end

    it 'increments properly' do
      files = ['/folder/12439870.jpg', '/folder/12439870-1.jpg']
      expect(increment_filename(files)).to eq('12439870-2.jpg')
    end

    it 'increments from 9 to 10' do
      files = ['/folder/12439870.jpg']
      (1..9).each { |i| files.push "/folder/12439870-#{i}.jpg" }
      expect(increment_filename(files)).to eq('12439870-10.jpg')
    end

    it 'increments into double digits' do
      files = ['/folder/12439870.jpg']
      (1..10).each { |i| files.push "/folder/12439870-#{i}.jpg" }
      expect(increment_filename(files)).to eq('12439870-11.jpg')
    end

    it 'increments even if first file is not there' do
      files = []
      (1..3).each { |i| files.push "/folder/12439870-#{i}.jpg" }
      expect(increment_filename(files)).to eq('12439870-4.jpg')
    end
  end

  describe '#create_target_dir' do
    test_dir = 'spec/tests/'
    before(:each) do
      FileUtils.makedirs test_dir
    end

    it 'creates the target_dir' do
      dummy_pic = EXIFR::JPEG.new('spec/dummy.jpg')
      test_output = File.join(test_dir, '/output')
      target_dir = create_target_dir(dummy_pic, test_output)
      expect(target_dir).to eq(File.join(test_output, 'iPhone 5', '2013', '03', '21'))
    end

    it 'does not override existing target_dir' do
      dummy_pic = EXIFR::JPEG.new('spec/dummy.jpg')
      test_output = File.join(test_dir, '/output')
      target_dir = create_target_dir(dummy_pic, test_output)
      creation_time = File.ctime(target_dir)
      target_dir = create_target_dir(dummy_pic, test_output)
      expect(File.ctime(target_dir)).to eq(creation_time)
    end

    after(:each) do
      FileUtils.remove_entry_secure(test_dir)
    end
  end

  describe '#create_filename and #handle_file' do
    test_dir = 'spec/tests/'
    dummy_pic = EXIFR::JPEG.new('spec/dummy.jpg')

    before(:each) do
      FileUtils.makedirs test_dir
    end

    it "creates basename if it's the first of its kind" do
      target_dir = create_target_dir(dummy_pic, File.join(test_dir, '/output'))

      filename = create_filename(dummy_pic, target_dir)
      expect(filename).to eq(dummy_pic.date_time.to_i.to_s + '.jpg')
    end

    it 'handles multiple copies without overriding one' do
      target_dir = create_target_dir(dummy_pic, File.join(test_dir, '/output'))

      filename = create_filename(dummy_pic, target_dir)
      handle_file(false, File.new('spec/dummy.jpg'), target_dir, filename)

      filename = create_filename(dummy_pic, target_dir)
      expect(filename).to eq(dummy_pic.date_time.to_i.to_s + '-1.jpg')

      handle_file(false, File.new('spec/dummy.jpg'), target_dir, filename)
      files = Dir.glob File.join(target_dir, "#{dummy_pic.date_time.to_i}*")
      expect(files.size).to eq(2)
    end

    after(:each) do
      FileUtils.remove_entry_secure(test_dir)
    end
  end
end
