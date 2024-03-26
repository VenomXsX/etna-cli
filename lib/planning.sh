source $ETNA_CLI/lib/utils/checkcookies.sh

function planning {
    checkcookies

    identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b $cookie_path)
    login=$(echo $identity | jq -r ".login")
    today=$(date +%Y-%m-%d)
    end_date=$(date -d "+1 month" +%Y-%m-%d)
    planning=$(
        curl --silent -X GET https://prepintra-api.etna-alternance.net/students/$login/events?end=$end_date\&start=$today -L -b $cookie_path
    )
    printf "Events in your planning from now to $end_date (next month)\n\n"
    if [[ -n $planning && $(echo "$planning" | jq length) -gt 0 ]]; then
        # Loops over each object in array and call it 'item'
        echo "$planning" | jq -c '.[]' | while IFS= read -r item; do

            # Extract name and date from each item
            name=$(echo "$item" | jq -r '.activity_name')
            start=$(echo "$item" | jq -r '.start')

            type=$(echo "$item" | jq -r '.type')

            start_sec=$(date -d "$start" +%s)
            today_sec=$(date -d "$today" +%s)
            remaining_days=$((($start_sec - $today_sec) / 86400))

            printf "\033[0;36m$start\033[0m | \033[0;33m$name\033[0m | \033[0;35m$type\033[0m "
            if [[ $remaining_days -eq 0 ]]; then
                printf "(today)\n"
            elif [[ $remaining_days -eq 1 ]]; then
                printf "(tomorrow)\n"
            else
                printf "(in $remaining_days days)\n"
            fi

            # Iterate over the 'members' array in each item
            printf "Member(s):\n"
            if [ "$(echo "$item" | jq -c '.group.members')" = "null" ]; then
                echo "No member data available"
            else
                echo "$item" | jq -c '.group.members[]' | while IFS= read -r member; do
                    member_firstname=$(echo "$member" | jq -r '.firstname')
                    member_lastname=$(echo "$member" | jq -r '.lastname')
                    member_login=$(echo "$member" | jq -r '.login')
                    printf "\033[0;34m$member_firstname $member_lastname\033[0m ($member_login)\n"
                done
            fi
            echo
        done
    else
        printf "\033[0;33mNothing\033[0m\n"
    fi
    echo
}
