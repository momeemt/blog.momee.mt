import todoist/sync
import dotenv
import std/os
import std/times
import std/options
import asyncdispatch

load()

var client = syncAPI(getEnv("Authorization"))
var
  now = now()
  start = dateTime(now.year, now.month, now.monthday)
  stop = dateTime(now.year, now.month, now.monthday, 23, 59, 59)

let items = waitFor client.getCompletedItems(
  since = some(start),
  until = some(stop)
)

var output = "{list\n"
for item in items:
  output &= "  " & item.content & "\n"
output &= "}"

echo output