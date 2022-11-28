import brack
initBrack()

import std/os
import std/strformat
import std/strutils
import std/sequtils
import std/algorithm
import std/sugar

import generator/utils
import parsetoml

include "scf/index.html.nimf"
include "scf/daily_index.html.nimf"
include "scf/article.html.nimf"
include "scf/daily.html.nimf"

os.copyFile("./src/css/style.css", "../dist/style.css")
os.copyDir("./src/assets/", "../dist/assets/")

var pages: seq[Page] = @[]
for (dayInDir, year, month, day) in dateInDir("../articles"):
  echo (dayInDir, year, month, day)
  for dir in walkDir(dayInDir.path):
    let
      name = dir.path.split('/')[^1]
      toml = parsetoml.parseFile(dir.path / "settings.toml")
      title = toml["blog"]["title"].getStr()
      overview = toml["blog"]["overview"].getStr()
      tags = toml["blog"]["tags"].getElems().map(t => t.getStr())
      thumbnail = toml["blog"]["thumbnail"].getInt()
      published = toml["blog"]["published"].getBool()
      page = (
        title,
        overview,
        &"{year}-{month}-{day}",
        &"{year}/{month}/{day}/{name}.html",
        &"{thumbnail}.png",
        tags
      )

    if not published:
      continue

    block:
      createDir(&"../dist/{year}/{month}/{day}/")
      for assets in walkFiles(dir.path / "assets"):
        copyFile(assets, &"../dist/{year}/{month}/{day}/")
      var outputFile = open(&"../dist/{year}/{month}/{day}/{name}.html", FileMode.fmWrite)
      defer: outputFile.close()
      let parsed = tokenize(dir.path / "index.[]").parse()
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
    toml = parsetoml.parseFile(dir.path / "settings.toml")
    overview = toml["blog"]["overview"].getStr()
    thumbnail = toml["blog"]["thumbnail"].getInt()
    published = toml["blog"]["published"].getBool()
    page: Page = (
      &"{year}.{month}.{day}",
      overview,
      &"{year}-{month}-{day}",
      &"{year}/{month}/{day}/daily.html",
      &"{thumbnail}.png",
      @[]
    )
  
  if not published:
    continue

  block:
    createDir(&"../dist/daily/{year}/{month}/{day}/")
    for assets in walkDir(dir.path / "assets/"):
      let name = $assets.path.split('/')[^1]
      copyFile(assets.path, &"../dist/daily/{year}/{month}/{day}/{name}")
    var outputFile = open(&"../dist/daily/{year}/{month}/{day}/daily.html", FileMode.fmWrite)
    defer: outputFile.close()
    let parsed = tokenize(dir.path & "/index.[]").parse()
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
    generateIndexHtml(pages.sorted.reversed)
  )

block:
  createDir(&"../dist/daily/")
  var outputFile = open(&"../dist/daily/index.html", FileMode.fmWrite)
  defer: outputFile.close()
  outputFile.write(
    generateDailyIndexHtml(dailies.sorted.reversed)
  )
