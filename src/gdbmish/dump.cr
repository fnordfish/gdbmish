require "base64"

module Gdbmish
  module Dump
    # GDBMs does not split base64 strings at 60 encoded characters (as defined by RFC 2045).
    # See [gdbmdefs.h](https://git.gnu.org.ua/gdbm.git/tree/src/gdbmdefs.h)
    GDBM_MAX_DUMP_LINE_LEN = 76

    # Dump the given data in standard ASCII format into a provided `IO`.
    #
    # Dumping file information is optional.
    # * *uid*, *user*, *gid*, *group* and *mode* will only be used when *file* is given
    # * *user* will only be used when *uid* is given
    # * *group* will only be used when *gid* is given
    def self.ascii(
      data : (Hash | NamedTuple),
      io : (IO),
      file : String? = nil,
      uid : String? = nil,
      user : String? = nil,
      gid : String? = nil,
      group : String? = nil,
      mode : Int32? = nil
    )
      io.printf("# GDBM dump file created by GDBMish version %s on %s\n", Gdbmish::VERSION, Time.local.to_rfc2822)
      io.puts("#:version=1.1")

      if file
        io.printf("#:file=%s\n", file)
        l = [] of String

        if uid
          l << sprintf("uid=%d", uid)
          l << sprintf("user=%s", user) if user
        end

        if gid
          l << sprintf("gid=%d", gid)
          l << sprintf("group=%s", group) if group
        end

        l << sprintf("mode=%03o", mode & 0o777) if mode

        unless l.empty?
          io << "#:"
          io.puts(l.join(","))
        end
      end

      io.puts("#:format=standard")
      io.puts("# End of header")

      data.each do |k, v|
        io << ascii_dump_datum(k.to_s)
        io << ascii_dump_datum(v.to_s)
      end

      io.printf("#:count=%d\n", data.size)
      io.puts("# End of data")
    end

    # Like `ascii` but builds a new `String`
    def self.ascii(data : (Hash | NamedTuple), **options) : String
      String.build do |str|
        self.ascii(
          data,
          str,
          **options
        )
      end
    end

    private def self.ascii_dump_datum(datum : String) : String
      String.build do |str|
        str.printf("#:len=%d\n", datum.bytesize)
        str.puts(Base64.strict_encode(datum).try do |enc|
          if enc.size > GDBM_MAX_DUMP_LINE_LEN
            slices = enc.each_char.each_slice(GDBM_MAX_DUMP_LINE_LEN)
            slices.map(&.join).join("\n")
          else
            enc
          end
        end)
      end
    end
  end
end
