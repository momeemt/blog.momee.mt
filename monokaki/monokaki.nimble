# Package

version       = "0.1.0"
author        = "Mutsuha Asada"
description   = "the blog generator and manager"
license       = "Apache-2.0"
srcDir        = "src"
binDir        = "bin"
bin           = @["monokaki"]


# Dependencies

requires "nim >= 1.6.6"
requires "cligen == 1.5.32"
requires "nwatchdog == 0.0.8"
requires "https://github.com/momeemt/brack"
requires "parsetoml == 0.6.0"