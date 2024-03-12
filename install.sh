printf "\nInstalling dependencies...\n\n"
{
    apt-get install curl jq bc && printf "\nDone\n"
} || {
    echo "Error during installation of dependencies"
}

printf "Giving execute permission\n"
{
    chmod +x main.sh && printf "Done\n"
} || {
    printf "\nerror during chmod\n"
}

printf "\nAdding to PATH..."
# {
#     echo 'export TEST_PATH="$HOME/Projects/etna-cli"' >> ~/.bashrc && printf "Done\n"
# } || {
#     printf "\nThere was an error while adding to PATH"
# }