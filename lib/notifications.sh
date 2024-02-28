source $ETNA_CLI/lib/utils/checkcookies.sh

function notifications {
    checkcookies

    identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b $cookie_path)
    login=$(echo $identity | jq -r ".login")
    notifs=$(curl --silent -X GET https://prepintra-api.etna-alternance.net/students/$login/informations -L -b $cookie_path)

    if [[ -n $notifs && $(echo "$notifs" | jq length) -gt 0 ]]; then
        nb=$(echo "$notifs" | jq length)
        printf "\033[0;31m$nb unread notification(s) \033[0;30mhttps://intra.etna-alternance.net/\033[0m\n\n"

        echo "$notifs" | jq -c '.[]' | while IFS= read -r item; do
            message=$(echo $item | jq -r ".message")
            printf "$message\n"
            type=$(echo $item | jq -r ".metas.type")
            if [[ $type = "event_subscription" ]]; then
                printf "\033[0;36m==> https://intra.etna-alternance.net/#/user/$login/planning\033[0m\n\n"
            elif [[ $type = "module_show" ]]; then
                session_id=$(echo $item | jq -r ".metas.session_id")
                printf "\033[0;36m==> https://intra.etna-alternance.net/#/user/$login/elearning/$session_id\033[0m\n\n"
            elif [[ $type = "activity_show" ]]; then
                session_id=$(echo $item | jq -r ".metas.session_id")
                activity_id=$(echo $item | jq -r ".metas.activity_id")
                activity_type=$(echo $item | jq -r ".metas.activity_type")
                printf "\033[0;36m==> https://intra.etna-alternance.net/#/sessions/$session_id/$activity_type/$activity_id\033[0m\n\n"
            else
                printf "\n"
            fi
        done
    else
        printf "\n\033[0;32m0 unread notifications\033[0m\n"
    fi
}
