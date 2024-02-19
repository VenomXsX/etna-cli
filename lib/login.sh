function login {
    if [ -f $cookie_path ]; then
        rm $cookie_path
    fi
    echo
    read -p "Login: " login
    read -sp "Password: " password
    echo
    mkdir -p "$HOME/etna-cli-tmp/"
    res=$(curl --silent -c $cookie_path -X POST https://auth.etna-alternance.net/login -d "login=$login&password=$password")
    if [[ $res = "{}" ]]; then
        printf "Not authenticated\n"
        rm $cookie_path
        exit 1
    fi
    identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b $cookie_path)
    email=$(echo $identity | jq -r '.email')
    printf "Logged in: \033[4m$email\033[0m\n\n"
}
