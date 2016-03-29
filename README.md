# toy1
innocent fun with distributed systems

## Build & test

    stack clean && stack build --pedantic && stack test

## Start a cluster

    HOST=127.0.0.1
    stack exec toy1 $HOST:2001 $HOST:2002 $HOST:2003 &
    stack exec toy1 $HOST:2002 $HOST:2003 $HOST:2001 &
    stack exec toy1 $HOST:2003 $HOST:2001 $HOST:2002 &
    # later:
    pkill toy1
  

## Things to try

    root@y:~# tc qdisc add dev lo root netem loss 50%
    root@y:~# tc qdisc change dev lo root netem loss 90%
    root@y:~# tc qdisc del dev lo root netem loss 90%
  
