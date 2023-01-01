# Package

version       = "0.1.0"
author        = "momeemt"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
binDir        = "bin"
bin           = @["utils"]


# Dependencies

requires "nim >= 1.6.8"
requires "https://github.com/momeemt/todoist-nim"
requires "dotenv"