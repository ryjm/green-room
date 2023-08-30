|%
::
++  green-room-thatch
  |^
    %-  crip
    """
    {css}
    {global:vars}
    {functions}
    {sliders}
    Promise.all(loadScripts({global:scripts}))
      .then(() => \{ loadCss() })
      .then(() => \{ {main} });
    """
  ::
  ++  main
    """

    setTimeout(() => \{
      isCurio = location.pathname.split('/').includes('curio')
      }, 1000);
    setInterval(() => \{
      if (!isCurio) return;
      if (typeof fileUploader !== 'undefined') \{
        updateCurio(key);
      }
      if ($('.green-room-button').length === 1) return;
      if (buttonAdded) return;
      $(document).ready(() => \{
        {button}
      });
    }, 1000);
    """
  ::
  ++  sliders
    """
    function setUpHtml5Sliders() \{

      const rangeControls = [
        window.imageEditor.ui.rotate._els.rotateRange,
        window.imageEditor.ui.draw  ._els.drawRange,
        window.imageEditor.ui.shape ._els.strokeRange,
        window.imageEditor.ui.text  ._els.textRange,
      ];

      const filterControls = [
        window.imageEditor.ui.filter._els.brightnessRange,
        window.imageEditor.ui.filter._els.blurRange,
        window.imageEditor.ui.filter._els.pixelateRange,
        window.imageEditor.ui.filter._els.noiseRange,
        window.imageEditor.ui.filter._els.colorFilterThresholdRange,
        window.imageEditor.ui.filter._els.removewhiteDistanceRange,
        window.imageEditor.ui.filter._els.tintOpacity,
      ];
      rangeControls.forEach( convertTuiRangeToHtml5Range );
      filterControls.forEach( (range) => (range === undefined) ? range : range.rangeWidth = 100 );
    }

    function convertTuiRangeToHtml5Range( tuiRange ) \{
      const divWrapper = tuiRange.rangeElement;
      correctRangeLabelText( divWrapper );

      const textBoxInput = tuiRange.rangeInputElement;

      const rangeInput = document.createElement( 'input' );
      rangeInput.type          = 'range';
      if( rangeInput.type !== 'range' ) return;

      rangeInput.min           = tuiRange._min.toString();
      rangeInput.max           = tuiRange._max.toString();
      rangeInput.style.width   = '100%';
      rangeInput.style.display = 'inline-block';

      copyInputNumberValue(  textBoxInput, rangeInput );

      divWrapper.appendChild( rangeInput );

      rangeInput.addEventListener( 'input', function( ev ) \{

        const inp = ev.currentTarget;

        textBoxInput.value = inp.value;
        textBoxInput.dispatchEvent( new Event( 'blur' ) );
      } );

      textBoxInput.addEventListener( 'input', function( ev ) \{

        copyInputNumberValue( textBoxInput, rangeInput );
      } );

      textBoxInput.type = 'number';
      textBoxInput.min  = rangeInput.min;
      textBoxInput.max  = rangeInput.max;

      divWrapper.querySelector( 'div.tui-image-editor-virtual-range-bar' ).style.visibility = 'hidden';
    }

    function correctRangeLabelText( divWrapper ) \{
      if( divWrapper.classList.contains( 'tie-rotate-range' ) ) \{
        const label = divWrapper.parentElement.querySelector( 'label.range' );
        if( label.textContent.trim() === "Range" ) \{
          label.textContent = "Rotation angle";
        }
      }
      else if( divWrapper.classList.contains( 'tie-draw-range' ) ) \{
        const label = divWrapper.parentElement.querySelector( 'label.range' );
        if( label.textContent.trim() === "Range" ) \{
          label.textContent = "Brush size";
        }
      }
    }

    function copyInputNumberValue( src, dest ) \{
      if( !src ) return;
      const valueNum = parseInt( src.value, /*radix:*/ 10 );
      if( isNaN( valueNum ) ) \{
        dest.valueAsNumber = parseInt( dest.min );
      }
      else \{
        dest.valueAsNumber = valueNum;
      }
    }
    """
  ::
  ++  button
    """
      const buttons = document.querySelectorAll('div > div > div > div > header > div > div > button.small-button');
      const images = document.querySelectorAll('div > div > div > div > main > div > div.group.relative.flex.flex-1 > div > img');
      const editButton = Array.from(buttons).find(button => button.innerHTML === 'Edit');
      if (!editButton || (images.length === 0)) return;
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
    let isResizing = false;

    document.addEventListener('click', (event) => \{
      const ec = document.querySelector('.editor-container');
      if (!ec) return;
      const isClickInsideEditor = ec.contains(event.target);
      const isSliderHandle = $(event.target).closest('.tui-image-editor-range-wrap').length !== 0;
        if (!isSliderHandle && !isClickInsideEditor && !isResizing) \{
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

      window.imageEditor = imageEditor;
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
          .then(result => \{
            console.log(result);
          })
      }
      function saveImage(copy) \{
        window.copy = copy || false;
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
                name: 'image',
            },
            initMenu: 'draw',
            menuBarPosition: 'bottom',
        },
        cssMaxWidth: 700,
        cssMaxHeight: 500,
        selectionStyle: \{
            cornerSize: 20,
            rotatingPointOffset: 70,
        },
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
      const buttonContainer = saveButton.parent();
      const newButton = $('<button>', \{
          class: 'tui-image-editor-download-btn',
          text: 'Save',
          click: ()   =>  saveImage(false),
      })  ;
      const copyButton = $('<button>', \{
          class: 'tui-image-editor-download-btn',
          text: 'Copy',
          click: () => saveImage(true)
      });
      saveButton.replaceWith(newButton);
      buttonContainer.append(copyButton);

      setUpHtml5Sliders();
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
        .on('resizestart', () => \{
          isResizing = true;
        })
        .on('resizeend', () => \{
          isResizing = false;
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
     {poke}
     """
  ++  poke
    """
    function pokeGreenRoom(data) \{
      const ship = window.ship;
      const app = 'green-room';
      const mark = 'green-room-action';

      urb.poke(\{app: app, mark: mark, json: data, ship: ship});
    }
    """
  ::
  ++  init
    """
    function loadScripts(urls) \{
      return urls.map(loadScript);
    }

    function loadCss() \{
      return new Promise((resolve) => \{
          const linkElement = document.createElement('link');
          linkElement.rel = 'stylesheet';
          linkElement.href = 'https://uicdn.toast.com/tui-image-editor/latest/tui-image-editor.css';
          linkElement.onload = () => \{
            resolve();
          };
          document.head.appendChild(linkElement);
      });
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
      // warehouse should be defined
      if (!warehouse || !emptyUploader) \{
        console.log("warehouse not defined");
        return;
      }
      const file = new File([blob], "sample.png", \{type: blob.type})
      const \{
        s3 : \{ credentials, configuration }
      } = warehouse()

      const files = [file];
      files.length = 1;
      files.item = function(index) \{
        return index >= 0 && index < this.length ? this[index] : null;
      };
      const currentBucket = configuration.currentBucket;
      fileUploader().createClient(warehouse().s3.credentials, 'us-east-1')
      fileUploader().uploaders[key] = emptyUploader();
      fileUploader().uploadFiles(key, files, currentBucket)
      console.log("uploaded file, closing modal");
    }
    """
  ::
  ++  update-curio
    """
    function updateCurio(key) \{
      const lastUpload = fileUploader().getMostRecent(key);
      if (lastUpload?.status === "success") \{
        const s = location.pathname.split('/');
        const groupIdx = s.indexOf('groups') + 2;
        const group = s.slice(groupIdx, groupIdx + 2).join('/');
        const pathElements = s.slice(s.indexOf('heap') + 1);
        const chan = pathElements.slice(0, 2).join('/');
        const time = pathElements[pathElements.length - 1];
        console.log("update curio");
        const data = \{
            group: group,
            update:\{
              thing: \{
                chan: chan,
                content: lastUpload.url,
                id: UrbitAPI.decToUd(time),
                time: time
              },
            diff: \{
              save: copy || false,
            }
           }
        };
        fileUploader().clear(key);
        pokeGreenRoom(data);
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
    // key for file uploader (fileUploader().uploaders[key])
    const key = 'green-room-input';
    // urbit api
    loadScript('https://cdn.jsdelivr.net/npm/@urbit/http-api/dist/urbit-http-api.min.js')
      .then(() => \{
        window.urb = new UrbitHttpApi.Urbit('', '', window.desk);
      });
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
    @keyframes pulse-button \{
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
      animation: pulse-button 2s linear infinite;
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
