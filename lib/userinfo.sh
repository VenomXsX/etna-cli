source $ETNA_CLI/lib/utils/checkcookies.sh

function userinfo {
    checkcookies

    identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b /tmp/.etna-cookies)
    id=$(echo $identity | jq -r ".id")
    informations=$(curl --silent -X GET https://auth.etna-alternance.net/api/users/$id -L -b /tmp/.etna-cookies)

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