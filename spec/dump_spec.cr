require "./spec_helper"

describe Gdbmish::Dump do
  describe ".ascii" do
    it "Dumps NamedTuple" do
      Gdbmish::Dump.ascii(data_tuple).should end_with(dumped_without_header)
    end

    it "Dumps Hash" do
      Gdbmish::Dump.ascii(data_hash).should end_with(dumped_without_header)
    end

    it "Dumps into an IO" do
      io = IO::Memory.new
      io << "# my open IO"

      Gdbmish::Dump.ascii(data_hash, io)
      str = io.to_s
      str.should start_with("# my open IO")
      str.should end_with(dumped_without_header)
    end

    it "Dumps filename and permissions" do
      str = Gdbmish::Dump.ascii(data_hash, file: "test.db", uid: "501", user: "robertschulze", gid: "20", group: "staff", mode: 0o600)
      str.should contain("#:file=test.db")
      str.should contain("#:uid=501,user=robertschulze,gid=20,group=staff,mode=600")
    end

    it "Dumps filename and partial permissions" do
      str = Gdbmish::Dump.ascii(data_hash, file: "test.db", uid: "501", gid: "20", mode: 0o600)
      str.should contain("#:file=test.db")
      str.should contain("#:uid=501,gid=20,mode=600")
    end

    it "Dumps skips permissions if filename is missing" do
      str = Gdbmish::Dump.ascii(data_hash, uid: "501", gid: "20", mode: 0o600)
      str.should_not contain("#:file=test.db")
      str.should_not contain("uid=501")
      str.should_not contain("gid=20")
      str.should_not contain("mode=600")
    end

    it "keeps lines at GDBM_MAX_DUMP_LINE_LEN" do
      data_hash.values.any? { |v| v.size > Gdbmish::Dump::Ascii::GDBM_MAX_DUMP_LINE_LEN }.should be_true
      Gdbmish::Dump.ascii(data_hash).split("# End of header\n")[1].each_line do |line|
        line.size.should be <= Gdbmish::Dump::Ascii::GDBM_MAX_DUMP_LINE_LEN
      end
    end

    it "run using generator/consumer api" do
      str = Gdbmish::Dump.ascii do |dump|
        data_hash.each do |k, v|
          dump << {k.to_s, v.to_s}
        end
      end

      str.should end_with(dumped_without_header)
    end
  end
end

describe Gdbmish::Dump::Ascii do
  fileoptions = {file: "test.db", uid: "1000", user: "ziggy", gid: "1000", group: "staff", mode: 0o600}

  it "#dump with block" do
    io = IO::Memory.new
    Gdbmish::Dump::Ascii.new(**fileoptions).dump(io) do |dump|
      data_hash.each do |key, value|
        dump << {key.to_s, value.to_s}
      end
    end
    str = io.to_s
    str.should contain("#:file=test.db")
    str.should contain("#:uid=1000,user=ziggy,gid=1000,group=staff,mode=600")
    str.should end_with(dumped_without_header)
  end

  it "#dump with data_hash" do
    io = IO::Memory.new
    Gdbmish::Dump::Ascii.new(**fileoptions).dump(io, data_hash)
    str = io.to_s
    str.should contain("#:file=test.db")
    str.should contain("#:uid=1000,user=ziggy,gid=1000,group=staff,mode=600")
    str.should end_with(dumped_without_header)
  end
end
