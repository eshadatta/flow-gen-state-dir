#!/bin/bash
# this script installs the flow state generation code
# code assumes RVM already installed
. conf/flow_state_dirs.conf

# Load RVM into a shell session *as a function*
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
    # First try to load from a user install
    source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
    # Then try to load from a root install
    source "/usr/local/rvm/scripts/rvm"
else
    printf "ERROR: An RVM installation was not found.\n"
fi

# check if ruby version exists
version=`$HOME/.rvm/scripts/rvm list | grep $RVM_RUBY_VERSION`
if [[ ! -z "$version" ]]; then
  rvm use $RVM_RUBY_VERSION
  # check if gemset exists
  gemset=`rvm gemset list | grep $RVM_RUBY_GEMSET`
  if [[ ! -z "$gemset" ]]; then
    rvm gemset use $RVM_RUBY_GEMSET
  fi
# if version doesn't exist
# create it and the gemset
else
  echo "--- installing ruby ---"
  rvm install "$RVM_RUBY_VERSION"
  echo "--- selecting ruby ---"
  rvm use "$RVM_RUBY_VERSION"
  echo "--- creating gemset ---"
  rvm gemset use "${RVM_RUBY_GEMSET}" --create
  echo "--- reloading rvm   ---"
  rvm reload
  echo "--- installing bundler ---"
  gem install bundler
  echo "--- installing gems ---"
  bundle install
fi

flow_dir=$(dirname "${FLOW_INFO}")
if [[ ! -d "$flow_dir" ]]; then
    echo "--- creating flow info directory: ${flow_dir} ---"
    flow_dir=$(dirname "${FLOW_INFO}")
    mkdir flow_dir
    chmod 700 flow_dir
    echo "--copying flow info file to ${FLOW_INFO} ---"
    cp $INSTALL_FILE $flow_dir
fi
echo "--- installation complete ---"
