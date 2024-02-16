source $ETNA_CLI/lib/utils/checkcookies.sh

function notifications {
    checkcookies

    identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b /tmp/.etna-cookies)
    login=$(echo $identity | jq -r ".login")
    notifs=$(curl --silent -X GET https://prepintra-api.etna-alternance.net/students/$login/informations -L -b /tmp/.etna-cookies)
    printf "Unread notifications:\n"

    if [[ -n $notifs && $(echo "$notifs" | jq length) -gt 0 ]]; then
        nb=$(echo "$notifs" | jq length)
        printf "\n\033[0;35m$nb unread notifications \033[0;30mhttps://intra.etna-alternance.net/\033[0m\n"

        echo "$notifs" | jq -c '.[]' | while IFS= read -r item; do
            message=$(echo $item | jq -r ".message")
            printf "$message\n"
            type=$(echo $item | jq -r ".metas.type")
            if [[ $type = "event_subscription" ]]; then
                printf "This is an event subscription\n\n"
            elif [[ $type = "module_show" ]]; then
                printf "This is a module_show\n\n"
            elif [[ $type = "activity_show" ]]; then
                printf "This is a activity_show\n\n"
            fi

        done
    else
        printf "\n\033[0;32m0 unread notifications\033[0m\n"
    fi

}
