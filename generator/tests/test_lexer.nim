import brack/brack
import std/unittest

test "lexer":
  compile("articles/helloworld.[]")
  check true
