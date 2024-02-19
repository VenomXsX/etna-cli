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

            #TODO: Working on displaying remaining days

            # difference_seconds=$($(date -d '$given_date' +%s) - $(date -d '$current_date' +%s))
            # remaining_days=$($difference_seconds / (60 * 60 * 24))

            printf "$start \033[0;33m$name\033[0m (in $remaining_days)\n"

            # Iterate over the 'members' array in each item
            printf "Member(s):\n"
            echo "$item" | jq -c '.group.members[]' | while IFS= read -r member; do
                member_firstname=$(echo "$member" | jq -r '.firstname')
                member_lastname=$(echo "$member" | jq -r '.lastname')
                member_login=$(echo "$member" | jq -r '.login')
                printf "\033[0;34m$member_firstname $member_lastname\033[0m ($member_login)\n"
            done
            echo
        done
    else
        printf "\033[0;33mNothing\033[0m\n"
    fi
    echo
}
