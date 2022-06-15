require "spec"
require "../src/gdbmish"

DATA = {
  föö:  "bää\n🤦‍♂️",
  foo2: "bar2",
  foo:  ("bar-"*128),
}
def data
  DATA
end

DUMPED_WITHOUT_HEADER = File.read("spec/fixtures/test.dump").split("# End of header\n")[1]
def dumped_without_header
  DUMPED_WITHOUT_HEADER
end
