|%
::
++  green-room-thatch
  |^
    %-  crip
    """

    if (!window.fileUploader) \{
      const dummyState = \{
        uploadFiles: function() \{
          console.log("uploadFiles not found");
        },
        createClient: function() \{
          console.log("createClient not found");
        },
        getMostRecent: function() \{
          console.log("getMostRecent not found");
        },
        clear: function() \{
          console.log("clear not found");
        },
        uploaders: \{},

      };

      window.fileUploader = () => dummyState;
    }
    if (!window.fileStore) \{
      console.log("fileStore not found");
      const dummyState = \{
        s3: \{
          credentials: '',
          configuration: \{
            currentBucket: '',
            region: '',
          },
        },
      };

      window.fileStore = () => dummyState;
    }
    if (!window.emptyUploader) \{
      console.log("emptyUploader not found");
      const dummyState = \{};

      window.emptyUploader = () => dummyState;
    }
    {css}
    {global:vars}
    {functions}
    Promise.all(loadScripts({global:scripts}))
      .then(() => \{ {main} });
    """
  ::
  ++  main
    """
    setInterval(() => \{
      updateCurio(key, path);
      path = location.pathname;
      isCurio = path.split('/').includes('curio')

      if (!isCurio) return;

      if ($('.green-room-button').length === 1) return;

      if (buttonAdded) return;
      {button}
    }, 1000);
    """
  ::
  ++  button
    """
      const buttons = document.querySelectorAll('div > div > div > div > header > div > div > button.small-button');
      const images = document.querySelectorAll('div > div > div > div > main > div > div.group.relative.flex.flex-1 > div > img');
      const editButton = Array.from(buttons).find(button => button.innerHTML === 'Edit');
      if (!editButton || (images.length === 0)) return;
      const linkElement = document.createElement('link');
      linkElement.rel = 'stylesheet';
      linkElement.href = 'https://uicdn.toast.com/tui-image-editor/latest/tui-image-editor.css';
      document.head.appendChild(linkElement);
      {add-button}
      const imageContainer = images[0].parentElement;
      {modal-container}
      const editorContainer = document.createElement('div');

      editorContainer.className = 'editor-container';
    """
  ++  observer
    """
    const observer = new MutationObserver(function(mutations) \{
      if !(buttonAdded) \{
        {add-button}
      }
    });
    """
  ++  add-button
    """
    let buttonContainer = editButton.parentElement;
    if (buttonContainer.nextSibling) return;
    let c = buttonContainer.parentElement;
    let greenButton = document.createElement('button');
    greenButton.innerHTML = 'Green Room';
    greenButton.className = 'green-room-button small-button';

    greenButton.onclick = () => \{
      {editor}
    };

    greenButton.target = '_blank';
    greenButton.style.backgroundColor = "green";
    buttonContainer.insertBefore(greenButton, editButton);
    greenButton.style.color = "white";
    """
  ++  modal-container
    """
    const modalContainer = document.createElement('div');
    document.addEventListener('click', (event) => \{
      const ec = document.querySelector('.editor-container');
      if (!ec) return;
      const isClickInsideEditor = ec.contains(event.target);
      if (!isClickInsideEditor) \{
        modalContainer.remove();
      }
    });
    """
  ::
  ++  editor
    |^
      """
      Promise.all(loadScripts({editor:scripts}))
        .then(() => \{
          {image-editor}
        });
      """
    ::
    ++  image-editor
      """
      const imageEditor =
        new tui.ImageEditor(editorContainer, {config});

      window.onresize = function () \{
          imageEditor.ui.resizeEditor();
      };

      {funs}
      {elems}

      addImageForEditing(images[0].src);

      {interact}
      """
    ++  funs
      """
      function addImageForEditing(imageUrl) \{
        imageEditor.loadImageFromURL(imageUrl, 'imageName')
          .then(() => imageEditor.clearUndoStack());
      }

      function saveImage() \{
        console.log("saving image");
        dataUrl = imageEditor.toDataURL();
        const byteString = atob(dataUrl.split(',')[1]);
        const mimeType = dataUrl.split(',')[0].split(':')[1].split(';')[0];
        const buffer = new Uint8Array(byteString.length);

        for (let i = 0; i < byteString.length; i++) \{
          buffer[i] = byteString.charCodeAt(i);
        }

        const blob = new Blob([buffer], \{ type: mimeType });
        upload(blob);
        modalContainer.remove();
      }
      """
    ++  config
      """
      \{
        includeUI: \{
            loadImage: \{
                path: images[0].src,
                name: 'SampleImage',
            },
            theme: blackTheme, // or whiteTheme
            initMenu: 'filter',
            menuBarPosition: 'bottom',
        },
        cssMaxWidth: 700,
        cssMaxHeight: 500,
        usageStatistics: false
      }
      """
    ++  elems
      """
      modalContainer.className = 'modal';
      editorContainer.style.width = '80%';
      editorContainer.style.height = '80%';
      modalContainer.appendChild(editorContainer);
      document.body.appendChild(modalContainer);
      const saveButton = $('.tui-image-editor-header-buttons .tui-image-editor-download-btn')
      const newButton = $('<button>', \{
          class: 'tui-image-editor-download-btn',
          text: 'Save',
          click: saveImage,
      });
      saveButton.replaceWith(newButton);
      """
    ++  interact
      """
      interact(editorContainer)
        .resizable(\{
          edges: \{ left: true, right: true, bottom: true, top: true },
          endOnly: true,
          modifiers: [
            interact.modifiers.aspectRatio(\{
              ratio: 'preserve',
            }),
          ],
          inertia: true,
        })
        .on('resizemove', (event) => \{
          const target = event.target;

          target.style.width = event.rect.width + 'px';
          target.style.height = event.rect.height + 'px';
        });
      """
    --
  --
