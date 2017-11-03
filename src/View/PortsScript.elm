module View.PortsScript exposing (portsScript)

import Html exposing (node)


{-

   All these goodies are to deal with elm reactor + ports.
   We should take it out if there's a better development server option

-}


portsScript =
    node "script" [] [ Html.text scriptItself ]


scriptItself =
    """
    if (typeof started === "undefined") {

        var app = Elm.Main.fullscreen();

        // intentionally global
        started = true;

        addGoogleDriveScripts();

        function initializeApp() {
            console.log("in initialize app");
            var mains = document.querySelectorAll("main")

            // this is to deal with elm-reactor
            // the above code works after a setTimeout (somewhere)
            // so we need to see if there is a main element already
            if (mains.length > 0) {
                var main = document.querySelector("main")
                if (!main) { alert("no main found after querySelectorAll(\\"main\\") returned multiple results."); }
                main.parentElement.removeChild(main);

                setTimeout(() => {
                    var value = JSON.parse(window.localStorage.getItem("saved"))
                    if (typeof value === "object" && value !== null) {
                        value.type = "FileLoaded";
                        app.ports.fromFileStorageJavaScript .send(value);
                    }
                }, 0);
            }
        }

        function addGoogleDriveScripts() {
            var head = document.querySelector("head");

            var driveOnload = function() {
                if (typeof gapi !== 'undefined') {
                    initializePorts(app);
                }
            }
            var driveAPIScript = addScriptForPath("/javascript/drive-api.js", driveOnload);
            head.appendChild(driveAPIScript);

            var googleOnload = function() {
                if (typeof initializePorts !== 'undefined') {
                    initializeApp();
                    initializePorts(app);
                }
            }
            var googleAPIScript = addScriptForPath("https://apis.google.com/js/api.js", googleOnload);
            head.appendChild(googleAPIScript);
        }

        function addScriptForPath(url, onload) {
            var newScript = document.createElement('script');
            newScript.type = 'text/javascript';
            newScript.charset = 'utf-8';
            newScript.defer = true;
            newScript.async = true;
            newScript.src = url
            newScript.onload = onload
            return newScript;
        }
    }
"""
