# frozen_string_literal: true
require 'spec_helper'

describe SortJpgs do
  describe 'fun stuff' do
    it 'has a version number' do
      expect(SortJpgs::VERSION).not_to be nil
    end

    it 'can call methods' do
      increment_filename(['a'])
      expect(true).to eq(true)
    end

    it 'does something useful' do
      expect(true).to eq(true)
    end
  end

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
      puts 'before each ran'
    end

    it 'creates the target_dir' do
      test_output = File.join(test_dir, '/output')
      dummy_pic = EXIFR::JPEG.new('spec/dummy.jpg')
      target_dir = create_target_dir(dummy_pic, test_output)
      expect(target_dir).to eq(File.join(test_output, 'iPhone 5', '2013', '03', '21'))
    end

    it 'does not override existing target_dir'

    after(:each) do
      FileUtils.remove_entry_secure(test_dir)
      puts 'after each ran'
    end
  end

  describe '#create_file_basename' do
    it "creates basename if it's the first of its kind"

    it "creates basename if it's not the first of its kind"
  end
end
