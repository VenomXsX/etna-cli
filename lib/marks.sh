source $ETNA_CLI/lib/utils/checkcookies.sh

function marks {
    checkcookies

    identity=$(curl --silent -X GET https://auth.etna-alternance.net/identity -L -b $cookie_path)
    promo=$(curl --silent -X GET https://prepintra-api.etna-alternance.net/promo -L -b $cookie_path)
    login=$(echo $identity | jq -r ".login")

    # select the first objects
    promo_id=$(echo $promo | jq -r "[.[] | select (.id)][0] | .id")
    grades=$(curl --silent -X GET https://prepintra-api.etna-alternance.net/terms/$promo_id/students/$login/marks -L -b $cookie_path)
    printf "\nMarks for: $login\n"

    if [[ -n $grades && $(echo "$grades" | jq length) -gt 0 ]]; then
        grades_list=()
        echo
        while IFS= read -r item; do
            activ_name=$(echo $item | jq -r ".activity_name")
            uv_name=$(echo $item | jq -r ".uv_name")
            uv_long_name=$(echo $item | jq -r ".uv_long_name")
            student_mark=$(echo $item | jq -r ".student_mark")

            # to get the average mark
            if [[ ! $student_mark = "null" ]]; then
                grades_list+=($student_mark)
                printf "\033[1m$activ_name\033[0m | \033[0;30m$uv_long_name\033[0m (\033[0;33m$uv_name\033[0m)\n"
                printf "Mark: \033[0;36m$student_mark\033[0m\n"
                echo
            fi
        done < <(echo "$grades" | jq -c '.[]') # this to not use the old pipeline method in the other files

        grade_sum=0
        for num in "${grades_list[@]}"; do
            # bs=basic calculator for float ....
            grade_sum=$(echo "$grade_sum + $num" | bc)
        done

        # Calculate the average
        if [[ ${#grades_list[@]} -gt 0 ]]; then
            # using bc for floats as before
            average=$(echo "scale=2; $grade_sum / ${#grades_list[@]}" | bc)
            printf "\n\033[1mAverage: \033[1;33m$average\033[0m pts\n\n"
        fi
    else
        printf "\n\033[0;32mNo marks found\033[0m\n"
    fi
}
