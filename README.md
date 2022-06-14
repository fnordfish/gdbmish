# GDBMish

Convert crystal data structures into a `gdpm_dump` ASCII format.

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

GDBMish does that by reimplementing the `gdpm_dump` ASCII format without compiling against `gdbm`

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     gdbmish:
       github: fnordfish/gdbmish
   ```

2. Run `shards install`

## Usage

```crystal
require "gdbmish"
```

```crystal
# Get dump as String
string = Gdbmish::Dump.ascii({"key1" => "value", "key2" => value})

# Write directly into File (or any other IO)
File.open("my_db.dump", "w") do |file|
  Gdbmish::Dump.ascii({"key1" => "value", "key2" => value}, file)
end

# Provide an original filename
Gdbmish::Dump.ascii(data, file: "my.db")

# Provide an original filename and file permissions
Gdbmish::Dump.ascii(data, file: "my.db", uid: "1000", gid: "1000", mode: 0o600)
```

## Development

TODO: Write development instructions here

## Limitations

* Currently only supports the ASCII format and not the Binary format
* Currently requires a `Hash` or `NamedTuple` with `String` keys and values
  + it would be nice to provide a "consumer" style API for dumping larger data sets
* Currently only supports creating a dump
  + it would be nice to also read dumps 

## Contributing

1. Fork it (<https://github.com/fnordfish/gdbmish/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Robert Schulze](https://github.com/fnordfish) - creator and maintainer
