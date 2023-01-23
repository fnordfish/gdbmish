require "spec"
require "../src/gdbmish"

# Data from `spec/fixtures/data.rb` but as crystal data.
# gdbm/gdbm_dump does not seem to keep order, so we need
# to re-order our data to match the dumped data :(

DATA_HASH = {
  "multiline content"    => "This is a\nmultiline\n\nstring.\n",
  "föö"                  => "bää\n🤦‍♂️",
  "mixed crlf content"   => "This is a\rmultiline string\r\nwith mixed\r\n\nnewlines.\n",
  "double-éscapè:\\\\c3" => "A\\TEST\\c3élene",
  "foo2"                 => "bar2",
  "foo"                  => ("bar-"*128),
}

DATA_TUPLE = {
  "multiline content":    "This is a\nmultiline\n\nstring.\n",
  "föö":                  "bää\n🤦‍♂️",
  "mixed crlf content":   "This is a\rmultiline string\r\nwith mixed\r\n\nnewlines.\n",
  "double-éscapè:\\\\c3": "A\\TEST\\c3élene",
  "foo2":                 "bar2",
  "foo":                  ("bar-"*128),
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
