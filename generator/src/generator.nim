import brack
initBrack()

import std/os
import std/strformat
import std/strutils
import std/algorithm
import compiler/renderer
import generator/utils

include "scf/index.html.nimf"
include "scf/daily_index.html.nimf"
include "scf/article.html.nimf"
include "scf/daily.html.nimf"

os.copyFile("./src/css/style.css", "../dist/style.css")
os.copyDir("./src/assets/", "../dist/assets/")

var pages: seq[Page] = @[]
for (dayInDir, year, month, day) in dateInDir("../articles"):
  for dir in walkDir(dayInDir.path):
    let
      name = dir.path.split('/')[^1]
      intr = getInterpreter(dir.path & "/setting.nims")
      title = intr.getString("title")
      overview = intr.getString("overview")
      thumbnail = intr.getInt("thumbnail")
      tags = intr.getSeqString("tags")

      page = (
        title,
        overview,
        &"{year}-{month}-{day}",
        &"{year}/{month}/{day}/{name}.html",
        &"{thumbnail}.png",
        tags
      )
    
    defer: intr.destroy()

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

var dailies: seq[Page] = @[]
for (dir, year, month, day) in dateInDir("../dailies"):
  let
    intr = getInterpreter(dir.path & "/setting.nims")
    overview = intr.getString("overview")
    thumbnail = intr.getInt("thumbnail")
    page: Page = (
      &"{year}.{month}.{day}",
      overview,
      &"{year}-{month}-{day}",
      &"{year}/{month}/{day}/daily.html",
      &"{thumbnail}.png",
      @[]
    )
  
  defer: intr.destroy()

  block:
    createDir(&"../dist/daily/{year}/{month}/{day}/")
    var outputFile = open(&"../dist/daily/{year}/{month}/{day}/daily.html", FileMode.fmWrite)
    defer: outputFile.close()
    let parsed = lex(dir.path & "/index.[]").parse()
    outputFile.write(
      generateDailyHtml(
        parsed.expand().generate(),
        page
      )
    )
  
  dailies.add page

block:
  var outputFile = open(&"../dist/index.html", FileMode.fmWrite)
  defer: outputFile.close()
  outputFile.write(
    generateIndexHtml(pages.reversed)
  )

block:
  createDir(&"../dist/daily/")
  var outputFile = open(&"../dist/daily/index.html", FileMode.fmWrite)
  defer: outputFile.close()
  outputFile.write(
    generateDailyIndexHtml(dailies.reversed)
  )
