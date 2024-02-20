source $ETNA_CLI/lib/utils/checkcookies.sh

function tickets {
    checkcookies

    res=$(curl --silent -X GET https://tickets.etna-alternance.net/api/tasks.json -L -b $cookie_path)

    tickets_array=$(echo $res | jq -r ".data")

    if [[ -n $tickets_array && $(echo "$tickets_array" | jq length) -gt 0 ]]; then
        # Loops over each object in array and call it 'item'
        echo "$tickets_array" | jq -c '.[]' | while IFS= read -r item; do

            # Extract name and date from each item
            title=$(echo "$item" | jq -r '.title')
            status=$(echo "$item" | jq -r '.status')
            creator_login=$(echo "$item" | jq -r '.creator.login')

            if [[ $status = 'waiting' ]]; then
                printf "open\t"
            elif [[ $status = 'in progress' ]]; then
                printf "closed\t"
            else
                printf "$status"
            fi

            printf " \033[0;33m$title\033[0m (created by $creator_login)\n"

        done
    else
        printf "\033[0;33mNothing\033[0m\n"
    fi

}
