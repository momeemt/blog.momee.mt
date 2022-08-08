import brack/brack
import brack/libs/std
import std/[os, strformat, macros]

# static:
#   for file in walkDir("articles"):
#     let fileName = file.path[9..^4]

compile("articles/helloworld.[]", "helloworld")
