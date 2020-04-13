#!/bin/sh

set -o errexit
set -o nounset

DEFAULT_TCPDUMP_FN=static-tcpdump
DEFAULT_TCPDUMP_ARGS="-s256 tcp"

usage() {
    echo "usage:"
    echo "	$0 [ARGS..]"
    echo " args:"
    echo "   -h		help message"
    echo "   -f		set tcpdump binary filepath (default $DEFAULT_TCPDUMP_FN)"
    echo "   -a		set tcpdump args (default $DEFAULT_TCPDUMP_ARGS)"
}

err() {
    echo "err: "$@
    usage
    exit 1
}

while getopts "hf:a:" OPT; do
    case "$OPT" in
	"h") usage && exit 0;;
	"f") filepath=$OPTARG;;
	"a") args=$OPTARG;;
	"?") exit 1;;
    esac
done

TCPDUMP_FN=${filepath:-$DEFAULT_TCPDUMP_FN}
TCPDUMP_ARGS=${args:-$DEFAULT_TCPDUMP_ARGS}

[ -f $TCPDUMP_FN ] || err missing $TCPDUMP_FN file

logp() {
    pod=$1
    msg=$2
    echo [$(date +%d-%m-%Y_%H:%M:%S)]$pod: $msg
}

all_pods=$(kubectl get pods | awk '{ print $1 }' | grep -v '^NAME$')
filepath=/tmp/${TCPDUMP_FN}

for pod in $all_pods
do
    if ! kubectl exec -it $pod -- /bin/sh -c "test -f $filepath"
    then
	logp $pod "missing binary; send to pod"
	kubectl cp $TCPDUMP_FN $pod:$filepath
    fi

    kubectl exec -it $pod -- /tmp/static-tcpdump $TCPDUMP_ARGS 1> $pod.log 2> $pod.err &
    pid=$!
    logp $pod "spaw $pid process to capture"
    echo $pid > $pod.pid
done
