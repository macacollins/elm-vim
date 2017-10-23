module View.PortsScript exposing (portsScript)

import Html exposing (node)


portsScript =
    node "script" [] [ Html.text scriptItself ]



{-

-}


scriptItself =
    """
    if (typeof started === "undefined") {

        var app = Elm.Main.fullscreen()

        app.ports.writeBufferPort.subscribe(function(buffer) {
            // var suggestions = spellCheck(word);
            // app.ports.suggestions.send(suggestions);
            if (!window.localStorage) {
                throw "localStorage not enabled :("
            }

            window.localStorage.setItem("saved", JSON.stringify(buffer));
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

                app.ports.updateCurrentBuffer.send(value);
            }, 0);
        }
    }
"""
