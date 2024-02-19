function flush {
    if [ -f "$cookie_path" ]; then
        rm "$cookie_path"
        printf "Deleted the cookie\n"
        exit 0
    fi
    printf "No cookie found\n"
}
