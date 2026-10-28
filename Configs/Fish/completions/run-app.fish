# run-app <device> <app>: first argument completes device labels, second one app packages.
complete -c run-app -f -n 'test (count (commandline -opc)) -le 1' -a '(run-app 2>/dev/null)'
complete -c run-app -f -n 'test (count (commandline -opc)) -eq 2' -a '(run-app (commandline -opc)[2] 2>/dev/null)'
