require "./spec_helper"

data = {
  föö:  "bää\n🤦‍♂️",
  foo2: "bar2",
  foo:  ("bar-"*128),
}
dumped_without_header = File.read("spec/fixtures/test.dump").split("# End of header\n")[1]

describe Gdbmish do
  describe Gdbmish::Dump do
    it "Dumps NamedTuple" do
      Gdbmish::Dump.ascii(data).should end_with(dumped_without_header)
    end

    it "Dumps Hash" do
      Gdbmish::Dump.ascii(data.to_h).should end_with(dumped_without_header)
    end

    it "Dumps into an IO" do
      io = IO::Memory.new
      io << "# my open IO"

      Gdbmish::Dump.ascii(data, io)
      str = io.to_s
      str.should start_with("# my open IO")
      str.should end_with(dumped_without_header)
    end

    it "Dumps filename and permissions" do
      str = Gdbmish::Dump.ascii(data, file: "test.db", uid: "501", user: "robertschulze", gid: "20", group: "staff", mode: 0o600)
      str.should contain("#:file=test.db")
      str.should contain("#:uid=501,user=robertschulze,gid=20,group=staff,mode=600")
    end

    it "Dumps filename and partial permissions" do
      str = Gdbmish::Dump.ascii(data, file: "test.db", uid: "501", gid: "20", mode: 0o600)
      str.should contain("#:file=test.db")
      str.should contain("#:uid=501,gid=20,mode=600")
    end

    it "Dumps skips permissions if filename is missing" do
      str = Gdbmish::Dump.ascii(data, uid: "501", gid: "20", mode: 0o600)
      str.should_not contain("#:file=test.db")
      str.should_not contain("uid=501")
      str.should_not contain("gid=20")
      str.should_not contain("mode=600")
    end

    it "keeps lines at GDBM_MAX_DUMP_LINE_LEN" do
      data.values.any? { |v| v.size > Gdbmish::Dump::GDBM_MAX_DUMP_LINE_LEN }.should be_true
      Gdbmish::Dump.ascii(data).split("# End of header\n")[1].each_line do |line|
        line.size.should be <= Gdbmish::Dump::GDBM_MAX_DUMP_LINE_LEN
      end
    end
  end
end
