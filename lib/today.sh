source $ETNA_CLI/lib/utils/checkcookies.sh
source $ETNA_CLI/lib/planning.sh
source $ETNA_CLI/lib/notifications.sh

function today {
    checkcookies

    planning
    echo "=================="
    notifications

}
