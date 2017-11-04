let cloudVIMDriveInitialized;

function initializePorts(app) {
    if (typeof cloudVIMDriveInitialized !== 'undefined') {
        return;
    } else {
        app.ports.toFileStorageJavaScript.subscribe(handleMessageFromElm);
    }

    // intentionally global-- TODO consider using window / namespace
    cloudVIMDriveInitialized = true;

    function sendMessageToElm(message) {
        console.log("Sending message to elm", message);
        app.ports.fromFileStorageJavaScript.send(message)
    }

    const driveHandleMessageFromElm = wrapDriveMessageHandler(sendMessageToElm);
    const localStorageHandleMessageFromElm = wrapLocalStorageMessageHandler(sendMessageToElm);

    function handleMessageFromElm(message) {
        console.log("JS got message", message);
        switch (message.storageMethod) {
            case "GoogleDrive":
                driveHandleMessageFromElm(message);
                break;

            case "LocalStorage":
                localStorageHandleMessageFromElm(message);
                break;
        }
    }

    // TODO move the below into a function addWindowListeners or similar
    // this code passes tabs to Elm and prevents changing focus.
    document.addEventListener('keydown', function(event) {
        if (event.keyCode === 9) {
            event.preventDefault();
        }
    });


    window.addEventListener("keydown", function(event) {

      if (event.key === 'l' && event.ctrlKey) {
          event.preventDefault()
          event.stopPropagation()
          const fileListMessage =
              { type : "TriggerFileSearch"
              }

          sendMessageToElm(fileListMessage)
      }
      return false
    })

    // this part adds the paste handler, which still uses another port
    // I don't love it, but this doesn't quite fit in the File API port
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

    console.log("Sending initialized message to Elm.");
    initializationMessage =
        { type : "JavaScriptInitialized" }

    sendMessageToElm(initializationMessage );
}

//////////////////////////////////////////////////////////////////////
//                     Google Drive Event Handler
//////////////////////////////////////////////////////////////////////



