require "spec_helper"

describe SortJpgs do
  
  context "basic stuff" do
    it "has a version number" do
      expect(SortJpgs::VERSION).not_to be nil
    end

    it "can call methods" do
      increment_filebasename(["a"])
      expect(true).to eq(true)
    end

    it "does something useful" do
      expect(true).to eq(true)
    end
  end

  context "increment filenames" do
    it "adds -1 if file exists" do
      files = ["/folder/12439870.jpg"]
      expect(increment_filebasename(files)).to eq("12439870-1.jpg")
    end

    it "increments properly" do
      files = ["/folder/12439870.jpg", "/folder/12439870-1.jpg"]
      expect(increment_filebasename(files)).to eq("12439870-2.jpg")
    end

    it "increments from 9 to 10" do
      files = ["/folder/12439870.jpg"]
      (1..9).each { |i| files.push "/folder/12439870-#{i}.jpg" }
      expect(increment_filebasename(files)).to eq("12439870-10.jpg")
    end

    it "increments into double digits" do
      files = ["/folder/12439870.jpg"]
      (1..10).each { |i| files.push "/folder/12439870-#{i}.jpg" }
      expect(increment_filebasename(files)).to eq("12439870-11.jpg")
    end

    it "increments even if first file is not there" do
      files = []
      (1..3).each { |i| files.push "/folder/12439870-#{i}.jpg" }
      expect(increment_filebasename(files)).to eq("12439870-4.jpg")
    end
  end

  context "create target dir" do
    it "creates the target_dir for standard output './'" do
    end

    it "creates the target_dir for non-standard output" do
    end

    it "detects existing target_dir" do
    end
  end

  context "create file basename" do
    it "creates basename if it's the first of its kind" do
    end

    it "creates basename if it's not the first of its kind" do
    end
  end
end
