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
        }, 0);
    }
"""
