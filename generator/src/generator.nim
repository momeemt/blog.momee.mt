import brack
import brackStd/[base, details]
import std/os
import std/strformat
import std/strutils
import compiler/nimeval
import compiler/renderer

include "scf/index.html.nimf"
include "scf/article.html.nimf"

const Library = Base & Details
registerLibrary(Library)

var pages: seq[tuple[text, href: string]] = @[]
for yearDir in walkDir("../articles"):
  let year = yearDir.path.split('/')[^1]
  for monthDir in walkDir(yearDir.path):
    let month = monthDir.path.split('/')[^1]
    for dayDir in walkDir(monthDir.path):
      let day = dayDir.path.split('/')[^1]
      for dir in walkDir(dayDir.path):
        let name = dir.path.split('/')[^1]
        block:
          createDir(&"../dist/{year}/{month}/{day}/")
          var outputFile = open(&"../dist/{year}/{month}/{day}/{name}.html", FileMode.fmWrite)
          defer: outputFile.close()
          outputFile.write(
            generateArticleHtml(
              lex(dir.path & "/index.[]").parse().generate()
            )
          )
        let title = block:
          let
            stdlib = "/nim/lib"
            intr = createInterpreter(dir.path & "/" & "setting.nims", [stdlib, stdlib / "pure", stdlib / "core"])
          intr.evalScript()
          defer: intr.destroyInterpreter()
          let sym = intr.selectUniqueSymbol("title")
          let val = intr.getGlobalValue(sym).strVal
          val
        
        pages.add (title, &"{year}/{month}/{day}/{name}.html")

block:
  var outputFile = open(&"../dist/index.html", FileMode.fmWrite)
  defer: outputFile.close()
  outputFile.write(
    generateIndexHtml(pages)
  )
