#!/bin/bash

# Exit on error
set -e

# Declare constants
readonly DOTFILES="${HOME}/.dotfiles"
readonly PROJECT_ROOT="$(dirname "${BASH_SOURCE[0]}")"

# cd into project root
cd "$PROJECT_ROOT"

function make_symlinks() {

    [ -f "${HOME}/.bashrc"       ] && mv "${HOME}/.bashrc"       "${HOME}/.bashrc.BAK"
    [ -d "${HOME}/.bashrc.d"     ] && mv "${HOME}/.bashrc.d"     "${HOME}/.bashrc.d.BAK"
    [ -d "${HOME}/.bashrc.d.dev" ] && mv "${HOME}/.bashrc.d.dev" "${HOME}/.bashrc.d.dev.BAK"

    ln -s "${DOTFILES}/.bashrc"       "${HOME}/.bashrc"
    ln -s "${DOTFILES}/.bashrc.d"     "${HOME}/.bashrc.d"
    ln -s "${DOTFILES}/.bashrc.d.dev" "${HOME}/.bashrc.d.dev"

}

function make_symlinks_wrapper() {

    # Make sure we are in the production clone of the repo ($DOTFILES) rather than development ($HOME/git, etc).

    if [ "$(pwd)" == "$DOTFILES" ]; then

        make_symlinks

    else

        echo "Error: Please run this script from the production directory (${DOTFILES})."
        exit 1

    fi

    echo "Symlinks created successfully."

}

function main() {


    case "$1" in

        # (Allow for unattended execution)
        --force|-f)

            make_symlinks_wrapper
            ;;

        # (Run interactively)
        *)

            read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
            [[ $REPLY =~ ^[Yy]$ ]] && make_symlinks_wrapper
            ;;

    esac

    echo
    echo "  Note: Create .DEVICE file to specify device-specific configuration (e.g. PROXY_PUBLIC, PROXY_PRIVATE, FEDORA, etc)."
    echo

}

main "$@"
