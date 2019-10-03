import os, strutils
proc readCounter*(): int =
    let dir: string = os.getCurrentDir()
    var counter: int

    try:
        let counterFile = readFile(dir & "/counter")
        counter = strutils.parseInt(counterFile)
    except IOError:
        echo "couldn't read counter file"
    except ValueError:
        echo "counter file contains non int value"

    return counter

proc writeCounter*(val: int) =
    let dir: string = os.getCurrentDir()
    try:
        writeFile(dir & "/counter", strutils.intToStr(val))
    except IOError:
        echo "couldn't write counter file"
