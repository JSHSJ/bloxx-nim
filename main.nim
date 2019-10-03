import htmlgen
import jester
import json

import database/[database, users]


startDatabase()

routes:
    get "/":
        resp h1("hello world")

    post "/users":
        var userJson = parseJson(request.body)
        try:
            let firstName = userJson["firstName"].getStr()
            let lastName = userJson["lastName"].getStr()
            let email = userJson["email"].getStr()
            let password = userJson["password"].getStr()
            let token = createUser(firstName, lastName, email, password)
            let tokenJson = %* token
            resp Http200, $(tokenJson), "application/json;charset=utf-8"
        except UserExistsException:
            resp Http200, $( %* {"message": "Email in use"}), "application/json;charset=utf-8"
        except:
            resp Http500, $( %* {"message": "There was an error! Oh no!"}), "application/json;charset=utf-8"
