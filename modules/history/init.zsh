#
# Sets history options and defines history aliases.
#
# Authors:
#   Robby Russell <robby@planetargon.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Variables
#

# Shell history
HISTFILE="${ZDOTDIR:-$HOME}/.history/zsh-current"       # The path to the history file.
HISTSIZE=10000                   # The maximum number of events to save in the internal history.
SAVEHIST=10000                   # The maximum number of events to save in the history file.

# Other histories
export R_HISTFILE=~/.history/R-current

[[ `readlink ${ZDOTDIR:-$HOME}/.sqlite_history` = ".history/sqlite-current" ]] || (
  cd "${ZDOTDIR:-$HOME}"
  ln -s ".history/sqlite-current" .sqlite_history
)
sqlite3() {
  # Run the command
  command sqlite3 $*
  # Commit the history afterwards
  (
    cd "${ZDOTDIR:-$HOME}"/.history
    mv sqlite-current sqlite-"`date --rfc-3339 seconds`"
    git add .
    git commit sqlite -m 'sync sqlite3' > /dev/null
  )
}

#
# Options
#

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
unsetopt HIST_IGNORE_DUPS        # Record an event that was just recorded again.
unsetopt HIST_IGNORE_ALL_DUPS    # Keep an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
unsetopt HIST_SAVE_NO_DUPS       # Write duplicate events to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing non-existent history.

#
# Aliases
#

# Lists the ten most used commands.
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

# Archive the history
_archive_history() {
  # Do nothing if the file is small.
  test `wc -l "${ZDOTDIR:-$HOME}/.history/zsh-current"|cut -d\  -f1` -lt 1000 && return

  # Timestamp
  now="`date --rfc-3339 seconds`"

  # Move the file
  mv "${ZDOTDIR:-$HOME}/.history/zsh-current" "${ZDOTDIR:-$HOME}/.history/zsh-$now"

  # Add and commit it.
  echo 'Committing your history file'
  (
    cd "${ZDOTDIR:-$HOME}/.history"
    git init
    git add zsh-*
    git commit . -m "$now"
  )
}
add-zsh-hook precmd _archive_history
