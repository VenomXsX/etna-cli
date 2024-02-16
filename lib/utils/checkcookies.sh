source $ETNA_CLI/lib/utils/nocookies.sh

function checkcookies {
    if [ ! -f "/tmp/.etna-cookies" ]; then
        nocookies
        exit 1
    fi
    identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b /tmp/.etna-cookies)
    if [[ $identity = 'Missing cookie' ]]; then
        printf "\nCookie expired, relogin first: \033[4metna login\033[0m\n\n"
        exit 1
    fi
}
