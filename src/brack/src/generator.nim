import parser
import std/[macros, strformat, htmlgen]

proc seqToArgument (strings: seq[string]): string =
  for str in strings:
    result &= &", {str}"

type
  CurlyCommand* = object
  SquaredCommand* = object

macro squared* (body: untyped): untyped =
  result = copy(body)
  result[0][1][0] = newIdentNode("squared" & $result[0][1][0])
  result[3].insert(
    1, 
    nnkIdentDefs.newTree(
      newIdentNode("_"),
      nnkBracketExpr.newTree(
        newIdentNode("typedesc"),
        newIdentNode("SquaredCommand")
      ),
      newEmptyNode()
    )
  )
  var privateProc = copy(body)
  privateProc[0] = privateProc[0][1]
  privateProc[0][0] = newIdentNode($privateProc[0][0])
  privateProc[4] = nnkPragma.newTree(
    newIdentNode("used")
  )
  result = newStmtList(result, privateProc)

macro `curly`* (body: untyped): untyped =
  result = copy(body)
  result[0][1][0] = newIdentNode("curly" & $result[0][1][0])
  result[3].insert(
    1, 
    nnkIdentDefs.newTree(
      newIdentNode("_"),
      nnkBracketExpr.newTree(
        newIdentNode("typedesc"),
        newIdentNode("CurlyCommand")
      ),
      newEmptyNode()
    )
  )
  # var privateProc = copy(body)
  # privateProc[0] = privateProc[0][1]
  # privateProc[4] = nnkPragma.newTree(
  #   newIdentNode("used")
  # )
  # result = newStmtList(result, privateProc)

proc squaredBracketGenerator (ast: BrackNode, root = true): string =
  var
    ident = ""
    arguments: seq[string] = @[]
  for node in ast.children:
    if node.kind == bnkIdent:
      ident = node.val
    elif node.kind == bnkArgument:
      var argument = ""
      for argNode in node.children:
        if argNode.kind == bnkSquareBracket:
          argument.add squaredBracketGenerator(argNode, false)
        elif argNode.kind == bnkText:
          argument.add &"\"{argNode.val}\""
      arguments.add argument
  result = &"`squared{ident}`(SquaredCommand{arguments.seqToArgument})"
  if root:
    result = "{" & result & "}"

proc curlyBracketGenerator (ast: BrackNode, root = true): string =
  var
    ident = ""
    arguments: seq[string] = @[]
  for node in ast.children:
    if node.kind == bnkIdent:
      ident = node.val
    elif node.kind == bnkArgument:
      var argument = ""
      for argNode in node.children:
        if argNode.kind == bnkSquareBracket:
          argument.add squaredBracketGenerator(argNode, false)
        elif argNode.kind == bnkText:
          argument.add &"\"{argNode.val}\""
      arguments.add argument
  result = &"`curly{ident}`(CurlyCommand{arguments.seqToArgument})"
  if root:
    result = "{" & result & "}"

proc paragraphGenerator (ast: BrackNode): string =
  for node in ast.children:
    if node.kind == bnkText:
      result &= node.val
    elif node.kind == bnkSquareBracket:
      result &= squaredBracketGenerator(node)

proc generate (ast: BrackNode): string =
  for node in ast.children:
    if node.kind == bnkCurlyBracket:
      result &= curlyBracketGenerator(node)
    elif node.kind == bnkParagraph:
      result &= "<p>" & paragraphGenerator(node) & "</p>"

macro generate* (ast: static[BrackNode]): untyped =
  let html = generate(ast)
  result = quote do:
    &`html`
