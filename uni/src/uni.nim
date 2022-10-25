import std/os
import std/parseopt
import std/times
import std/strformat
import std/strutils

type
  UniSubcommand = enum
    usNone
    usNewArticle
    usNewDaily

when isMainModule:
  if paramCount() == 0:
    quit(1)

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
      setting.close()