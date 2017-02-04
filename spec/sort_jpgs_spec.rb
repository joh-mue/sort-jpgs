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
    it "creates the target_dir for standard output './'"

    it 'creates the target_dir for non-standard output'

    it 'detects existing target_dir'
  end

  describe '#create_file_basename' do
    it "creates basename if it's the first of its kind"

    it "creates basename if it's not the first of its kind"
  end
end
