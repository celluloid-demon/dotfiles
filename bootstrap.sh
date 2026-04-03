#!/bin/bash

# Exit on error
set -e

# Declare constants
readonly DOTFILES="${HOME}/.dotfiles"
readonly PROJECT_ROOT="$(dirname "${BASH_SOURCE[0]}")"

# cd into project root
cd "$PROJECT_ROOT"

function make_symlinks() {

    ln -s "${DOTFILES}/.bashrc" "${HOME}/.bashrc"
    ln -s "${DOTFILES}/.bashrc.d" "${HOME}/.bashrc.d"
    ln -s "${DOTFILES}/.bashrc.d.dev" "${HOME}/.bashrc.d.dev"
    # ln -s "${DOTFILES}/.gitconfig" "${HOME}/.gitconfig"
    # ln -s "${DOTFILES}/.tmux.conf" "${HOME}/.tmux.conf"
    # ln -s "${DOTFILES}/.zshrc" "${HOME}/.zshrc"

}

function make_symlinks_wrapper() {

    # (Run this from production ($DOTFILES) rather than development)

    if [ "$PROJECT_ROOT" == "$DOTFILES" ]; then

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
