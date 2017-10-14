echo src folder
cloc src

cd tests
echo tests folder
cloc --exclude-dir elm-stuff .

cd ..
