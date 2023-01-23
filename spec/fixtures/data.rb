# frozen_string_literal: true

{
  "föö"  => "bää\n🤦‍♂️",
  "foo2" => "bar2",
  "foo"  => ("bar-"*128),
  "double-éscapè:\\\\c3" => "A\\TEST\\c3élene",
  "multiline content" => "This is a\nmultiline\n\nstring.\n",
  "mixed crlf content" => "This is a\r\multiline string\r\nwith mixed\r\n\nnewlines.\n"
}