/+  *server, default-agent, *green-room, dbug
::
|%
+$  card  card:agent:gall
--
%-  agent:dbug
=*  state  -
^-  agent:gall
=<
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    hc    ~(. +> bowl)
::
++  on-init
  ^-  (quip card _this)
  :_  this
  ~[green-card:hc]
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
:: Helper Core
|_  =bowl:gall
::
++  green-card
  =/  catch  [%cord '/apps/groups/desk.js']
  =/  hatch  [%before "."]
  =/  patch
    =-  [%patch -]
    =-  !>([/groups/green-room/gallery -])
    [/apps/groups catch hatch green-room-thatch]
  [%pass /monkey/patch/green-room %agent [our.bowl %monkey] %poke patch]
--
