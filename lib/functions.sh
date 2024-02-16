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

function nocookies {
    printf "\nNo cookies found, run \033[4;30metna login\033[0m first\n\n"
}

function checkcookies {
    if [ ! -f ".cookies" ]; then
        nocookies
        exit 1
    fi
    identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b .cookies)
    if [[ $identity = 'Missing cookie' ]]; then
        printf "\nCookie expired, relogin first: \033[4metna login\033[0m\n\n"
        exit 1
    fi
}

function flush {
    if [ -f ".cookies" ]; then
        rm ".cookies"
    fi
}

function login {
    clear
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
    email=$(echo $identity | jq -r '.email')
    printf "Logged in: \033[4m$email\033[0m\n\n"
}

function userinfo {
    clear
    checkcookies

    identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b .cookies)
    printf "Logged in: "
    echo $identity | jq ".login"
    exit 0
}

function current_activities {
    checkcookies

    login=$(userinfo | cut -d '"' -f 2)
    activities=$(curl --silent -X GET https://modules-api.etna-alternance.net/students/$login/currentactivities -L -b .cookies)

    clear
    printf "Logged in: \033[4:30m$login\033[0m\n"
    printf "Current date \033[0;32m$(date +"%Y-%m-%d %H:%M:%S")\033[0m\n\n"

    if [[ -z $activities ]]; then
        echo "Failed to fetch activities"
        exit 1
    fi
    # Get modules name first then iterate after
    modules=$(echo "$activities" | jq -r 'keys[]')
    for module in $modules; do
        projects=$(echo "$activities" | jq -r --arg mod "$module" '.[$mod].project')

        printf "=====\033[1:33m$module:\033[0m=====\n"

        # Checks if projects is not empty, check if array length > 0
        if [[ -n $projects && $(echo "$projects" | jq length) -gt 0 ]]; then
            # Loops over each object in array and call it 'item'
            echo "$projects" | jq -c '.[]' | while IFS= read -r item; do

                # Extract name and date from each item
                name=$(echo "$item" | jq -r '.name')
                date_end=$(echo "$item" | jq -r '.date_end')
                printf "$date_end \033[0;33m$name\033[0m\n"

            done
        else
            printf "\033[0;33mNothing\033[0m\n"
        fi
        echo
    done
    exit 0
}
