# Package

version       = "0.1.0"
author        = "Mutsuha Asada"
description   = "The momeemt's blog"
license       = "MIT"
backend       = "c"
srcDir        = "src"
binDir        = "bin"
bin           = @["generator"]

# Dependencies

requires "nim >= 1.6.6"
requires "compiler"
requires "https://github.com/momeemt/brack"
requires "parsetoml == 0.6.0"
# requires "brack#head"

# Tasks
task generate, "build blog":
  exec "mkdir -p ../dist"
  exec "nimble run -y"
