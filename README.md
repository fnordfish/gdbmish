# GDBMish

Convert crystal data structures into a `gdbm_dump` ASCII format.

Citing [gdbm](https://git.gnu.org.ua/gdbm.git/tree/NOTE-WARNING):
> Gdbm files have never been `portable' between different operating systems,
> system architectures, or potentially even different compilers.  Differences
> in byte order, the size of file offsets, and even structure packing make
> gdbm files non-portable.
> 
> Therefore, if you intend to send your database to somebody over the wire,
> please dump it into a portable format using gdbm_dump and send the resulting
> file instead. The receiving party will be able to recreate the database from
> the dump using the gdbm_load command.

GDBMish does that by reimplementing the `gdbm_dump` ASCII format without compiling against `gdbm`

[![GitHub release](https://img.shields.io/github/release/fnordfish/gdbmish.svg)](https://github.com/fnordfish/gdbmish/releases)
[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://fnordfish.github.io/gdbmish/)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     gdbmish:
       github: fnordfish/gdbmish
   ```

2. Run `shards install`

## Usage

Create a GDBM Dump:

```crystal
require "gdbmish"

# Get dump as String
string = Gdbmish::Dump.ascii({"key1" => "value", "key2" => "value2"})

# Write directly into File (or any other IO)
File.open("my_db.dump", "w") do |file|
  Gdbmish::Dump.ascii({"key1" => "value", "key2" => "value2"}, file)
end

# Provide an original filename
Gdbmish::Dump.ascii(data, file: "my.db")

# Provide an original filename and file permissions
Gdbmish::Dump.ascii(data, file: "my.db", uid: "1000", gid: "1000", mode: 0o600)

# Iterate over a data source and push onto an IO
fileoptions = {file: "my.db", uid: "1000", user: "ziggy", gid: "1000", group: "staff", mode: 0o600}
File.open("my.dump", "w") do |file|
  Gdbmish::Dump::Ascii.new(**fileoptions).dump(io) do |appender|
    MyDataSource.each do |key, value|
      appender << {key.to_s, value.to_s}
    end
  end
end
```

On the target host, use a tool like `gdbm_load` to convert the dump into a db that works with that hosts gdbm.

Read a GDBM Dump:

```crystal
reader = Gdbmish::Read::Ascii.new(File.open("my.dump"))

# get meta data
reader.meta.file # => "my.db"

# either iterate over data:
reader.data do |key, value|
  puts "#{key.inspect} => #{value.inspect}"
end

# or use the Iterator to transform into Hash
reader.data.to_h
```

## Development

* Run specs using `crystal spec`
* Format files using `crystal tool format`

## Limitations

* Currently only supports the ASCII format and not the Binary format

## Contributing

1. Fork it (<https://github.com/fnordfish/gdbmish/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Robert Schulze](https://github.com/fnordfish) - creator and maintainer
