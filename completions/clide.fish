# clide completions for fish shell
function __clide_complete
    set -l tokens (commandline -opc)
    set -l cmd $tokens[1]
    set -l subcmd $tokens[2]
    set -l last_token (commandline -ct)

    if test (count $tokens) -eq 1
        # Complete main commands
        echo "init\tInitialise a project"
        echo "start\tLaunch or re-attach to the IDE"
        echo "stop\tStop the container"
        echo "list\tList active CLIDE environments"
        echo "check\tRun system diagnostics"
        echo "update\tPull latest CLIDE code"
        echo "clean\tPrune Docker networks/volumes"
        echo "version\tShow CLIDE version"
        echo "help\tShow help message"
        echo "debug\tShow debug information"
        echo "completions\tInitialise shell autocompletion"
        echo "uninstall\tUninstall CLIDE"
    else if test "$subcmd" = "stop"
        # Complete container names for 'stop'
        set -l running_containers (clide list --raw)
        for container in $running_containers
            echo "$container"
        end
    else if test "$subcmd" = "completions"
        # Complete shell names for 'completions'
        echo "bash"
        echo "zsh"
        echo "fish"
    end
end

complete -c clide -f -a "(__clide_complete)"

