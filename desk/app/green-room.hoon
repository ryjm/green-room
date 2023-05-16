/+  *server, default-agent, *green-room
::
|%
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-latest
=*  state  -
^-  agent:gall
=<
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    hc    ~(. +> bowl)
++  on-init  on-init
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?:  ?=([%http-response *] path)
    `this
  ?.  =(/ path)
    (on-watch:def path)
  [[%give %fact ~ %json !>(*json)]~ this]
::
++  on-agent  on-agent:def
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?.  ?=(%bound +<.sign-arvo)
    (on-arvo:def wire sign-arvo)
  [~ this]
::
++  on-poke  on-poke:def
++  on-save  on-save:def
++  on-load  on-load:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-fail   on-fail:def
--
::
++  on-arvo  on-arvo:def
++  on-fail  on-fail:def
--
::
:: Helper Core
|_  =bowl:gall
::
++  ug-handler-card
  =/  ug-vase  !>([/astrolabe '/apps/green-room/#'])
  [%pass /monkey-ug %agent [our.bowl %monkey] %poke [%bind-ug ug-vase]]
::
++  groups-link-patch-card
  =/  catch  [%cord '/apps/groups/desk.js']
  =/  hatch  [%before "."]
  =/  patch  [/apps/groups catch hatch groups-link-thatch]
  =/  patch-kit-vase  !>([/groups/green-room/link patch])
  [%pass /monkey/patch/groups/link %agent [our.bowl %monkey] %poke [%patch patch-kit-vase]]
::
++  talk-link-patch-card
  =/  catch  [%cord '/apps/talk/desk.js']
  =/  hatch  [%before "."]
  =/  patch  [/apps/talk catch hatch groups-link-thatch]
  =/  patch-kit-vase  !>([/talk/astrolabe/link patch])
  [%pass /monkey/patch/talk/link %agent [our.bowl %monkey] %poke [%patch patch-kit-vase]]
::
--
