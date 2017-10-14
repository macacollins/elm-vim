#!bash

bash ./update_stats.sh
git add README.md

echo about to run git commit $@
git commit "$@"