::
++  functions
  |^
     """
     {init}
     {upload}
     {update-curio}
     """
  ::
  ++  init
    """
    function loadScripts(urls) \{
      return urls.map(loadScript);
    }

    function loadScript(src) \{
      return new Promise((resolve) => \{
          const script = document.createElement('script');
          script.src = src;
          script.onload = () => \{
            resolve();
          };
          document.head.appendChild(script);
      });
    }
    """
  ::
  ++  upload
    """
    function upload(blob) \{
      const file = new File([blob], "sample.png", \{type: blob.type})
      const \{
        s3 : \{ credentials, configuration }
      } = fileStore()

      const files = [file];
      files.length = 1;
      files.item = function(index) \{
        return index >= 0 && index < this.length ? this[index] : null;
      };
      const currentBucket = configuration.currentBucket;
      fileUploader().createClient(fileStore().s3.credentials, 'us-east-1')
      fileUploader().uploaders[key] = emptyUploader();
      fileUploader().uploadFiles(key, files, currentBucket)
      console.log("uploaded file, closing modal");
    }
    """
  ::
  ++  update-curio
    """
    function updateCurio(key, path) \{
      const lastUpload = fileUploader().getMostRecent(key);
      if (lastUpload?.status === "success") \{
        const s = path.split('/');
        const pathElements = s.slice(s.indexOf('heap') + 1);
        const flag = pathElements.slice(0, 2).join('/');
        const time = pathElements[pathElements.length - 1];
        const sent = UrbitAPI.daToUnix(bigInt(time));
        const heart = \{
          title: null,
          content: \{ block: [], inline: [\{link: \{href: lastUpload.url, content: lastUpload.url}}]},
          author: UrbitAPI.preSig(window.ship),
          sent: sent,
          replying: null
        };

        heap().editCurio(flag, time, heart);
        fileUploader().clear(key);
     };
    }
    """
  --
::
++  vars
  |%
  ::
  ++  global
    """
    // editor button added
    var buttonAdded = false;
    // heap path
    var path = undefined;
    // key for file uploader (fileUploader().uploaders[key])
    const key = 'green-room-input';
    """
  --
::
++  scripts
  |%
  ++  global
    """
    [
      'https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js',
      'https://cdn.jsdelivr.net/npm/@urbit/api@2.3.0/dist/urbit-api.min.js',
      'https://cdnjs.cloudflare.com/ajax/libs/big-integer/1.6.51/BigInteger.min.js'
    ]
    """
  ::
  ++  editor
    """
    [
      'https://cdnjs.cloudflare.com/ajax/libs/fabric.js/4.4.0/fabric.js',
      'https://uicdn.toast.com/tui.code-snippet/latest/tui-code-snippet.js',
      'https://uicdn.toast.com/tui-color-picker/latest/tui-color-picker.js',
      'https://uicdn.toast.com/tui-image-editor/latest/tui-image-editor.js',
      'https://cdn.jsdelivr.net/npm/interactjs/dist/interact.min.js',
    ]
    """
  --
