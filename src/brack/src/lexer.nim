# proc lexLeftSquaredBracket ()

import std/[strutils]

proc lex* (path: string): seq[string] =
  let
    brackSrc = staticRead(path)

  var
    token: string = ""
    index = 0
    squaredBracketNestCount = 0
    curlyBracketNestCount = 0
    searchingCommandName = false

  while index < brackSrc.len:
    let targetChar = brackSrc[index]

    if targetChar == '[':
      squaredBracketNestCount += 1
      if token != "":
        result.add token.strip
        token = ""
      result.add $targetChar
      index += 1
      searchingCommandName = true
    elif targetChar == ']' and squaredBracketNestCount > 0:
      squaredBracketNestCount -= 1
      if token != "":
        result.add token.strip
        token = ""
      result.add $targetChar
      index += 1
    elif targetChar == '{':
      curlyBracketNestCount += 1
      if token != "":
        result.add token.strip
        token = ""
      result.add $targetChar
      index += 1
      searchingCommandName = true
    elif targetChar == '}' and curlyBracketNestCount > 0:
      curlyBracketNestCount -= 1
      if token != "":
        result.add [token, $targetChar]
        token = ""
      result.add $targetChar
      index += 1
    elif targetChar == ',' and (squaredBracketNestCount > 0 or curlyBracketNestCount > 0):
      result.add [token.strip, $targetChar]
      token = ""
      index += 1
    elif targetChar == ' ' and searchingCommandName:
      if token != "":
        result.add token.strip
        token = ""
        index += 1
      searchingCommandName = false
    elif targetChar == '\n':
      if token != "":
        result.add token.strip
        token = ""
      result.add $targetChar
      index += 1
    else:
      token.add targetChar
      index += 1

  if token != "":
    result.add token.strip
