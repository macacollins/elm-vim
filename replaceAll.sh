echo Replacing $1 with $2
echo 's/$1/$2/'
a=$1
b=$2
find src -type f -iname '*.elm' -exec sed -i "s/$1/$2/" "{}" +;
