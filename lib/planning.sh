source $ETNA_CLI/lib/utils/checkcookies.sh

function planning {
    checkcookies

    identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b /tmp/.etna-cookies)
    login=$(echo $identity | jq -r ".login")
    start_date=$(date +%Y-%m-%d)
    end_date=$(date -d "+1 month" +%Y-%m-%d)
    planning=$(
        curl --silent -X GET https://prepintra-api.etna-alternance.net/students/$login/events?end=$end_date\&start=$start_date -L -b /tmp/.etna-cookies
    )
    printf "\nEvents in your planning from now to $end_date (next month)\n"
    if [[ -n $planning && $(echo "$planning" | jq length) -gt 0 ]]; then
        # Loops over each object in array and call it 'item'
        echo "$planning" | jq -c '.[]' | while IFS= read -r item; do

            # Extract name and date from each item
            name=$(echo "$item" | jq -r '.activity_name')
            start=$(echo "$item" | jq -r '.start')
            printf "$start \033[0;33m$name\033[0m\n"

            # Iterate over the 'members' array within each item
            printf "Member(s):\n"
            echo "$item" | jq -c '.group.members[]' | while IFS= read -r member; do
                member_firstname=$(echo "$member" | jq -r '.firstname')
                member_lastname=$(echo "$member" | jq -r '.lastname')
                member_login=$(echo "$member" | jq -r '.login')
                printf "$member_firstname $member_lastname ($member_login)\n"
            done
            echo
        done
    else
        printf "\033[0;33mNothing\033[0m\n"
    fi
    echo
}
