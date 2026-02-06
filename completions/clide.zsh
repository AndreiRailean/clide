#!/bin/zsh
# shellcheck shell=bash
#compdef clide devclide

_clide() {
	local curcontext="$curcontext" state line
	typeset -A opt_args

	_arguments -C \
		'1:command:(init start stop list check update clean version help debug completions uninstall)' \
		'*::options:->args'

	case $state in
		args)
			case $words[2] in
				stop)
					local running_containers
					running_containers=($(clide list --raw 2>/dev/null))
					_values 'running containers' $running_containers
					;;
				*)
					# Default completion for other commands
					_describe 'command' \
						'init:Initialise a project' \
						'start:Launch or re-attach to the IDE for this project' \
						'stop:Stop the container for the current directory' \
						'list:List all currently running CLIDE environments' \
						'check:Run system diagnostics and check project context' \
						'update:Pull the latest CLIDE code and rebuild images' \
						'clean:Prune orphaned Docker networks and volumes' \
						'version:Show the current CLIDE version' \
						'help:Show help message' \
						'debug:Show debug information' \
						'completions:Initialise shell autocompletion' \
						'uninstall:Uninstall CLIDE'
					;;
			esac
			;;
	esac
}

_clide "$@"

