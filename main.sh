#!bin/bash
source $ETNA_CLI/lib/current_activities.sh
source $ETNA_CLI/lib/utils/flush.sh
source $ETNA_CLI/lib/help.sh
source $ETNA_CLI/lib/login.sh
source $ETNA_CLI/lib/userinfo.sh
source $ETNA_CLI/lib/planning.sh

case $1 in
login) login ;;
userinfo) userinfo ;;
activs) current_activities ;;
flush) flush ;;
planning) planning ;;
help) help ;;
*)
    echo "use 'etna help' for usage"
    help
    ;;
esac
