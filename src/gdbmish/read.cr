require "base64"

module Gdbmish
  # Wrapper for reading GDBM dump files. Currently, only Ascii (aka standard) format is supported.
  #
  # See `Read::Ascii` for the main high level interface.
  module Read
    # Main abstraction to read an GDBM Ascii dump file (aka "standard format")
    #
    # Example:
    # ```
    # io = File.open("path/to/file.dump")
    # file = Gdbmish::Read::Ascii.new(io)
    #
    # file.data do |key, value|
    #   puts "#{key.inspect} => #{value.inspect}"
    # end
    # pp file.meta
    #
    # # Note: your `io`'s file pointer posistion has changed.
    # io.pos # => 317
    # ```
    #
    # Produces:
    #
    # ```text
    # "some_key" => "Some Value"
    # "otherKey" => "Other\nValue"
    # Gdbmish::Read::AsciiMetaData(
    #  @count=nil,
    #  @file="test.db",
    #  @gid="1000",
    #  @group="staff",
    #  @mode=384,
    #  @uid="1000",
    #  @user="ziggy",
    #  @version="1.1")
    # ```
    struct Ascii
      @meta : AsciiMetaData?

      # Create a new Ascii reader.
      #
      # - *io* is assumed to point to the beginning of the GDBM dump.
      # - *load_meta* can take three values:
      #   + `true`: (default) load meta data, but skip `count` for preformance reasons.
      #   + `false`: skip loading meta data.
      #   + `:count`: load meta data, including `count`.
      def initialize(@io : IO, @load_meta : Bool | Symbol = true)
      end

      # Returns an Iterator over key/value pairs.
      #
      # Depending on the size of the dataset, you might want to read everything into an Array or Hash:
      # ```
      # Ascii.new(io).data.to_a # => [{"some_key", "Some Value"}, {"otherKey", "Other\nValue"}]
      # Ascii.new(io).data.to_h # => {"some_key" => "Some Value", "otherKey" => "Other\nValue"}
      # ```
      def data : AsciiDataIterator
        load_meta
        AsciiDataIterator.new(@io)
      end

      # Shortcut for `data.each { |key, value| }`
      def data(&block : (String, String?) -> _) : Nil
        data.each(&block)
      end

      # Parses for meta data, depending on the *load_meta* value in `new`
      def meta : AsciiMetaData?
        load_meta
      end

      private def load_meta : AsciiMetaData?
        return unless @load_meta

        @meta ||= AsciiMetaData.parse(@io, ignore_count: @load_meta != :count)
      end
    end

    # Header and footer meta data from a GDBM Ascii dump file.
    struct AsciiMetaData
      getter version : String?
      getter file : String?
      getter uid : String?
      getter user : String?
      getter gid : String?
      getter group : String?
      # octal unix file mode
      getter mode : Int32?
      getter count : UInt64?

      def initialize(@version = nil, @file = nil, @uid = nil, @user = nil, @gid = nil, @group = nil, @mode = nil, @count = nil)
      end

      # Parse given IO for meta data.
      # Reads from +io+ until a `"# End of header"` line is found (enhancing its `pos`).
      # By default, ignores reading the `count` (indecating the amount of datasets in the file) because it is written at the end of the file.
      def self.parse(io : IO, ignore_count = true)
        version : String? = nil
        file : String? = nil
        uid : String? = nil
        user : String? = nil
        gid : String? = nil
        group : String? = nil
        mode : Int32? = nil
        count : UInt64? = nil

        while line = io.gets
          break if line == "# End of header"

          next unless line.starts_with?("#:")

          line[2..].split(',').map(&.split('=')).each do |(k, v)|
            case k
            when "version"
              version = v
            when "file"
              file = v
            when "uid"
              uid = v
            when "user"
              user = v
            when "gid"
              gid = v
            when "group"
              group = v
            when "mode"
              mode = v.to_i32(base: 8)
            end
          end
        end

        count = read_count(io) unless ignore_count

        AsciiMetaData.new(version: version, file: file, uid: uid, user: user, gid: gid, group: group, mode: mode, count: count)
      end

      private def self.read_count(io : IO) : UInt64?
        count : UInt64?
        end_of_header_pos : Int32 | Int64 | Nil

        begin
          end_of_header_pos = io.pos
        rescue
          # ignore, this io does not support pos
        end

        return if end_of_header_pos.nil?

        while line = io.gets
          next unless line.starts_with?("#:count")
          count = line.split('=')[1].to_u64
        end
        io.pos = end_of_header_pos

        count
      end
    end

    # Iterates over lines, skiping comments, joining wrapped lines.
    # Lines are alternating key or value in encodded form.
    struct AsciiLineIterator(I)
      include Iterator(String)

      # Comment lines start with '#'
      private COMMENT_BYTE = 35

      def initialize(@io : I)
      end

      # :nodoc: Fall back to using closure variable for Crystal 1.0.0. Use "break value" for later versions
      private macro def_next
        def next : String | Iterator::Stop
          {% if Crystal::VERSION == "1.0.0" %}
          data : String?
          {% end %}
          while line = @io.gets
            next if line.not_nil!.each_byte.first == COMMENT_BYTE

            data = String.build do |str|
              str << line

              while !next_is_comment?
                str << @io.gets
              end
            end

            break {% if Crystal::VERSION > "1.0.0" %} data {% end %}
          end {% if Crystal::VERSION > "1.0.0" %} || stop {% else %}
          data.nil? ? stop : data.not_nil!
          {% end %}
        end
      end

      def_next

      private def next_is_comment?
        next_byte = @io.read_byte
        return false if next_byte.nil?

        @io.seek(-1, IO::Seek::Current)
        next_byte == COMMENT_BYTE
      end
    end

    # Iterates over data and returns decoded key/value pairs.
    struct AsciiDataIterator(I)
      include Iterator({String, String?})
      include IteratorWrapper

      def initialize(@io : I)
        @iterator = AsciiLineIterator(I).new(@io)
      end

      def next
        if (k = wrapped_next).is_a?(Iterator::Stop)
          return k
        else
          k = Base64.decode_string(k)
        end

        if (v = wrapped_next).is_a?(Iterator::Stop)
          v = nil
        else
          v = Base64.decode_string(v)
        end

        {k, v}
      end
    end
  end
end
