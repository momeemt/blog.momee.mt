import brack
initBrack()

import std/os
import std/strformat
import std/strutils
import std/algorithm
import compiler/nimeval
import compiler/renderer
import compiler/ast

include "scf/index.html.nimf"
include "scf/article.html.nimf"

os.copyFile("./src/css/style.css", "../dist/style.css")
os.copyDir("./src/assets/", "../dist/assets/")

var pages: seq[tuple[title, overview, date, href: string, tags: seq[string]]] = @[]
for yearDir in walkDir("../articles"):
  let year = yearDir.path.split('/')[^1]
  for monthDir in walkDir(yearDir.path):
    let month = monthDir.path.split('/')[^1]
    for dayDir in walkDir(monthDir.path):
      let day = dayDir.path.split('/')[^1]
      for dir in walkDir(dayDir.path):
        let name = dir.path.split('/')[^1]
        let (title, overview, tags) = block:
          when defined(macosx):
            let stdlib = "/opt/homebrew/Cellar/nim/1.6.6/nim/lib/"
          else:
            let stdlib = "/nim/lib"
          let intr = createInterpreter(dir.path & "/" & "setting.nims", [stdlib, stdlib / "pure", stdlib / "core"])
          intr.evalScript()
          defer: intr.destroyInterpreter()
          let
            title = intr.selectUniqueSymbol("title")
            overview = intr.selectUniqueSymbol("overview")
            tags = intr.selectUniqueSymbol("tags")
            titleVal = intr.getGlobalValue(title).strVal
            overviewVal = intr.getGlobalValue(overview).strVal
            tagsVal = intr.getGlobalValue(tags)
          var tagsOutput: seq[string]
          for tag in tagsVal.sons:
            tagsOutput.add tag.strVal

          (titleVal, overviewVal, tagsOutput)
        
        let page = (title, overview, &"{year}-{month}-{day}", &"{year}/{month}/{day}/{name}.html", tags)

        block:
          createDir(&"../dist/{year}/{month}/{day}/")
          var outputFile = open(&"../dist/{year}/{month}/{day}/{name}.html", FileMode.fmWrite)
          defer: outputFile.close()
          let parsed = lex(dir.path & "/index.[]").parse()
          outputFile.write(
            generateArticleHtml(
              parsed.expand().generate(),
              page
            )
          )

        pages.add page

block:
  var outputFile = open(&"../dist/index.html", FileMode.fmWrite)
  defer: outputFile.close()
  outputFile.write(
    generateIndexHtml(pages.reversed)
  )
