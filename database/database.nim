import os
import strutils
import json
import users
import counter


proc startDatabase*() =
    let dir: string = os.getCurrentDir()
    os.createDir(dir & "/users")
    os.createDir(dir & "/tokens")

    if os.fileExists(dir & "/counter") == false:
        writeCounter(0)




