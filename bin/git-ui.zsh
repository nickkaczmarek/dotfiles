GIT_FOLDER="$(git rev-parse --show-toplevel 2>/dev/null)"
if [ "$1" == "-r" ]; then
    find "$GIT_FOLDER" -name .git -execdir open -a "$EDITOR_GIT" . \;
else
    if [ -e "$GIT_FOLDER/.git" ]; then
        echo "Opening $GIT_FOLDER in $(basename $EDITOR_GIT)"
        open -a "$EDITOR_GIT" "$GIT_FOLDER"
    else
        echo "Could not find git repository in $(pwd) or any parent"
    fi
fi

# Thanks Dave Delong for this.
# https://davedelong.com/blog/2023/03/04/handy-git-customizations/
