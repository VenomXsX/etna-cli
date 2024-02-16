source $ETNA_CLI/lib/utils/checkcookies.sh

function planning {
    checkcookies

    identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b /tmp/.etna-cookies)
    login=$(echo $identity | jq -r ".login")
    start_date=$(date +%Y-%m-%d)
    end_date=$(date -d "+1 month" +%Y-%m-%d)
    planning=$(
        curl -i -L -X GET https://prepintra-api.etna-alternance.net/students/$login/events?end=$end_date\&start=$start_date
    )
    printf "$planning\n"
    # printf "https://prepintra-api.etna-alternance.net/students/$login/events?end=$end_date&start=$start_date\n"
}
