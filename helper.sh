set -x

# ns=b2dev
ns=b2

# app=prover
# app=approve
# app=sync
# app=eth-tx-manager
app=sequencer

# conf=dev
conf=tke

DATE=$(date +%Y%m%d-%H%M%S)
NET=http://192.168.0.22:30001
shopt -s expand_aliases
# alias req="curl -X POST -v --url $NET -H 'Content-Type: application/json;' --data ${2} "
alias req="curl -X POST --url $NET -H 'Content-Type: application/json' -s --data ${2} "

health(){
    req '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq .
    req '{"jsonrpc":"2.0","method":"net_version","params":[],"id":1}' | jq .
    req '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' | jq .
    # curl -X POST --url http://127.0.0.1:8123 -H 'Content-Type: application/json' -s --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
}

restart(){
    # kustomize -h
    # kustomize build dev
    # return
    kubectl delete -k $conf
    sleep 2
    kubectl apply -k $conf
    return
}

probe(){
    exec >"$FUNCNAME.log" 2>&1
    podid=$(kubectl get pod --selector=app=$app -o wide --namespace=$ns --output=json | jq .items[0].metadata.name | tr -d '"')
    kubectl logs $podid --namespace=$ns
    # kubectl describe pod $podid --namespace=$ns
}

inCon(){
    podid=$(kubectl get pod --selector=app=$app -o wide --namespace=$ns --output=json | jq .items[0].metadata.name | tr -d '"')
    kubectl exec $podid -it sh --namespace=$ns
}

sql(){
    ip=$(kubectl get pod --selector=app=statedb -o wide --namespace=$ns --output=json | jq .items[0].status.podIP| tr -d '"')
    export DATABASE_URL="postgres://state_user:state_password@$ip:5432/state_db?sslmode=disable"
    psql --echo-all $DATABASE_URL --file=zkevm-state.sql
    # postgres://state_user:state_password@dev-zkevm-state-db:5432/state_db?sslmode=disable
}

op(){
    # ip=$(kubectl get pod --selector=app=statedb -o wide --namespace=$ns --output=json | jq .items[0].status.podIP| tr -d '"')
    podid=$(kubectl get pod --selector=app=$app -o wide --namespace=$ns --output=json | jq .items[0].metadata.name | tr -d '"')
    kubectl cp b2dev/$podid:/var/lib/postgresql/data/postgresql.conf .
}

logCollector() {
    # exec >"$FUNCNAME.log" 2>&1
    DIR_NAME="log-$DATE"
    mkdir -p $DIR_NAME
    # kubectl get pod --namespace b2 --show-labels
    # kubectl get pod --namespace b2 --output=json
    name=$(kubectl get pod --namespace $ns --output=json | jq '.items[].metadata.name' | tr -d '"' | xargs)
    for item in $name; do
        kubectl logs --namespace b2 $item  > $DIR_NAME/$item
    done
}

$@
