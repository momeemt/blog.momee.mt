import brack
import brackStd/[base, details]
import std/[os, strformat]

include "scf/index.html.nimf"
include "scf/article.html.nimf"

const Library = Base & Details
registerLibrary(Library)

for file in walkDir("articles"):
  let name = file.path[9..^4]
  block:
    var outputFile = open(&"../dist/{name}.html", FileMode.fmWrite)
    defer: outputFile.close()
    outputFile.write(
      generateArticleHtml(
        lex(file.path).parse().generate()
      )
    )
  block:
    var outputFile = open(&"../dist/index.html", FileMode.fmWrite)
    defer: outputFile.close()
    outputFile.write(
      generateIndexHtml("Hello, uni!")
    )
