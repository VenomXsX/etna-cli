function flush {
    if [ -f ".cookies" ]; then
        rm ".cookies"
    fi
}

function login {
    if [ -f ".cookies" ]; then
        rm ".cookies"
    fi
    read -p "Login: " login
    read -sp "Password: " password
    echo
    res=$(curl --silent -c '.cookies' -X POST https://auth.etna-alternance.net/login -d "login=$login&password=$password")
    if [[ $res = "{}" ]]; then
        printf "Not authenticated\n"
        rm .cookies
        exit 1
    fi
    identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b .cookies)
    echo $identity | jq ".email"
}

function userinfo {
    if [ -f ".cookies" ]; then
        identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b .cookies)
        printf "Logged in: "
        echo $identity | jq ".login"
        exit 0
    fi
    printf "No cookies found, run etna login first\n"
    exit 1
}

function current_activities {
    if [ -f ".cookies" ]; then
        login=$(userinfo | cut -d '"' -f 2)
        printf "Logged in: $login\n"
        activities=$(curl --silent -X GET https://modules-api.etna-alternance.net/students/$login/currentactivities -L -b .cookies)
        echo $activities
        exit 0
    fi
    printf "No cookies found, run etna login first\n"
    exit 1
}