_clide_completions() {
    local cur prev opts exe
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Identify which executable is being used (clide or devclide)
    exe="${COMP_WORDS[0]}"
    
    opts="init start stop list check update clean version help debug shell-init"

    case "${prev}" in
        stop)
            # Ask clide itself for the active container names
            local running_containers=$($exe list --raw 2>/dev/null)
            COMPREPLY=( $(compgen -W "-a ${running_containers}" -- ${cur}) )
            return 0
            ;;
    esac

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _clide_completions clide
if command -v devclide >/dev/null 2>&1; then
    complete -F _clide_completions devclide
fi

