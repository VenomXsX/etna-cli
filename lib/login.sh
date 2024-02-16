function login {
    if [ -f "/tmp/.etna-cookies" ]; then
        rm "/tmp/.etna-cookies"
    fi
    echo
    read -p "Login: " login
    read -sp "Password: " password
    echo
    res=$(curl --silent -c '/tmp/.etna-cookies' -X POST https://auth.etna-alternance.net/login -d "login=$login&password=$password")
    if [[ $res = "{}" ]]; then
        printf "Not authenticated\n"
        rm /tmp/.etna-cookies
        exit 1
    fi
    identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b /tmp/.etna-cookies)
    email=$(echo $identity | jq -r '.email')
    printf "Logged in: \033[4m$email\033[0m\n\n"
}
