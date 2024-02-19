source $ETNA_CLI/lib/utils/checkcookies.sh

function userinfo {
    checkcookies

    identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b $cookie_path)
    id=$(echo $identity | jq -r ".id")
    informations=$(curl --silent -X GET https://auth.etna-alternance.net/api/users/$id -L -b $cookie_path)

    firstname=$(echo $informations | jq -r ".firstname")
    lastname=$(echo $informations | jq -r ".lastname")
    email=$(echo $informations | jq -r ".email")
    login=$(echo $informations | jq -r ".login")

    echo
    printf "Name       \033[0;34m$firstname $lastname\033[0m\n"
    printf "Login      $login\n"
    printf "Email      $email\n\n"

    exit 0
}
