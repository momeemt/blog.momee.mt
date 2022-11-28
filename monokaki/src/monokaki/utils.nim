import std/os
import std/strutils
import std/algorithm

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
