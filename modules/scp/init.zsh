scp() {
  # Do nothing if no colon is provided.

  has_colon=false
  echo "$*"|grep ':' > /dev/null && has_colon=true

  if $has_colon
    then
    command scp $*
  else
    command scp --help
    echo \ 
    echo "warning: The scp command that you ran has no colon, so you probably don't"
    echo '       want to run it. Use "env scp" if you really meant to do that.'
    return 1
  fi
}

