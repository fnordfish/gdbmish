require "./gdbmish/*"

# See `Gdbmish::Dump` for generating dumps from data
module Gdbmish
  VERSION = {{ "#{system("shards version #{__DIR__}").strip}" }}
end