::
++  css
  |^
    """
    {modal}
    {black-theme}
    """
  ::
  ++  modal
    """
    const modal = document.createElement('style');

    modal.textContent = `
      .editor-container \{
          height: 80%;
          width: 80%;
          padding: 10px;
          z-index: 999999;
      }
    @keyframes pulse \{
      0% \{
        transform: scale(1);
      }
      50% \{
        transform: scale(1.1);
      }
      100% \{
        transform: scale(1);
      }
    }

    .green-room-button:hover \{
      animation: pulse 2s linear infinite;
    }
      .tui-image-editor-container .tui-image-editor-header-logo \{
          display: none;
      }
      .tui-image-editor-container .tui-image-editor-header-buttons \{
          float: right;
          margin: 8px;
      }
      .tui-image-editor-container .tui-image-editor-header-buttons div \{

          width: 50px !important;
          border-radius: 0 !important;
          margin-right: 10px;
          border-color: black !important;
      }
      .tui-image-editor-help-menu \{
          border-radius: 0 !important;
          background-color: #151515 !important;
          color: white !important;
      }
      .tui-image-editor-container .tui-image-editor-download-btn \{

          width: 50px !important;

          background-color: #345764 !important;
          border-color: black !important;
          color: white !important;
          border-radius: 0 !important;
      }
      .tui-image-editor-container .tui-image-editor-load-btn \{
          width: 50px !important;
      }
      .tui-image-editor-container \{
          width: inherit;
          height: inherit;
      }
      .modal \{
          position: fixed;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          z-index: 999998;
          background-color: rgba(0, 0, 0, 0.8);
          display: flex;
          justify-content: center;
          align-items: center;
    }`;
    document.head.appendChild(modal);
    """
  ::
  ++  black-theme
    """
    var blackTheme = \{
    'common.bi.image': 'https://uicdn.toast.com/toastui/img/tui-image-editor-bi.png',
    'common.bisize.width': '251px',
    'common.bisize.height': '21px',
    'common.backgroundImage': 'none',
    'common.backgroundColor': '#1e1e1e',
    'common.border': '0px',

    // header
    'header.backgroundImage': 'none',
    'header.backgroundColor': 'transparent',
    'header.border': '0px',

    // main icons
    'menu.normalIcon.color': '#8a8a8a',
    'menu.activeIcon.color': '#555555',
    'menu.disabledIcon.color': '#434343',
    'menu.hoverIcon.color': '#e9e9e9',
    'menu.iconSize.width': '24px',
    'menu.iconSize.height': '24px',

    // submenu icons
    'submenu.normalIcon.color': '#8a8a8a',
    'submenu.activeIcon.color': '#e9e9e9',
    'submenu.iconSize.width': '32px',
    'submenu.iconSize.height': '32px',

    // submenu primary color
    'submenu.backgroundColor': '#1e1e1e',
    'submenu.partition.color': '#3c3c3c',

    // submenu labels
    'submenu.normalLabel.color': '#8a8a8a',
    'submenu.normalLabel.fontWeight': 'lighter',
    'submenu.activeLabel.color': '#fff',
    'submenu.activeLabel.fontWeight': 'lighter',

    // checkbox style
    'checkbox.border': '0px',
    'checkbox.backgroundColor': '#fff',

    // range style
    'range.pointer.color': '#fff',
    'range.bar.color': '#666',
    'range.subbar.color': '#d1d1d1',

    'range.disabledPointer.color': '#414141',
    'range.disabledBar.color': '#282828',
    'range.disabledSubbar.color': '#414141',

    'range.value.color': '#fff',
    'range.value.fontWeight': 'lighter',
    'range.value.fontSize': '11px',
    'range.value.border': '1px solid #353535',
    'range.value.backgroundColor': '#151515',
    'range.title.color': '#fff',
    'range.title.fontWeight': 'lighter',

    // colorpicker style
    'colorpicker.button.border': '1px solid #1e1e1e',
    'colorpicker.title.color': '#fff',
    };
    """
  --
--
