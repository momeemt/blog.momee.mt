import src/[lexer, parser, generator]
import std/strformat
export lexer, parser, generator

template compile* (path: string, name: string) =
  const ast = lex("../../../" & path).parse()
  block:
    var output = open("dist/" & name & ".html", FileMode.fmWrite)
    defer:
      output.close()
    output.writeLine generate(ast)
