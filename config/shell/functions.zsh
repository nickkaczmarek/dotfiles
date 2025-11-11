
function notes() {
    bbedit ~/Documents/work/notes
}

function today() {
    touch ~/Documents/work/notes/$(date -I).md
    bbedit ~/Documents/work/notes/$(date -I).md
}

function yesterday() {
    yesterday=$(date -v-1d +"%Y-%m-%d")
    touch ~/Documents/work/notes/${yesterday}.md
    bbedit ~/Documents/work/notes/${yesterday}.md
}

function xcopen() {
  local xcode_version="$(xcode-select -p | rg '(.+Xcode.+\.app|.+Xcode\.app)' -or '$1')"
  while test $# -gt 0
  do
    case "$1" in
      (-h | --help) echo "xcopen - open Xcode"
        echo " "
        echo "xcopen [options] [directory]"
        echo " "
        echo "options:"
        echo "-h, --help        show brief help"
        echo "--beta            open latest Xcode beta"
        echo " "
        echo "directory:"
        echo "Opens in current directory or you can supply one"
        return 0 ;;
      (--beta) xcode_version="/Applications/$(ls -a /Applications | rg Xcode.+Beta | tail -1)"
        shift
        break ;;
      (*) break ;;
    esac
  done
  open -a $xcode_version ${1:-"."} -F
}

function co-authors() {
  local ME=`git config --global user.initials`
  # Set Initials here
  local -A initialsMap
  while IFS== read -r key value; do
    initialsMap[$key]=$value
  done < "${HOME}/.gitpairs"
  # Parse parameters
  local parsed=("${(@s/-/)${*}}")
  local newline=$'\n'
  # NEED TO EXIT IF NO INITIALS
  if [ ${#parsed[@]} -eq 1 ]; then
    echo "${RED}No initials found." 1>&2;
    return 1
  fi
  local initialsList=("${(@s/ /)parsed[-1]}")
  initialsList=(${(L)initialsList})
  if [ ${#initialsList[@]} -eq 0 ]; then
    echo "${RED}No initials found." 1>&2;
    return 1
  fi
  initialsList=("${(@)initialsList:#$ME}")
  coAuthors=""
  [ ${#initialsList[@]} -eq 0 ] && return 0;
  coAuthors="${newline}"
  for initial in $initialsList ; do
    if [[ ! -z "${initialsMap[${(L)initial}]}" ]];
    then
      coAuthors="${coAuthors}${newline}${initialsMap[${(L)initial}]}"
    else
      echo "${RED}Unknown initials: $initial" 1>&2;
      return 1
    fi
  done;
}

function wip() {
  co-authors ${*} || return 1;
  git commit -S \
  -m "[skip ci] ${*}" \
  -m "[`basename $(git symbolic-ref -q --short HEAD)`]" \
  -m "${coAuthors}"
}

function commit() {
  co-authors ${*} || return 1;
  git commit -S \
  -m "${*}" \
  -m "[`basename $(git symbolic-ref -q --short HEAD)`]" \
  -m "${coAuthors}"
}

startdemo() {
  # Dock + menu bar (Sequoia-safe via AppleScript)
  osascript <<'EOF'
  tell application "System Events"
    tell dock preferences to set autohide to true
    tell dock preferences to set autohide menu bar to true
  end tell
EOF

  # Hide desktop icons
  defaults write com.apple.finder CreateDesktop -bool false
  killall Finder

  # Do Not Disturb (choose one)
  shortcuts run "DND On" >/dev/null 2>&1
}

enddemo() {
  # Dock + menu bar back
  osascript <<'EOF'
  tell application "System Events"
    tell dock preferences to set autohide to false
    tell dock preferences to set autohide menu bar to false
  end tell
EOF

  # Show desktop icons
  defaults write com.apple.finder CreateDesktop -bool true
  killall Finder

  # Do Not Disturb OFF (or toggle)
  shortcuts run "DND Off" >/dev/null 2>&1
}

function get-git-branch {
  echo "[`basename $(git symbolic-ref -q --short HEAD)`]"
}
