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
requires "https://github.com/momeemt/brack"
requires "https://github.com/momeemt/brackStd"

# Tasks
task generate, "build blog":
  exec "cd generator && nimble generate"
  exec "cd frontend && nimble build"
