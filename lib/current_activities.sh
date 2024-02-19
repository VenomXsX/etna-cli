source $ETNA_CLI/lib/utils/checkcookies.sh

function current_activities {
    checkcookies

    identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b $cookie_path)
    login=$(echo $identity | jq -r ".login")
    activities=$(curl --silent -X GET https://modules-api.etna-alternance.net/students/$login/currentactivities -L -b $cookie_path)

    printf "Logged in: \033[4:30m$login\033[0m\n"
    printf "Current date \033[0;32m$(date +"%Y-%m-%d %H:%M:%S")\033[0m\n\n"

    if [[ -z $activities ]]; then
        echo "Failed to fetch activities"
        exit 1
    fi
    # Get modules name first then iterate after
    modules=$(echo "$activities" | jq -r 'keys[]')
    for module in $modules; do
        projects=$(echo "$activities" | jq -r --arg mod "$module" '.[$mod].project')

        printf "=====\033[1:33m$module:\033[0m=====\n"

        # Checks if projects is not empty, check if array length > 0
        if [[ -n $projects && $(echo "$projects" | jq length) -gt 0 ]]; then
            # Loops over each object in array and call it 'item'
            echo "$projects" | jq -c '.[]' | while IFS= read -r item; do

                # Extract name and date from each item
                name=$(echo "$item" | jq -r '.name')
                date_end=$(echo "$item" | jq -r '.date_end')
                printf "$date_end \033[0;33m$name\033[0m\n"

            done
        else
            printf "\033[0;33mNothing\033[0m\n"
        fi
        echo
    done
    exit 0
}
