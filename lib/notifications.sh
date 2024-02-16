source $ETNA_CLI/lib/utils/checkcookies.sh

function notifications {
    checkcookies

    identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b /tmp/.etna-cookies)
    login=$(echo $identity | jq -r ".login")
    notifs=$(curl --silent -X GET https://prepintra-api.etna-alternance.net/students/$login/informations -L -b /tmp/.etna-cookies)
    printf "Unread notifications:\n"

    if [[ -n $planning && $(echo "$planning" | jq length) -gt 0 ]]; then
        printf "\n$notifs\n"
    else
        printf "\n\033[0;32m0 unread notifications\033[0m\n"
    fi

}
