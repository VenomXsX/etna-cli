source $ETNA_CLI/lib/utils/checkcookies.sh

function marks {
    checkcookies

    identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b /tmp/.etna-cookies)
    promo=$(curl --silent -X GET https://prepintra-api.etna-alternance.net/promo -L -b /tmp/.etna-cookies)
    login=$(echo $identity | jq -r ".login")

    # select the first objects
    promo_id=$(echo $promo | jq -r "[.[] | select (.id)][0] | .id")
    echo $promo_id

    grades=$(curl --silent -X GET https://prepintra-api.etna-alternance.net/terms/$promo_id/students/$login/marks -L -b /tmp/.etna-cookies)
    echo $grades
}
