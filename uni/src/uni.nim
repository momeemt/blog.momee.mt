import std/os
import std/parseopt
import std/times
import std/strformat
import std/strutils
import std/random

import uni/checkDaily
include "templates/article_setting.nims.nimf"
include "templates/daily_setting.nims.nimf"

type
  UniSubcommand = enum
    usNone
    usNewArticle
    usNewDaily
    usCheckDaily

when isMainModule:
  if paramCount() == 0:
    quit(1)

  randomize()

  var
    p = commandLineParams().initOptParser()
    subcommand = usNone
    slug = ""
    now = now()
    year = $now.year
    month = $(now.month.int)
    day = $now.monthday
  while true:
    p.next()
    case p.kind
    of cmdEnd: break
    of cmdShortOption, cmdLongOption:
      case p.key
      of "slug":
        slug = p.val
      of "date":
        let date = p.val.split("-")
        (year, month, day) = (date[0], date[1], date[2])
    of cmdArgument:
      case p.key
      of "new:article":
        subcommand = usNewArticle
      of "new:daily":
        subcommand = usNewDaily
      of "check:daily":
        subcommand = usCheckDaily

  if subcommand == usNewArticle:
    let
      currentDir = getCurrentDir()
      articlePath = &"{currentDir}/articles/{year}/{month}/{day}/{slug}"
    createDir(articlePath)
    block:
      var brack = open(&"{articlePath}/index.[]", fmReadWrite)
      brack.close()
    block:
      var setting = open(&"{articlePath}/setting.nims", fmReadWrite)
      setting.write(articleSetting(rand(1..16)))
      setting.close()
  elif subcommand == usNewDaily:
    let
      currentDir = getCurrentDir()
      dailyPath = &"{currentDir}/dailies/{year}/{month}/{day}"
    createDir(dailyPath)
    block:
      var brack = open(&"{dailyPath}/index.[]", fmReadWrite)
      brack.close()
    block:
      var setting = open(&"{dailyPath}/setting.nims", fmReadWrite)
      setting.write(dailySetting(rand(1..16)))
      setting.close()
  elif subcommand == usCheckDaily:
    let (cond, msg) = checkDaily.check()
    if cond:
      echo msg
      quit(0)
    else:
      stderr.writeLine msg
      quit(1)
