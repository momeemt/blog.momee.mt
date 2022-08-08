import ../brack
import std/[htmlgen, strformat]

proc `!`* (text, color_code: string): string {.squared.} =
  result = span(text, style= &"color: {color_code};")

proc `*`* (text: string): string {.squared.} =
  result = span(text, style= &"font-weight: bold;")

proc `*?`* (text: string): string {.squared.} =
  result = span(*text, style="color: red;")

proc `*`* (text: string): string {.curly.} =
  result = h1(text)

proc `@`* (text, url: string): string {.squared.} =
  result = a(text, href=url)

proc `^_^`*: string {.squared.} =
  result = "😊"
