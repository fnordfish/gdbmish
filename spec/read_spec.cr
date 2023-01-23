require "./spec_helper"

describe Gdbmish::Read::Ascii do
  it "can read it's own dump" do
    io = IO::Memory.new
    dumper = Gdbmish::Dump::Ascii.new(file: "test.db", uid: "1000", user: "ziggy", gid: "1000", group: "staff", mode: 0o640)
    dumper.dump(io) do |dump|
      dump << {"some_key", "Some Value"}
      dump << {"otherKey", "Other\nValue"}
    end

    io.rewind
    file = Gdbmish::Read::Ascii.new(io, load_meta: :count)

    file.data.to_h.should eq({
      "some_key" => "Some Value",
      "otherKey" => "Other\nValue",
    })

    meta = file.meta
    meta.should_not be_nil

    if meta
      meta.file.should eq "test.db"
      meta.uid.should eq "1000"
      meta.user.should eq "ziggy"
      meta.gid.should eq "1000"
      meta.group.should eq "staff"
      meta.mode.should eq 0o640
      meta.count.should eq(2)
    end
  end

  it "load_meta: false skips loading meta" do
    f = Gdbmish::Read::Ascii.new(dumped_file, load_meta: false)
    f.meta.should be_nil
    f.data.to_h.should eq(data_hash)
  end

  it "load_meta: true skips loading count in meta" do
    f = Gdbmish::Read::Ascii.new(dumped_file, load_meta: true)

    meta = f.meta
    meta.should be_a(Gdbmish::Read::AsciiMetaData)
    meta.count.should be_nil if meta

    f.data.to_h.should eq(data_hash)
  end

  it "load_meta: :count loads count in meta" do
    f = Gdbmish::Read::Ascii.new(dumped_file, load_meta: :count)

    meta = f.meta
    meta.should be_a(Gdbmish::Read::AsciiMetaData)
    meta.count.should eq(data_hash.size) if meta

    f.data.to_h.should eq(data_hash)
  end
end

describe Gdbmish::Read::AsciiMetaData do
  describe ".parse" do
    it "Reads meta data_hash, skiping count" do
      metae_data = Gdbmish::Read::AsciiMetaData.parse(dumped_file)
      metae_data.count.should be_nil
      metae_data.file.should eq "spec/fixtures/test.db"
      metae_data.gid.should eq "20"
      metae_data.group.should eq "staff"
      metae_data.mode.should eq 0o644
      metae_data.uid.should eq "501"
      metae_data.user.should eq "robertschulze"
      metae_data.version.should eq "1.1"
    end
  end

  describe ".parse ignore_count: false" do
    it "Reads meta data_hash, including count" do
      meta_data = Gdbmish::Read::AsciiMetaData.parse(dumped_file, ignore_count: false)
      meta_data.count.should eq data_hash.size
      meta_data.file.should eq "spec/fixtures/test.db"
      meta_data.gid.should eq "20"
      meta_data.group.should eq "staff"
      meta_data.mode.should eq 0o644
      meta_data.uid.should eq "501"
      meta_data.user.should eq "robertschulze"
      meta_data.version.should eq "1.1"
    end
  end
end

describe Gdbmish::Read::AsciiLineIterator do
  it "iterates over encoded keys and values" do
    read_data = Gdbmish::Read::AsciiLineIterator.new(dumped_file).to_a
    data_keys_values_encoded = data_hash.to_a.flat_map &.to_a.map { |d| Base64.strict_encode(d) }

    read_data.should eq(data_keys_values_encoded)
  end
end

describe Gdbmish::Read::AsciiDataIterator do
  it "iterates over decoded keys and values" do
    read_data = Gdbmish::Read::AsciiDataIterator.new(dumped_file).to_h

    read_data.should eq(data_hash)
  end
end
