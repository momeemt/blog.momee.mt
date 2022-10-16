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
for dir in walkDir("../articles"):
  if dir.kind != pcDir:
    raise newException(Exception, "ファイルが存在してはいけない")

  let name = dir.path.split('/')[^1][10..^1]
  echo name
  block:
    var outputFile = open(&"../dist/{name}.html", FileMode.fmWrite)
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
  
  pages.add (title, name & ".html")

block:
  var outputFile = open(&"../dist/index.html", FileMode.fmWrite)
  defer: outputFile.close()
  outputFile.write(
    generateIndexHtml(pages)
  )
