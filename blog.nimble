# Package

version       = "0.1.0"
author        = "Mutsuha Asada"
description   = "The momeemt's blog"
license       = "MIT"
backend       = "c"
srcDir        = "src"
binDir        = "dist"
bin           = @["blog"]

# Dependencies

requires "nim >= 1.6.6"
requires "https://github.com/momeemt/brack"
requires "https://github.com/momeemt/brackStd"

# Tasks
task buildBlog, "build blog":
  exec "mkdir -p dist"
  exec "nimble run"
  exec "rm dist/blog"