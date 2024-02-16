function help {
    echo
    printf "Usage: etna <command>\n"
    printf "Commands list:\n"
    echo
    printf "\033[0;32mlogin\033[0m:      to retrieve the session cookie necessary for other commands\n"
    printf "\033[0;32muserinfo\033[0m:   get logged in user informations\n"
    printf "\033[0;32mactivs\033[0m:     get current activities informations (on-going modules, etc.)\n"
    printf "\033[0;32mflush\033[0m:      removes the cookie from your login\n"
    echo
}
