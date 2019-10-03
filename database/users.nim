import os, json, strutils, random
import counter

type
    User* = object
        id*: int
        firstName*: string
        lastName*: string
        email*: string
        password*: string
        active*: bool
        cart*: seq[int]
        street*: string
        zipCode*: string
        country*: string
        preferredPayment*: string

type
    UserExistsException* = object of Exception

type
    Token* = object
        token*: string
        userID*: int

type
    InvalidToken* = object of Exception


proc createToken(user: User): Token =
    var tokenString = ""

    for i in 0..9:
        tokenString.add(intToStr(rand(9)))

    var token = Token(token: tokenString, userID: user.id)
    var json = %* token

    let dir: string = os.getCurrentDir()

    try:
        writeFile(dir & "/tokens/" & tokenString, pretty(json))
        return token
    except IOError:
        echo "couldn't write counter file"


proc userEmailExists(email: string): bool =
    let dir = os.getCurrentDir()
    for kind, file in os.walkDir(dir & "/users"):
        echo file
        let json = parseFile(file)
        echo json
        if json{"email"}.getStr() == email:
            return true
    return false

proc saveUser*(user: User) =
    let dir: string = os.getCurrentDir()

    var json = %* user
    try:
        writeFile(dir & "/users/" & strutils.intToStr(user.id), pretty(json))
    except IOError:
        echo "couldn't write counter file"


proc createUser*(firstName: string, lastName: string, email: string,
        password: string): Token =
    if userEmailExists(email):
        raise newException(UserExistsException, "Email already in use")
    var user: User = User(firstName: firstName, lastname: lastName,
            email: email, password: password)

    var counter = readCounter()
    user.id = counter
    inc(counter)
    writeCounter(counter)
    saveUser(user)

    return createToken(user)







