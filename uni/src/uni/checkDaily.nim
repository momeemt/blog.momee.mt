import std/os
import std/osproc
import std/strutils
import std/strformat

proc check*: tuple[cond: bool, msg: string] =
  var (branchName, _) = execCmdEx("git rev-parse --abbrev-ref @")
  if not branchName.startsWith("daily/"):
    return (false, "you need to be in daily branch")

  branchName = branchName[6..^2]
  let
    split = branchName.split("-")
    year = split[0]
    month = split[1]
    day = split[2]
    currentDir = getCurrentDir()
  
  block:
    let path = &"{currentDir}/dailies/{year}/{month}/{day}/index.[]"
    try:
      var dailyBrackFile = open(path)
      defer:
        dailyBrackFile.close()
      
      if dailyBrackFile.readAll == "":
        return (false, "No daily report was written.")
      else:
        return (true, "Just checked the daily report update!")
    except IOError:
      return (false, &"Today's daily brack file does not exist {path}, there may be a problem with file creation by uni or with CI behavior.")
