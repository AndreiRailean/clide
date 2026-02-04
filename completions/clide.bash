_clide_completions() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Standard subcommands
    opts="init start stop list check update clean version help"

    case "${prev}" in
        stop)
            # Ask clide itself for the active container names
            local running_containers=$(clide list --raw)
            COMPREPLY=( $(compgen -W "-a ${running_containers}" -- ${cur}) )
            return 0
            ;;
        *)
            ;;
    esac

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _clide_completions clide

