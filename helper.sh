set -x
ns=b2dev

restart(){
    # kustomize -h
    # kustomize build dev
    # return
    kubectl delete -k dev
    sleep 2
    kubectl apply -k dev
    return
}

probe(){
    # exec >"$FUNCNAME.log" 2>&1
    # podid=$(kubectl get pod --selector=app=statedb -o wide --namespace=$ns --output=json | jq .items[0].metadata.name | tr -d '"')
    # kubectl logs $podid --namespace=$ns
    kubectl describe pod $podid --namespace=$ns
}

inCon(){
    podid=$(kubectl get pod --selector=app=statedb -o wide --namespace=$ns --output=json | jq .items[0].metadata.name | tr -d '"')
    kubectl exec $podid -it sh --namespace=$ns
}

sql(){
    ip=$(kubectl get pod --selector=app=statedb -o wide --namespace=$ns --output=json | jq .items[0].status.podIP| tr -d '"')
    export DATABASE_URL="postgres://state_user:state_password@$ip:5432/state_db?sslmode=disable"
    psql --echo-all $DATABASE_URL --file=zkevm-state.sql


}
$@
