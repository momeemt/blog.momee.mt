import brack
import brackStd/[base, details]
import std/[os, strformat]

const Library = Base & Details
registerLibrary(Library)

for file in walkDir("articles"):
  let name = file.path[9..^4]
  block:
    var outputFile = open(&"dist/{name}.html", FileMode.fmWrite)
    defer: outputFile.close()
    outputFile.write(
      lex(file.path).parse().generate()
    )
