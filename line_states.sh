echo "### src folder"
echo "\`\`\`bash"
echo $ cloc src
cloc src
echo "\`\`\`"

cd tests
echo "### tests folder"
echo "\`\`\`bash"
echo $ cloc --exclude-dir elm-stuff .
cloc --exclude-dir elm-stuff .
echo "\`\`\`"

cd ..
