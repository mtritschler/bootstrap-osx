#!/bin/bash

BASEDIR=$(dirname $0)

if [ ! command -v brew &>/dev/null ]; then
  echo "Please install Homebrew first (https://brew.sh)"
  exit 1
fi

function ssh_generate_keys {
  if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Generating new SSH keys";
    ssh-keygen -t rsa;
  else
    echo "Found existing SSH keys"
  fi
}

function brew_tap_casks () {
  brew tap caskroom/cask
  brew tap caskroom/versions
}

function brew_install_base () {
  brew install bash-completion jq
  if [ ! -f ~/.bash_profile ]; then
    touch ~/.bash_profile;
  fi

  local MARK_COMPLETION="# snippets/bash-completion";
  if ! grep -q "$MARK_COMPLETION" ~/.bash_profile; then
    echo "Adding bash-completion to ~/.bash_profile"
    echo $MARK_COMPLETION >> ~/.bash_profile;
    cat "$BASEDIR/snippets/completion" >> ~/.bash_profile;
  fi

  brew cask install iterm2
  brew cask install slack firefox atom 1password
}

function brew_install_devtools () {
  brew cask install java8
  brew install maven maven-completion gradle gradle-completion scala sbt
  brew cask install intellij-idea-ce
}

function print_usage() {
  printf "This script bootstraps a new machine with SSH keys and some elementary packages\n"
  printf '\nUsage:\n\tinstall.sh [OPTIONS]\n'
  printf '\nOptions:\n'
  printf '\t--devtools\tInstalls Java, Scala, build tools and IntelliJ\n'
}

INSTALL_DEVTOOLS=NO
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -h|--help)
    print_usage
    exit 0
    ;;
    --devtools)
    INSTALL_DEVTOOLS=YES
    shift
    ;;
    *)    # unknown option
    print_usage
    exit 0
    ;;
  esac
done

ssh_generate_keys

if [ ! brew ls --versions git &>/dev/null ]; then
  echo "Installing Git from Homebrew";
  brew install git;
  echo "Please restart your session and re-run this script";
else
  echo "Tapping Homebrew casks"
  brew_tap_casks;

  echo "Installing base packages from Homebrew";
  brew_install_base;

  if [ "$INSTALL_DEVTOOLS" == "YES" ]; then
    echo "Installing developer tools";
    brew_install_devtools;
  fi

  echo "You are all set to go...";
fi
