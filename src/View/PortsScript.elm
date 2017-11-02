module View.PortsScript exposing (portsScript)

import Html exposing (node)


portsScript =
    node "script" [] [ Html.text scriptItself ]


scriptItself =
    """
    if (typeof started === "undefined") {

        document.addEventListener('keydown', function(event) {
            if (event.keyCode === 9) {
                event.preventDefault();
            }
        });


        var app = Elm.Main.fullscreen()

        setTimeout(() => { initializeDrive(app) }, 1000);

        app.ports.localStorageToJavaScript.subscribe(function(message) {
            if (!window.localStorage) {
                throw "localStorage not enabled :("
            }
            console.log("about to crash for message ", message);


            switch (message.type) {
                case "WriteFile":
                    window.localStorage.setItem(message.name, JSON.stringify(message.payload));
                    break;

                case "WriteProperties":
                    window.localStorage.setItem("savedProperties", JSON.stringify(message.payload));
                    break;

                case "LoadProperties":
                    const props =
                        window.localStorage.getItem("savedProperties");

                    console.log("Got props", props);

                    if (props) {
                        const message =
                            { type : "PropertiesLoaded"
                            , properties : JSON.parse(props)
                            }
                        app.ports.localStorageToElm.send(message)
                    }

                    break;

                case "LoadFile":
                    var value = JSON.parse(window.localStorage.getItem(message.name));
                    if (value !== null) {
                        value.type = "FileLoaded";
                        app.ports.localStorageToElm.send(value);
                    } else {
                        console.log("got null value in LoadFile");
                    }
                    break;

                case "GetFileList":
                    // Still TODO!
                    const fileListMessage =
                        { type : "FileList"
                        , files :
                            [ { name : "saved", id : "saved" }
                            ]
                    }

                    app.ports.localStorageToElm.send(fileListMessage)
                    break;
            }

        });

        started = true;

        var mains = document.querySelectorAll("main")

        // this is to deal with elm-reactor
        // the above code works after a setTimeout (somewhere)
        // so we need to see if there is a main element already
        if (mains.length > 0) {
            var main = document.querySelector("main")
            if (!main) { alert("no main."); }
            main.parentElement.removeChild(main)

            setTimeout(() => {
                var value = JSON.parse(window.localStorage.getItem("saved"))
                if (value !== null) {
                    value.type = "FileLoaded"
                    app.ports.localStorageToElm.send(value);
                }
            }, 0);
        }

        function addGoogleDriveScripts() {
            var head = document.getElementsByTagName('head')[0];
            var driveAPIScript = document.createElement('script');
            driveAPIScript.type = 'text/javascript';
            driveAPIScript.charset = 'utf-8';
            driveAPIScript.id = 'drive';
            driveAPIScript.defer = true;
            driveAPIScript.async = true;
            driveAPIScript.src = "/javascript/drive-api.js"
            driveAPIScript.onload = function() {
                if (typeof gapi !== 'undefined') {
                    initializeDrive(app);
                }
            }
            head.appendChild(driveAPIScript);

            var googleAPIScript = document.createElement('script');
            googleAPIScript.type = 'text/javascript';
            googleAPIScript.charset = 'utf-8';
            googleAPIScript.id = 'drive';
            googleAPIScript.defer = true;
            googleAPIScript.async = true;
            googleAPIScript.src = "https://apis.google.com/js/api.js"
            googleAPIScript.onload = function() {
                if (typeof initializeDrive !== 'undefined') {
                    initializeDrive(app);
                }
            }
            head.appendChild(googleAPIScript);
        }

        // this is getting ridiculous
        // let's maybe move this to a separate file
        setTimeout( () => {
            var body = document.querySelector('body');
            body.onpaste = function(e) {
              var pastedText = undefined;
              if (window.clipboardData && window.clipboardData.getData) { // IE
                pastedText = window.clipboardData.getData('Text');
              } else if (e.clipboardData && e.clipboardData.getData) {
                pastedText = e.clipboardData.getData('text/plain');
              }
              console.log("pasted", pastedText);
              if (typeof pastedText === 'string') {
                  app.ports.paste.send(pastedText);
              }
              return false; // Prevent the default handler from running.
            };


            addGoogleDriveScripts();

        }, 0);
    }
"""