function wrapDriveMessageHandler(sendMessageToElm) {
    let signedIn = false;
    if (typeof sendMessageToElm !== 'function') {
        console.log("didn't receive a function in wrapDriveMessageHandler", sendMessageToElm);
        return;
    } else {
        // Client ID and API key from the Developer Console
        var CLIENT_ID = '839363603519-kb1olgtasm8i92e49gduihh12e0328pt.apps.googleusercontent.com';
        var API_KEY = 'AIzaSyBTQf0HmLUFr8V6NSls5eWRPKC79bmB2t8';
        var DEFAULT_FIELDS = 'id,title,mimeType,userPermission,editable,copyable,shared,fileSize';

        // Array of API discovery doc URLs for APIs used by the quickstart
        var DISCOVERY_DOCS = ["https://www.googleapis.com/discovery/v1/apis/drive/v3/rest"];

        // Authorization scopes required by the API; multiple scopes can be
        // included, separated by spaces.
        var SCOPES = 'https://www.googleapis.com/auth/drive';

        var lastFileMetadata =
            { "kind": "drive#file"
            , "mimeType": "text/plain"
            }
        return driveHandleMessageFromElm;
    }

    function driveHandleMessageFromElm(message) {
        switch (message.type) {
            case 'Initialize':
                console.log("initializing google drive");
                handleClientLoad();
                return;
                
            case 'WriteFile' :
                writeFile(message);
                return;

            case 'LoadFile' :
                if (!message.id) {
                    console.log("LoadFile message without id.");
                    // TODO send something back to Elm
                } else {
                    loadFile(message.id);
                }
                return;

            case 'TriggerSignout' :
                handleSignout();
                return;

            case 'TriggerSignin' :
                handleAuth();
                return;

            case 'GetFileList' :
                listFiles();
                return;

            default:
                console.log("Not sure what to do with ", message)
        }
    }

    // TODO Figure out a "real" promise library
    function getDriveClient() {
        return { 
            then : function(handler) {
                if (gapi && gapi.client && gapi.client.drive) {
                    handler(gapi.client.drive);
                } else {
                    setTimeout( () => {
                        console.log("Drive client not initialized. Waiting a second and trying again.");
                        getDriveClient().then(handler);
                    }, 100);
                }
           }
        }
    }


    /**
     *  On load, called to load the auth2 library and API client library.
     */
    function handleClientLoad() {
        gapi.load('client:auth2', initClient);
    }
    
    /**
     *  Initializes the API client library and sets up sign-in state
     *  listeners.
     */
    function initClient() {
        gapi.client.init({
            apiKey: API_KEY,
            clientId: CLIENT_ID,
            discoveryDocs: DISCOVERY_DOCS,
            scope: SCOPES
        }).then(function () {
            // Listen for sign-in state changes.
            gapi.auth2.getAuthInstance().isSignedIn.listen(updateSigninStatus);

            // Handle the initial sign-in state.
            updateSigninStatus(gapi.auth2.getAuthInstance().isSignedIn.get());
        });
    }


    /**
     *  Called when the signed in status changes, to update the UI
     *  appropriately. After a sign-in, the API is called.
     *
     *  This port is 
     *  { type : 'UpdateSigninStatus'
     *  , isSignedIn : Bool
     *  }
     */
    function updateSigninStatus(isSignedIn) {
        signedIn = isSignedIn;
    }

    /**
     *  Sign in the user upon button click.
     */
    function handleAuth() {
        gapi.auth2.getAuthInstance().signIn();
    }

    /**
     *  Sign out the user upon button click.
     */
    function handleSignout() {
        gapi.auth2.getAuthInstance().signOut();
    }

    /**
     * Append a pre element to the body containing the given message
     * as its text node. Used to display the results of the API call.
     *
     * @param {string} message Text to be placed in pre element.
     *
     * won't go to elm
     */
    function appendPre(id, message) {
        var pre = document.getElementById('content');
        var textContent = document.createElement("div");

        var innerText = document.createTextNode(message);
        textContent.appendChild(innerText);
        textContent.id = "option" + id;
        pre.appendChild(textContent);
        textContent.addEventListener("click", function() {
            loadFile(id);
        });
    }

    /**
     * Load a file from drive and return the results.
     *
     * To trigger:
     * { type : 'LoadFile'
     * , id : String
     * }
     *
     * Sends back:
     * { type : 'FileLoaded'
     * , metadata :
     *     { "kind": "drive#file",
     *     , "id": String
     *     , "name": String
     *     , "mimeType": "text/plain"
     *     }
     * , contents : String
     * }    
     */
    function loadFile(id) {
        console.log("loading file with id", id);

        const metadataOptions =
            { "fileId" : id
            , "mimeType" : "text/plain" 
            , supportsTeamDrives : true
            }

        const contentOptions = 
            Object.assign({ alt : 'media' }, metadataOptions);

        getDriveClient().then(client => {
            client.files.get(contentOptions).then(setFileContents, handleFileError);
            client.files.get(metadataOptions).then(setMetadata, handleFileError);
        });

        let metadata = undefined, contentsHolder = undefined;

        function setMetadata(dataFromDrive) {
            metadata = dataFromDrive.result;
            document.title = metadata.name
            if (typeof contentsHolder !== 'undefined') {
                sendToElm();
            }
        }

        function setFileContents(bundle) {
            contentsHolder = bundle.body;
            if (typeof metadata !== 'undefined') {
                sendToElm();
            }
        }

        function sendToElm() {
            const message = 
                { type : 'FileLoaded'
                , metadata : metadata
                , contents : contentsHolder
                }    

            sendMessageToElm(message);
        }
    }

    /** 
     * 
     * Writes a file to drive and returns metadata
     *
     * to trigger
     * { type : 'WriteFile'
     * , metadata : Metadata
     * , contents : String
     * }
     * 
     * sends back metadata so elm will know about the id
     * { type : 'MetadataFromWrite'
     * , metadata : Metadata
     * }
     *
     */ 
    function writeFile(message) {

        // TODO check message fields
        const params = {
            uploadType: 'multipart',
            supportsTeamDrives: true,
            fields: DEFAULT_FIELDS
        };

        const metadata = 
            Object.assign(lastFileMetadata, { title : message.metadata.name, id : message.metadata.id }); 

        console.log(metadata);

        saveFile(metadata, message.contents);

        function saveFile(metadata, content) {
            var path;
            var method;

            if (metadata.id) {
                path = '/upload/drive/v2/files/' + encodeURIComponent(metadata.id);
                method = 'PUT';
            } else {
                path = '/upload/drive/v2/files';
                method = 'POST';
            }

            var multipart = new MultiPartBuilder()
                .append('application/json', JSON.stringify(metadata))
                .append(metadata.mimeType, content)
                .finish();

            var uploadRequest = getDriveClient().then(client => {
                client.request({
                    path: path,
                    method: method,
                    params: 
                        { uploadType: 'multipart'
                        , supportsTeamDrives: true
                        , fields: DEFAULT_FIELDS
                        },
                    headers: { 'Content-Type' : multipart.type },
                    body: multipart.body
                }).then(function(response) { 
                    const outgoingMessage =
                        { type : "SaveSuccessful"
                        , metadata : response.result
                        }
                    sendMessageToElm(outgoingMessage);
                });
            });
        };
    }

    function handleFileError(err) {
        console.log(err);
    }

    /**
     * Print files.
     *
     * to trigger:
     * { type : 'ListFiles'
     * }
     *
     * returns :
     * { type : 'FileList'
     * , files : List File
     * }
     *
     * where File is 
     * { id : String
     * , name : String
     * }
     *
     */
    function listFiles() {
        getDriveClient().then(client => {
            client.files.list({
                'pageSize': 100,
                'fields': "nextPageToken, files(id, name)",
                'q' : 'mimeType = "text/plain"'
            }).then(function(response) {
                console.log("Sending file list to elm.")

                // TODO handle bad responses probably
                var files = response.result.files;
                sendMessageToElm({
                    files : files,
                    type : 'FileList'
                });
            });
        });
    }

    handleClientLoad();
};


