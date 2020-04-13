# Sniff all Pods

Script for sniff all kubectl pods with an tcpdump command.  
   
## How it works

It will Iterate over a `kubectl get pods`  
Be sure the pod has a binary of tcpdump inside it in /tmp  
Run the tcpdump with givenned args and log all  
   
## Log files

For each pod it will generate:
- pod.log: give the mainly log with tcpdump capture
- pod.pid: pid of the capture process
- pod.err: stderr output

## Usage

Run with default args
``` shell
make run
```
Pass tcpdump args by `args` env and run by `make run`

``` shell
make run args="-vv tcp port (443 or 80)"
```

Run by main.sh
``` shell
$ ./main.sh -h
usage:
        ./main.sh [ARGS..]
 args:
   -h           help message
   -f           set tcpdump binary filepath (default static-tcpdump)
   -a           set tcpdump args (default -s256 tcp)
```

## Inspirated

Inspirated by https://github.com/eldadru/ksniff
