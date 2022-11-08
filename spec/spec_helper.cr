require "spec"
require "../src/gdbmish"

DATA_HASH = {
  "föö"  => "bää\n🤦‍♂️",
  "foo2" => "bar2",
  "foo"  => ("bar-"*128),
}

DATA_TUPLE = {
  föö:  "bää\n🤦‍♂️",
  foo2: "bar2",
  foo:  ("bar-"*128),
}

DUMPED_FILE = "spec/fixtures/test.dump"

DUMPED_FULL = File.read(DUMPED_FILE)

def data_hash
  DATA_HASH
end

def data_tuple
  DATA_TUPLE
end

def dumped_file
  File.open(DUMPED_FILE)
end

def dumped_without_header
  DUMPED_FULL.split("# End of header\n")[1]
end