//////////////////////////////////////////////////////////////////////
//                     Local Storage Event Handler
//////////////////////////////////////////////////////////////////////



function wrapLocalStorageMessageHandler(sendMessageToElm) {
    const FILE_LIST_KEY = "__fileList"
    if (typeof sendMessageToElm !== 'function') {
        console.log("didn't receive a function in wrapLocalStorageMessageHandler", sendMessageToElm);
        return;
    } else {
        return localStorageToJavaScriptListener;
    }

    function localStorageToJavaScriptListener(message) {
        if (!window.localStorage) {
            throw "localStorage not enabled :("
        }


        switch (message.type) {
            case "WriteNewFile":
                var fileName = message.metadata.name;
                window.localStorage.setItem(fileName, JSON.stringify(message.contents));
                addFileToList(fileName);
                sendMessageToElm(
                        { type : "FileLoaded" 
                        , metadata : 
                            { name : fileName
                            , id : fileName
                            }
                        , contents : message.contents
                        })

                break;

            case "WriteFile":
                var fileName = message.metadata.name;
                window.localStorage.setItem(fileName, JSON.stringify(message.contents));
                addFileToList(fileName)
                sendMessageToElm(
                        { type : "FileLoaded" 
                        , metadata : 
                            { name : fileName
                            , id : fileName
                            }
                        , contents : message.contents
                        })
                break;

            case "WriteProperties":
                console.log("Saving properties.");
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
                    sendMessageToElm(message)
                }

                break;

            case "LoadFile":
                loadFile(message.id)
                break;

            case "GetFileList":

                const fileArray =
                    getFileList().map(file => ({ name : file, id : file }))

                const fileListMessage =
                    { type : "FileList"
                    , files : fileArray
                    }

                sendMessageToElm(fileListMessage)
                break;
        }

    }

    function loadFile(id) {
        console.log("loading file with id", id);

        const localStorageValue = window.localStorage.getItem(id);

        if (localStorageValue !== null) {
            const javascriptVersion = JSON.parse(localStorageValue);
            sendToElm(JSON.parse(localStorageValue));
        }

        function sendToElm(payload) {
            const message = 
                { type : 'FileLoaded'
                , metadata : 
                    { name : id
                    , id : id
                    } 
                , contents : payload
                }    

            sendMessageToElm(message);
        }
    }

    function getFileList() {
        const storageValue = window.localStorage.getItem(FILE_LIST_KEY);

        if (storageValue !== null) {
            return JSON.parse(storageValue);
        } else {
            return []
        }
    }


    // Expects new file data as a String signifying the name
    function addFileToList(newFileData) {
        // TODO come up with namespacing strategy
        const storageValue = window.localStorage.getItem(FILE_LIST_KEY);
        if (storageValue !== null) {
            var arrayVersion = JSON.parse(storageValue);
            if (arrayVersion.indexOf(newFileData) === -1) {
                arrayVersion.push(newFileData);
            }
            window.localStorage.setItem(FILE_LIST_KEY, JSON.stringify(arrayVersion));
        } else {
            window.localStorage.setItem(FILE_LIST_KEY, JSON.stringify([ newFileData ]));
        }

    }
}

//////////////////////////////////////////////////////////////////////
//                     MultiPartBuilder
//////////////////////////////////////////////////////////////////////



/**
 * Helper for building multipart requests for uploading to Drive.
 */
var MultiPartBuilder = function() {
    this.boundary = Math.random().toString(36).slice(2);
    this.mimeType = 'multipart/mixed; boundary="' + this.boundary + '"';
    this.parts = [];
    this.body = null;
};

/**
 * Appends a part.
 *
 * @param {String} mimeType Content type of this part
 * @param {Blob|File|String} content Body of this part
 */
MultiPartBuilder.prototype.append = function(mimeType, content) {
    if(this.body !== null) {
        throw new Error("Builder has already been finalized.");
    }
    this.parts.push(
            "\r\n--", this.boundary, "\r\n",
            "Content-Type: ", mimeType, "\r\n\r\n",
            content);
    return this;
};

/**
 * Finalizes building of the multipart request and returns a Blob containing
 * the request. Once finalized, appending additional parts will result in an
 * error.
 *
 * @returns {Object} Object containing the mime type (mimeType) & assembled multipart body (body)
 */
MultiPartBuilder.prototype.finish = function() {
    if (this.parts.length === 0) {
        throw new Error("No parts have been added.");
    }
    if (this.body === null) {
        this.parts.push("\r\n--", this.boundary, "--");
        this.body = this.parts.join('');
        // TODO - switch to blob once gapi.client.request allows it
        // this.body = new Blob(this.parts, {type: this.mimeType});
    }
    return {
        type: this.mimeType,
        body: this.body
    };
};
