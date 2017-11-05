elm package install -y
elm make src/Main.elm --output=public/javascript/main.js
cp javascript/drive-api.js public/javascript/drive-api.js
cp html/public.html public/index.html
