echo "![build status](https://travis-ci.org/macacollins/elm-vim.svg?branch=master)" > README.md
echo "# Statistics" >> README.md

echo "## Line count statistics" >> README.md
bash ./line_states.sh >> README.md

echo "## TODOs" >> README.md

echo "\`\`\`bash" >> README.md
echo $ grep -r TODO src >> README.md
grep -r TODO src >> README.md
echo "\`\`\`" >> README.md

