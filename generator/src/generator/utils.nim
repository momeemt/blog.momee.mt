import std/os
import std/strutils
import std/algorithm
import compiler/nimeval
import compiler/renderer
import compiler/ast

type
  Page* = tuple
    title: string
    overview: string
    date: string
    href: string
    thumbnail: string
    tags: seq[string]

func cmpPage (x, y: Page): int =
  result = system.cmp(x.date, y.date)

func sorted* (page: seq[Page]): seq[Page] =
  result = page.sorted(cmpPage)

iterator dateInDir* (path: string): tuple[dir: tuple[kind: PathComponent, path: string], year, month, day: string] =
  for yearInDir in walkDir(path):
    let year = yearInDir.path.split('/')[^1]
    for monthInDir in walkDir(yearInDir.path):
      let month = monthInDir.path.split('/')[^1]
      for dayInDir in walkDir(monthInDir.path):
        let day = dayInDir.path.split('/')[^1]
        yield (dayInDir, year, month, day)

proc getInterpreter* (path: string): Interpreter =
  when defined(macosx):
    let stdlib = "/opt/homebrew/Cellar/nim/1.6.8/nim/lib/"
    # let stdlib = "/Users/momeemt-macbook/.choosenim/toolchains/nim-1.6.8/lib/"
  else:
    let stdlib = "/nim/lib"
  result = createInterpreter(path, [stdlib, stdlib / "pure", stdlib / "core"])
  result.evalScript()

proc destroy* (intr: Interpreter) =
  intr.destroyInterpreter()

proc getString* (intr: Interpreter, name: string): string =
  result = intr.getGlobalValue(
    intr.selectUniqueSymbol(name)
  ).strVal

proc getInt* (intr: Interpreter, name: string): int =
  result = intr.getGlobalValue(
    intr.selectUniqueSymbol(name)
  ).intVal.int

proc getBool* (intr: Interpreter, name: string): bool =
  result = intr.getGlobalValue(
    intr.selectUniqueSymbol(name)
  ).intVal.bool

proc getSeqString* (intr: Interpreter, name: string): seq[string] =
  let sym = intr.getGlobalValue(
    intr.selectUniqueSymbol(name)
  )
  for son in sym.sons:
    result.add son.strVal