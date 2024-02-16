function flush {
    if [ -f "/tmp/.etna-cookies" ]; then
        rm "/tmp/.etna-cookies"
        printf "Deleted the cookie\n"
        exit 0
    fi
    printf "No cookie found\n"
}
