
  // Client ID and API key from the Developer Console
  var CLIENT_ID = '839363603519-kb1olgtasm8i92e49gduihh12e0328pt.apps.googleusercontent.com';
  var API_KEY = 'AIzaSyBTQf0HmLUFr8V6NSls5eWRPKC79bmB2t8';
  var DEFAULT_FIELDS = 'id,title,mimeType,userPermission,editable,copyable,shared,fileSize';

  // Array of API discovery doc URLs for APIs used by the quickstart
  var DISCOVERY_DOCS = ["https://www.googleapis.com/discovery/v1/apis/drive/v3/rest"];

  // Authorization scopes required by the API; multiple scopes can be
  // included, separated by spaces.
  var SCOPES = 'https://www.googleapis.com/auth/drive';

  var authorizeButton = document.getElementById('authorize-button');
  var signoutButton = document.getElementById('signout-button');

  var lastFileMetadata =
    {
     "kind": "drive#file",
     "mimeType": "text/plain"
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
      authorizeButton.onclick = handleAuthClick;
      signoutButton.onclick = handleSignoutClick;
    });
  }

  /**
   *  Called when the signed in status changes, to update the UI
   *  appropriately. After a sign-in, the API is called.
   */
  function updateSigninStatus(isSignedIn) {
    if (isSignedIn) {
      authorizeButton.style.display = 'none';
      signoutButton.style.display = 'block';
      listFiles();
    } else {
      authorizeButton.style.display = 'block';
      signoutButton.style.display = 'none';
    }
  }

  /**
   *  Sign in the user upon button click.
   */
  function handleAuthClick(event) {
    gapi.auth2.getAuthInstance().signIn();
  }

  /**
   *  Sign out the user upon button click.
   */
  function handleSignoutClick(event) {
    gapi.auth2.getAuthInstance().signOut();
  }

  /**
   * Append a pre element to the body containing the given message
   * as its text node. Used to display the results of the API call.
   *
   * @param {string} message Text to be placed in pre element.
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

  function loadFile(id) {
      console.log("loading file with id", id);

      const metadataOptions =
          { "fileId" : id
          , "mimeType" : "text/plain" 
          , supportsTeamDrives : true
          }
 
      const contentOptions = 
          Object.assign({ alt : 'media' }, metadataOptions);

      gapi.client.drive.files.get(contentOptions).then(setFileContents, handleFileError);
      gapi.client.drive.files.get(metadataOptions).then(setTitle, handleFileError);
  }

  function setTitle(bundle) {
     lastFileMetadata = bundle.result;
     console.log(bundle.result.name);
     const titleHolder = document.getElementById("filename");
     titleHolder.innerHTML = "";
     titleHolder.appendChild(document.createTextNode(bundle.result.name))
  }

  function setFileContents(bundle) {
     console.log(bundle.body);
     const contentsHolder = document.getElementById("filecontents");
     contentsHolder.innerHTML = "";
     contentsHolder.appendChild(document.createTextNode(bundle.body));
  }

  function writeFile() {
     const contentsHolder = document.getElementById("filecontents");
     const titleHolder = document.getElementById("filename");
     
     console.log("New title", titleHolder.innerHTML)
     console.log("New body", contentsHolder.innerHTML)
     const params ={
          uploadType: 'multipart',
          supportsTeamDrives: true,
          fields: DEFAULT_FIELDS
     };

     const metadata = 
         Object.assign(lastFileMetadata, { title : titleHolder.innerHTML }); 

     saveFile(metadata, contentsHolder.innerHTML);

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

          var uploadRequest = gapi.client.request({
            path: path,
            method: method,
            params: {
              uploadType: 'multipart',
              supportsTeamDrives: true,
              fields: DEFAULT_FIELDS
            },
            headers: { 'Content-Type' : multipart.type },
            body: multipart.body
          }).then(function(a) { console.log(a); });
      };
  }

  function handleFileError(err) {
      console.log(err);
  }

  /**
   * Print files.
   */
  function listFiles() {
    gapi.client.drive.files.list({
      'pageSize': 10,
      'fields': "nextPageToken, files(id, name)",
      'q' : 'mimeType = "text/plain"'
    }).then(function(response) {
      var files = response.result.files;
      if (files && files.length > 0) {
        for (var i = 0; i < files.length; i++) {
          var file = files[i];
          appendPre(file.id, file.name);
        }
      } else {
        appendPre('1', 'No files found.');
      }
    });
  }


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
