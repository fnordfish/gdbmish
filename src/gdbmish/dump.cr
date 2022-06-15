require "base64"

module Gdbmish
  # Wrapper for different dump formats, providing various shortcut methods.
  # Currently, there is only `Ascii` mode.
  #
  # Ascii mode optionally dumps file information such as filename, owner, mode.
  # See `Dump::Ascii.new` on how they are used.
  module Dump
    struct Ascii
      # Appends and counts `#push`ed data as ASCII dump format onto `@io`.
      #
      # Users should not use this class stand-alone, as it only represents the
      # data part of an dump, without header and footer. An instance of it gets
      # yielded when using `Ascii#dump(io) { |appender| }`
      class Appender
        getter count

        def initialize(@io : IO)
          @count = 0
        end

        # Push a `{"key", "value"}` `Tuple` onto the dump
        def push(kv : {String, String}) : Nil
          @count += 1
          kv.each { |d| @io << dump_datum(d) }
        end

        # Alias for `push`
        def <<(kv : {String, String}) : Nil
          push(kv)
        end

        private def dump_datum(datum : String) : String
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

      # GDBMs does not split base64 strings at 60 encoded characters (as defined by RFC 2045).
      # See [gdbmdefs.h](https://git.gnu.org.ua/gdbm.git/tree/src/gdbmdefs.h)
      GDBM_MAX_DUMP_LINE_LEN = 76

      # Builds a new Ascii format dumper
      #
      # Dumping file information is optional.
      # * *uid*, *user*, *gid*, *group* and *mode* will only be used when *file* is given
      # * *user* will only be used when *uid* is given
      # * *group* will only be used when *gid* is given
      #
      # Example:
      # ```
      # fileoptions = {file: "test.db", uid: "1000", user: "ziggy", gid: "1000", group: "staff", mode: 0o600}
      # File.open("test.dump", "w") do |file|
      #   Gdbmish::Dump::Ascii.new(**fileoptions).dump(io) do |appender|
      #     MyDataSource.each do |key, value|
      #       appender << {key.to_s, value.to_s}
      #     end
      #   end
      # end
      # ```
      def initialize(
        @file : String? = nil,
        @uid : String? = nil,
        @user : String? = nil,
        @gid : String? = nil,
        @group : String? = nil,
        @mode : Int32? = nil
      )
      end

      def dump(io : IO, & : Appender -> _) : IO
        appender = Appender.new(io)

        dump_header!(io)
        yield appender
        dump_footer!(io, appender.count)

        return io
      end

      def dump(io : IO, data : (Hash | NamedTuple)) : IO
        appender = Appender.new(io)

        dump_header!(io)
        data.each do |k, v|
          appender << {k.to_s, v.to_s}
        end
        dump_footer!(io, appender.count)

        return io
      end

      private def dump_header!(io : IO) : Nil
        io.printf("# GDBM dump file created by GDBMish version %s on %s\n", Gdbmish::VERSION, Time.local.to_rfc2822)
        io.puts("#:version=1.1")

        if @file
          io.printf("#:file=%s\n", @file)
          l = [] of String

          if @uid
            l << sprintf("uid=%d", @uid)
            l << sprintf("user=%s", @user) if @user
          end

          if @gid
            l << sprintf("gid=%d", @gid)
            l << sprintf("group=%s", @group) if @group
          end

          @mode.try { |mode| l << sprintf("mode=%03o", mode & 0o777) }

          unless l.empty?
            io << "#:"
            io.puts(l.join(","))
          end
        end

        io.puts("#:format=standard")
        io.puts("# End of header")
      end

      private def dump_footer!(io : IO, count : Int64) : Nil
        io.printf("#:count=%d\n", count)
        io.puts("# End of data")
      end
    end

    # Dump *data* as standard ASCII format into *io*.
    #
    # For *fileoptions* see `Dump::Ascii.new`
    #
    # Example:
    # ```
    # Gdbmish::Dump.ascii({some: "data"}, io)
    # ```
    def self.ascii(data : (Hash | NamedTuple), io : IO, **fileoptions) : IO
      Ascii.new(**fileoptions).dump(io, data)
    end

    # Dump *data* as standard ASCII format into a new `String`.
    #
    # For *fileoptions* see `Dump::Ascii.new`
    #
    # Example:
    # ```
    # dump = Gdbmish::Dump.ascii({some: "data"})
    # ```
    def self.ascii(data : (Hash | NamedTuple), **fileoptions) : String
      String.build do |io|
        Ascii.new(**fileoptions).dump(io, data)
      end
    end

    # Yields a `Ascii::Appender` which consumes key-value `Tuple`s.
    # Returns a standard ASCII format as a new `String`.
    #
    # For *fileoptions* see `Dump::Ascii.new`
    #
    # Example:
    # ```
    # dump = Gdbmish::Dump.ascii do |appender|
    #   MyDataSource.each do |key, value|
    #     appender << {key.to_s, value.to_s}
    #   end
    # end
    # ```
    def self.ascii(**fileoptions, &block : Ascii::Appender -> _) : String
      String.build do |io|
        Ascii.new(**fileoptions).dump(io, &block)
      end
    end

    # Yields a `Ascii::Appender` which consumes key-value `Tuple`s.
    # Dumps a standard ASCII format into *io*.
    #
    # For *fileoptions* see `Dump::Ascii.new`
    #
    # Example:
    # ```
    # dump = Gdbmish::Dump.ascii(io) do |appender|
    #   MyDataSource.each do |key, value|
    #     appender << {key.to_s, value.to_s}
    #   end
    # end
    # ```
    def self.ascii(io : IO, **fileoptions, &block : Ascii::Appender -> _) : String
      Ascii.new(**fileoptions).dump(io, &block)
    end
  end
end
