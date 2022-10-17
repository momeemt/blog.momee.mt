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

# Tasks
task generate, "build blog":
  exec "nimble uninstall compiler brack brackStd -y | true"
  exec "nimble install -y compiler https://github.com/momeemt/brack https://github.com/momeemt/brackStd"
  exec "cd generator && nimble generate"
  exec "cd frontend && nimble build"
