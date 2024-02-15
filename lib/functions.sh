function help {
    echo
    printf "Commands list:\n"
    echo
    printf "login: to retrieve the session cookie necessary for other commands\n"
    printf "userinfo: get logged in user informations\n"
    printf "activs: get current activities informations (on-going modules, etc.)\n"
    printf "flush: removes the cookie from your login\n"
    echo
}

function flush {
    if [ -f ".cookies" ]; then
        rm ".cookies"
    fi
}

function login {
    if [ -f ".cookies" ]; then
        rm ".cookies"
    fi
    echo
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
    printf "\nNo cookies found, run etna login first\n"
    exit 1
}

function current_activities {
    if [ -f ".cookies" ]; then
        login=$(userinfo | cut -d '"' -f 2)
        activities=$(curl --silent -X GET https://modules-api.etna-alternance.net/students/$login/currentactivities -L -b .cookies)

        clear
        printf "Logged in: \033[4:30m$login\033[0m\n\n"

        if [[ -z $activities ]]; then
            echo "Failed to fetch activities"
            exit 1
        fi
        # Get modules name first then iterate after
        modules=$(echo "$activities" | jq -r 'keys[]')
        for module in $modules; do
            project_name_and_end=$(echo "$activities" | jq -r --arg mod "$module" '.[$mod].project[] | .name, .date_end')
            printf "\033[1:33m$module:\033[0m\n"
            printf "\033[0;33m$project_name_and_end\033[0m\n"
            echo
        done

        exit 0
    fi
    printf "\nNo cookies found, run etna login first\n"
    exit 1
}
