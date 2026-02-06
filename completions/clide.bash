#!/usr/bin/env bash
_clide_completions() {
	local cur prev opts exe
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"

	# Identify which executable is being used (clide or devclide)
	exe="${COMP_WORDS[0]}"

	opts="init start stop list check update clean version help debug completions"

	case "${prev}" in
		stop)
			# Ask clide itself for the active container names
			local running_containers
			running_containers=$($exe list --raw 2>/dev/null)
			# Use a loop for compatibility with older Bash versions (pre-4.0)
			local i=0
			for c in $(compgen -W "${running_containers}" -- "$cur"); do
				COMPREPLY[i]="$c"
				i=$((i+1))
			done
			return 0
			;;
		*)
			;;
	esac

	while IFS='' read -r line; do COMPREPLY+=("$line"); done < <( compgen -W "${opts}" -- "${cur}" )
}

complete -F _clide_completions clide
if command -v devclide >/dev/null 2>&1; then
	complete -F _clide_completions devclide
fi

