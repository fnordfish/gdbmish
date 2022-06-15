crystal_doc_search_index_callback({"repository_name":"gdbmish","body":"# GDBMish\n\nConvert crystal data structures into a `gdpm_dump` ASCII format.\n\nCiting [gdbm](https://git.gnu.org.ua/gdbm.git/tree/NOTE-WARNING):\n> Gdbm files have never been `portable' between different operating systems,\n> system architectures, or potentially even different compilers.  Differences\n> in byte order, the size of file offsets, and even structure packing make\n> gdbm files non-portable.\n> \n> Therefore, if you intend to send your database to somebody over the wire,\n> please dump it into a portable format using gdbm_dump and send the resulting\n> file instead. The receiving party will be able to recreate the database from\n> the dump using the gdbm_load command.\n\nGDBMish does that by reimplementing the `gdpm_dump` ASCII format without compiling against `gdbm`\n\n[![GitHub release](https://img.shields.io/github/release/fnordfish/gdbmish.svg)](https://github.com/fnordfish/gdbmish/releases)\n[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://fnordfish.github.io/gdbmish/)\n\n## Installation\n\n1. Add the dependency to your `shard.yml`:\n\n   ```yaml\n   dependencies:\n     gdbmish:\n       github: fnordfish/gdbmish\n   ```\n\n2. Run `shards install`\n\n## Usage\n\nCreate a GDBM Dump:\n\n```crystal\nrequire \"gdbmish\"\n\n# Get dump as String\nstring = Gdbmish::Dump.ascii({\"key1\" => \"value\", \"key2\" => value})\n\n# Write directly into File (or any other IO)\nFile.open(\"my_db.dump\", \"w\") do |file|\n  Gdbmish::Dump.ascii({\"key1\" => \"value\", \"key2\" => value}, file)\nend\n\n# Provide an original filename\nGdbmish::Dump.ascii(data, file: \"my.db\")\n\n# Provide an original filename and file permissions\nGdbmish::Dump.ascii(data, file: \"my.db\", uid: \"1000\", gid: \"1000\", mode: 0o600)\n\n# Iterate over a data source and push onto an IO\nfileoptions = {file: \"my.db\", uid: \"1000\", user: \"ziggy\", gid: \"1000\", group: \"staff\", mode: 0o600}\nFile.open(\"my.dump\", \"w\") do |file|\n  Gdbmish::Dump::Ascii.new(**fileoptions).dump(io) do |appender|\n    MyDataSource.each do |key, value|\n      appender << {key.to_s, value.to_s}\n    end\n  end\nend\n```\n\nOn the target host, use a tool like `gdbm_load` to convert the dump into a db that works with that hosts gdbm.\n\n## Development\n\nTODO: Write development instructions here\n\n## Limitations\n\n* Currently only supports the ASCII format and not the Binary format\n* Currently only supports creating a dump\n  + it would be nice to also read dumps \n\n## Contributing\n\n1. Fork it (<https://github.com/fnordfish/gdbmish/fork>)\n2. Create your feature branch (`git checkout -b my-new-feature`)\n3. Commit your changes (`git commit -am 'Add some feature'`)\n4. Push to the branch (`git push origin my-new-feature`)\n5. Create a new Pull Request\n\n## Contributors\n\n- [Robert Schulze](https://github.com/fnordfish) - creator and maintainer\n","program":{"html_id":"gdbmish/toplevel","path":"toplevel.html","kind":"module","full_name":"Top Level Namespace","name":"Top Level Namespace","abstract":false,"locations":[],"repository_name":"gdbmish","program":true,"enum":false,"alias":false,"const":false,"types":[{"html_id":"gdbmish/Gdbmish","path":"Gdbmish.html","kind":"module","full_name":"Gdbmish","name":"Gdbmish","abstract":false,"locations":[{"filename":"src/gdbmish.cr","line_number":4,"url":"https://github.com/fnordfish/gdbmish/blob/22a1f40bc10bbfeae19bc26cb7dde8ccc710f29c/src/gdbmish.cr#L4"},{"filename":"src/gdbmish/dump.cr","line_number":3,"url":"https://github.com/fnordfish/gdbmish/blob/22a1f40bc10bbfeae19bc26cb7dde8ccc710f29c/src/gdbmish/dump.cr#L3"}],"repository_name":"gdbmish","program":false,"enum":false,"alias":false,"const":false,"constants":[{"id":"VERSION","name":"VERSION","value":"{{ \"#{(system(\"shards version\")).strip}\" }}"}],"doc":"See `Gdbmish::Dump` for generating dumps from data","summary":"<p>See <code><a href=\"Gdbmish/Dump.html\">Gdbmish::Dump</a></code> for generating dumps from data</p>","types":[{"html_id":"gdbmish/Gdbmish/Dump","path":"Gdbmish/Dump.html","kind":"module","full_name":"Gdbmish::Dump","name":"Dump","abstract":false,"locations":[{"filename":"src/gdbmish/dump.cr","line_number":9,"url":"https://github.com/fnordfish/gdbmish/blob/22a1f40bc10bbfeae19bc26cb7dde8ccc710f29c/src/gdbmish/dump.cr#L9"}],"repository_name":"gdbmish","program":false,"enum":false,"alias":false,"const":false,"namespace":{"html_id":"gdbmish/Gdbmish","kind":"module","full_name":"Gdbmish","name":"Gdbmish"},"doc":"Wrapper for different dump formats, providing various shortcut methods.\nCurrently, there is only `Ascii` mode.\n\nAscii mode optionally dumps file information such as filename, owner, mode.\nSee `Dump::Ascii.new` on how they are used.","summary":"<p>Wrapper for different dump formats, providing various shortcut methods.</p>","class_methods":[{"html_id":"ascii(data:Hash|NamedTuple,io:IO,**fileoptions):IO-class-method","name":"ascii","doc":"Dump *data* as standard ASCII format into *io*.\n\nFor *fileoptions* see `Dump::Ascii.new`\n\nExample:\n```\nGdbmish::Dump.ascii({some: \"data\"}, io)\n```","summary":"<p>Dump <em>data</em> as standard ASCII format into <em>io</em>.</p>","abstract":false,"args":[{"name":"data","external_name":"data","restriction":"Hash | NamedTuple"},{"name":"io","external_name":"io","restriction":"IO"}],"args_string":"(data : Hash | NamedTuple, io : IO, **fileoptions) : IO","args_html":"(data : Hash | NamedTuple, io : IO, **fileoptions) : IO","location":{"filename":"src/gdbmish/dump.cr","line_number":147,"url":"https://github.com/fnordfish/gdbmish/blob/22a1f40bc10bbfeae19bc26cb7dde8ccc710f29c/src/gdbmish/dump.cr#L147"},"def":{"name":"ascii","args":[{"name":"data","external_name":"data","restriction":"Hash | NamedTuple"},{"name":"io","external_name":"io","restriction":"IO"}],"double_splat":{"name":"fileoptions","external_name":"fileoptions","restriction":""},"return_type":"IO","visibility":"Public","body":"(Ascii.new(**fileoptions)).dump(io, data)"}},{"html_id":"ascii(data:Hash|NamedTuple,**fileoptions):String-class-method","name":"ascii","doc":"Dump *data* as standard ASCII format into a new `String`.\n\nFor *fileoptions* see `Dump::Ascii.new`\n\nExample:\n```\ndump = Gdbmish::Dump.ascii({some: \"data\"})\n```","summary":"<p>Dump <em>data</em> as standard ASCII format into a new <code>String</code>.</p>","abstract":false,"args":[{"name":"data","external_name":"data","restriction":"Hash | NamedTuple"}],"args_string":"(data : Hash | NamedTuple, **fileoptions) : String","args_html":"(data : Hash | NamedTuple, **fileoptions) : String","location":{"filename":"src/gdbmish/dump.cr","line_number":159,"url":"https://github.com/fnordfish/gdbmish/blob/22a1f40bc10bbfeae19bc26cb7dde8ccc710f29c/src/gdbmish/dump.cr#L159"},"def":{"name":"ascii","args":[{"name":"data","external_name":"data","restriction":"Hash | NamedTuple"}],"double_splat":{"name":"fileoptions","external_name":"fileoptions","restriction":""},"return_type":"String","visibility":"Public","body":"String.build do |io|\n  (Ascii.new(**fileoptions)).dump(io, data)\nend"}},{"html_id":"ascii(io:IO,**fileoptions,&block:Ascii::Appender->_):String-class-method","name":"ascii","doc":"Yields a `Ascii::Appender` which consumes key-value `Tuple`s.\nDumps a standard ASCII format into *io*.\n\nFor *fileoptions* see `Dump::Ascii.new`\n\nExample:\n```\ndump = Gdbmish::Dump.ascii(io) do |appender|\n  MyDataSource.each do |key, value|\n    appender << {key.to_s, value.to_s}\n  end\nend\n```","summary":"<p>Yields a <code><a href=\"../Gdbmish/Dump/Ascii/Appender.html\">Ascii::Appender</a></code> which consumes key-value <code>Tuple</code>s.</p>","abstract":false,"args":[{"name":"io","external_name":"io","restriction":"IO"}],"args_string":"(io : IO, **fileoptions, &block : Ascii::Appender -> _) : String","args_html":"(io : IO, **fileoptions, &block : <a href=\"../Gdbmish/Dump/Ascii/Appender.html\">Ascii::Appender</a> -> _) : String","location":{"filename":"src/gdbmish/dump.cr","line_number":197,"url":"https://github.com/fnordfish/gdbmish/blob/22a1f40bc10bbfeae19bc26cb7dde8ccc710f29c/src/gdbmish/dump.cr#L197"},"def":{"name":"ascii","args":[{"name":"io","external_name":"io","restriction":"IO"}],"double_splat":{"name":"fileoptions","external_name":"fileoptions","restriction":""},"yields":1,"block_arg":{"name":"block","external_name":"block","restriction":"(Ascii::Appender -> _)"},"return_type":"String","visibility":"Public","body":"(Ascii.new(**fileoptions)).dump(io, &block)"}},{"html_id":"ascii(**fileoptions,&block:Ascii::Appender->_):String-class-method","name":"ascii","doc":"Yields a `Ascii::Appender` which consumes key-value `Tuple`s.\nReturns a standard ASCII format as a new `String`.\n\nFor *fileoptions* see `Dump::Ascii.new`\n\nExample:\n```\ndump = Gdbmish::Dump.ascii do |appender|\n  MyDataSource.each do |key, value|\n    appender << {key.to_s, value.to_s}\n  end\nend\n```","summary":"<p>Yields a <code><a href=\"../Gdbmish/Dump/Ascii/Appender.html\">Ascii::Appender</a></code> which consumes key-value <code>Tuple</code>s.</p>","abstract":false,"location":{"filename":"src/gdbmish/dump.cr","line_number":178,"url":"https://github.com/fnordfish/gdbmish/blob/22a1f40bc10bbfeae19bc26cb7dde8ccc710f29c/src/gdbmish/dump.cr#L178"},"def":{"name":"ascii","double_splat":{"name":"fileoptions","external_name":"fileoptions","restriction":""},"yields":1,"block_arg":{"name":"block","external_name":"block","restriction":"(Ascii::Appender -> _)"},"return_type":"String","visibility":"Public","body":"String.build do |io|\n  (Ascii.new(**fileoptions)).dump(io, &block)\nend"}}],"types":[{"html_id":"gdbmish/Gdbmish/Dump/Ascii","path":"Gdbmish/Dump/Ascii.html","kind":"struct","full_name":"Gdbmish::Dump::Ascii","name":"Ascii","abstract":false,"superclass":{"html_id":"gdbmish/Struct","kind":"struct","full_name":"Struct","name":"Struct"},"ancestors":[{"html_id":"gdbmish/Struct","kind":"struct","full_name":"Struct","name":"Struct"},{"html_id":"gdbmish/Value","kind":"struct","full_name":"Value","name":"Value"},{"html_id":"gdbmish/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/gdbmish/dump.cr","line_number":10,"url":"https://github.com/fnordfish/gdbmish/blob/22a1f40bc10bbfeae19bc26cb7dde8ccc710f29c/src/gdbmish/dump.cr#L10"}],"repository_name":"gdbmish","program":false,"enum":false,"alias":false,"const":false,"constants":[{"id":"GDBM_MAX_DUMP_LINE_LEN","name":"GDBM_MAX_DUMP_LINE_LEN","value":"76","doc":"GDBMs does not split base64 strings at 60 encoded characters (as defined by RFC 2045).\nSee [gdbmdefs.h](https://git.gnu.org.ua/gdbm.git/tree/src/gdbmdefs.h)","summary":"<p>GDBMs does not split base64 strings at 60 encoded characters (as defined by RFC 2045).</p>"}],"namespace":{"html_id":"gdbmish/Gdbmish/Dump","kind":"module","full_name":"Gdbmish::Dump","name":"Dump"},"constructors":[{"html_id":"new(file:String?=nil,uid:String?=nil,user:String?=nil,gid:String?=nil,group:String?=nil,mode:Int32?=nil)-class-method","name":"new","doc":"Builds a new Ascii format dumper\n\nDumping file information is optional.\n* *uid*, *user*, *gid*, *group* and *mode* will only be used when *file* is given\n* *user* will only be used when *uid* is given\n* *group* will only be used when *gid* is given\n\nExample:\n```\nfileoptions = {file: \"test.db\", uid: \"1000\", user: \"ziggy\", gid: \"1000\", group: \"staff\", mode: 0o600}\nFile.open(\"test.dump\", \"w\") do |file|\n  Gdbmish::Dump::Ascii.new(**fileoptions).dump(io) do |appender|\n    MyDataSource.each do |key, value|\n      appender << {key.to_s, value.to_s}\n    end\n  end\nend\n```","summary":"<p>Builds a new Ascii format dumper</p>","abstract":false,"args":[{"name":"file","default_value":"nil","external_name":"file","restriction":"String | ::Nil"},{"name":"uid","default_value":"nil","external_name":"uid","restriction":"String | ::Nil"},{"name":"user","default_value":"nil","external_name":"user","restriction":"String | ::Nil"},{"name":"gid","default_value":"nil","external_name":"gid","restriction":"String | ::Nil"},{"name":"group","default_value":"nil","external_name":"group","restriction":"String | ::Nil"},{"name":"mode","default_value":"nil","external_name":"mode","restriction":"Int32 | ::Nil"}],"args_string":"(file : String? = nil, uid : String? = nil, user : String? = nil, gid : String? = nil, group : String? = nil, mode : Int32? = nil)","args_html":"(file : String? = <span class=\"n\">nil</span>, uid : String? = <span class=\"n\">nil</span>, user : String? = <span class=\"n\">nil</span>, gid : String? = <span class=\"n\">nil</span>, group : String? = <span class=\"n\">nil</span>, mode : Int32? = <span class=\"n\">nil</span>)","location":{"filename":"src/gdbmish/dump.cr","line_number":71,"url":"https://github.com/fnordfish/gdbmish/blob/22a1f40bc10bbfeae19bc26cb7dde8ccc710f29c/src/gdbmish/dump.cr#L71"},"def":{"name":"new","args":[{"name":"file","default_value":"nil","external_name":"file","restriction":"String | ::Nil"},{"name":"uid","default_value":"nil","external_name":"uid","restriction":"String | ::Nil"},{"name":"user","default_value":"nil","external_name":"user","restriction":"String | ::Nil"},{"name":"gid","default_value":"nil","external_name":"gid","restriction":"String | ::Nil"},{"name":"group","default_value":"nil","external_name":"group","restriction":"String | ::Nil"},{"name":"mode","default_value":"nil","external_name":"mode","restriction":"Int32 | ::Nil"}],"visibility":"Public","body":"_ = allocate\n_.initialize(file, uid, user, gid, group, mode)\nif _.responds_to?(:finalize)\n  ::GC.add_finalizer(_)\nend\n_\n"}}],"instance_methods":[{"html_id":"dump(io:IO,&:Appender->_):IO-instance-method","name":"dump","abstract":false,"args":[{"name":"io","external_name":"io","restriction":"IO"}],"args_string":"(io : IO, & : Appender -> _) : IO","args_html":"(io : IO, & : <a href=\"../../Gdbmish/Dump/Ascii/Appender.html\">Appender</a> -> _) : IO","location":{"filename":"src/gdbmish/dump.cr","line_number":81,"url":"https://github.com/fnordfish/gdbmish/blob/22a1f40bc10bbfeae19bc26cb7dde8ccc710f29c/src/gdbmish/dump.cr#L81"},"def":{"name":"dump","args":[{"name":"io","external_name":"io","restriction":"IO"}],"yields":1,"block_arg":{"name":"","external_name":"","restriction":"(Appender -> _)"},"return_type":"IO","visibility":"Public","body":"appender = Appender.new(io)\ndump_header!(io)\nyield appender\ndump_footer!(io, appender.count)\nreturn io\n"}},{"html_id":"dump(io:IO,data:Hash|NamedTuple):IO-instance-method","name":"dump","abstract":false,"args":[{"name":"io","external_name":"io","restriction":"IO"},{"name":"data","external_name":"data","restriction":"Hash | NamedTuple"}],"args_string":"(io : IO, data : Hash | NamedTuple) : IO","args_html":"(io : IO, data : Hash | NamedTuple) : IO","location":{"filename":"src/gdbmish/dump.cr","line_number":91,"url":"https://github.com/fnordfish/gdbmish/blob/22a1f40bc10bbfeae19bc26cb7dde8ccc710f29c/src/gdbmish/dump.cr#L91"},"def":{"name":"dump","args":[{"name":"io","external_name":"io","restriction":"IO"},{"name":"data","external_name":"data","restriction":"Hash | NamedTuple"}],"return_type":"IO","visibility":"Public","body":"appender = Appender.new(io)\ndump_header!(io)\ndata.each do |k, v|\n  appender << {k.to_s, v.to_s}\nend\ndump_footer!(io, appender.count)\nreturn io\n"}}],"types":[{"html_id":"gdbmish/Gdbmish/Dump/Ascii/Appender","path":"Gdbmish/Dump/Ascii/Appender.html","kind":"class","full_name":"Gdbmish::Dump::Ascii::Appender","name":"Appender","abstract":false,"superclass":{"html_id":"gdbmish/Reference","kind":"class","full_name":"Reference","name":"Reference"},"ancestors":[{"html_id":"gdbmish/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"gdbmish/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/gdbmish/dump.cr","line_number":16,"url":"https://github.com/fnordfish/gdbmish/blob/22a1f40bc10bbfeae19bc26cb7dde8ccc710f29c/src/gdbmish/dump.cr#L16"}],"repository_name":"gdbmish","program":false,"enum":false,"alias":false,"const":false,"namespace":{"html_id":"gdbmish/Gdbmish/Dump/Ascii","kind":"struct","full_name":"Gdbmish::Dump::Ascii","name":"Ascii"},"doc":"Appends and counts `#push`ed data as ASCII dump format onto `@io`.\n\nUsers should not use this class stand-alone, as it only represents the\ndata part of an dump, without header and footer. An instance of it gets\nyielded when using `Ascii#dump(io) { |appender| }`","summary":"<p>Appends and counts <code><a href=\"../../../Gdbmish/Dump/Ascii/Appender.html#push%28kv%3ATuple%28String%2CString%29%29%3ANil-instance-method\">#push</a></code>ed data as ASCII dump format onto <code>@io</code>.</p>","constructors":[{"html_id":"new(io:IO)-class-method","name":"new","abstract":false,"args":[{"name":"io","external_name":"io","restriction":"IO"}],"args_string":"(io : IO)","args_html":"(io : IO)","location":{"filename":"src/gdbmish/dump.cr","line_number":19,"url":"https://github.com/fnordfish/gdbmish/blob/22a1f40bc10bbfeae19bc26cb7dde8ccc710f29c/src/gdbmish/dump.cr#L19"},"def":{"name":"new","args":[{"name":"io","external_name":"io","restriction":"IO"}],"visibility":"Public","body":"_ = allocate\n_.initialize(io)\nif _.responds_to?(:finalize)\n  ::GC.add_finalizer(_)\nend\n_\n"}}],"instance_methods":[{"html_id":"<<(kv:Tuple(String,String)):Nil-instance-method","name":"<<","doc":"Alias for `push`","summary":"<p>Alias for <code><a href=\"../../../Gdbmish/Dump/Ascii/Appender.html#push%28kv%3ATuple%28String%2CString%29%29%3ANil-instance-method\">#push</a></code></p>","abstract":false,"args":[{"name":"kv","external_name":"kv","restriction":"::Tuple(String, String)"}],"args_string":"(kv : Tuple(String, String)) : Nil","args_html":"(kv : Tuple(String, String)) : Nil","location":{"filename":"src/gdbmish/dump.cr","line_number":30,"url":"https://github.com/fnordfish/gdbmish/blob/22a1f40bc10bbfeae19bc26cb7dde8ccc710f29c/src/gdbmish/dump.cr#L30"},"def":{"name":"<<","args":[{"name":"kv","external_name":"kv","restriction":"::Tuple(String, String)"}],"return_type":"Nil","visibility":"Public","body":"push(kv)"}},{"html_id":"count:UInt64-instance-method","name":"count","abstract":false,"location":{"filename":"src/gdbmish/dump.cr","line_number":17,"url":"https://github.com/fnordfish/gdbmish/blob/22a1f40bc10bbfeae19bc26cb7dde8ccc710f29c/src/gdbmish/dump.cr#L17"},"def":{"name":"count","visibility":"Public","body":"@count"}},{"html_id":"push(kv:Tuple(String,String)):Nil-instance-method","name":"push","doc":"Push a `{\"key\", \"value\"}` `Tuple` onto the dump","summary":"<p>Push a <code>{&quot;key&quot;, &quot;value&quot;}</code> <code>Tuple</code> onto the dump</p>","abstract":false,"args":[{"name":"kv","external_name":"kv","restriction":"::Tuple(String, String)"}],"args_string":"(kv : Tuple(String, String)) : Nil","args_html":"(kv : Tuple(String, String)) : Nil","location":{"filename":"src/gdbmish/dump.cr","line_number":24,"url":"https://github.com/fnordfish/gdbmish/blob/22a1f40bc10bbfeae19bc26cb7dde8ccc710f29c/src/gdbmish/dump.cr#L24"},"def":{"name":"push","args":[{"name":"kv","external_name":"kv","restriction":"::Tuple(String, String)"}],"return_type":"Nil","visibility":"Public","body":"@count = @count + 1\nkv.each do |d|\n  @io << (dump_datum(d))\nend\n"}}]}]}]}]}]}})