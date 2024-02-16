function help {
    echo
    printf "Usage: etna <command>\n"
    printf "Commands list:\n"
    echo
    printf "\033[0;32mlogin\033[0m:      to retrieve the session cookie necessary for other commands\n"
    printf "\033[0;32muserinfo\033[0m:   get logged in user informations\n"
    printf "\033[0;32mactivs\033[0m:     get current activities informations (on-going modules, etc.)\n"
    printf "\033[0;32mflush\033[0m:      removes the cookie from your login\n"
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
        printf "Deleted the cookie\n"
        exit 0
    fi
    printf "No cookie found\n"
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
    email=$(echo $identity | jq -r '.email')
    printf "Logged in: \033[4m$email\033[0m\n\n"
}

function userinfo {
    checkcookies

    identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b .cookies)
    id=$(echo $identity | jq -r ".id")
    informations=$(curl --silent -X GET https://auth.etna-alternance.net/api/users/$id -L -b .cookies)

    firstname=$(echo $informations | jq -r ".firstname")
    lastname=$(echo $informations | jq -r ".lastname")
    email=$(echo $informations | jq -r ".email")
    login=$(echo $informations | jq -r ".login")

    echo
    printf "Name :      $firstname $lastname\n"
    printf "Login:      $login\n"
    printf "Email:      $email\n\n"

    exit 0
}

function current_activities {
    checkcookies

    identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b .cookies)
    login=$(echo $identity | jq -r ".login")
    activities=$(curl --silent -X GET https://modules-api.etna-alternance.net/students/$login/currentactivities -L -b .cookies)

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
