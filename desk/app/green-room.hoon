/-  *green-room, h=heap
/+  server, default-agent, *green-room, dbug, verb
::
^-  agent:gall
=>
  |%
  +$  card  card:agent:gall
  +$  current-state
    $:  %0
       =tracked
    ==
  --
=|  current-state
=*  state  -
=<
  %+  verb  |
  %-  agent:dbug
  |_  =bowl:gall
  +*  this  .
      def   ~(. (default-agent this %|) bowl)
      cor   ~(. +> [bowl ~])
  ++  on-init
    ^-  (quip card _this)
    =^  cards  state
      abet:init:cor
    [cards this]
  ::
  ++  on-save  !>(state)
  ++  on-load
    |=  =vase
    ^-  (quip card _this)
    =^  cards  state
      abet:(load:cor vase)
    [cards this]
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card _this)
    =^  cards  state
      abet:(poke:cor mark vase)
    [cards this]
  ::
  ++  on-watch
    |=  =path
    ^-  (quip card _this)
    =^  cards  state
      abet:(watch:cor path)
    [cards this]
  ::
  ++  on-peek   peek:cor
  ::
  ++  on-leave   on-leave:def
  ++  on-fail    on-fail:def
  ::
  ++  on-agent
    |=  [=wire =sign:agent:gall]
    ^-  (quip card _this)
    =^  cards  state
      abet:(agent:cor wire sign)
    [cards this]
  ++  on-arvo
    |=  [=wire sign=sign-arvo]
    ^-  (quip card _this)
    =^  cards  state
      abet:(arvo:cor wire sign)
    [cards this]
  --
|_  [=bowl:gall cards=(list card)]
++  abet  [(flop cards) state]
++  cor   .
++  emit  |=(=card cor(cards [card cards]))
++  emil  |=(caz=(list card) cor(cards (welp (flop caz) cards)))
++  give  |=(=gift:agent:gall (emit %give gift))
++  init
  ^+  cor
  pass-monkey
::
::
++  channel-scry
  |=  app=@tas
  ^-  path
  /(scot %p our.bowl)/[app]/(scot %da now.bowl)
::
++  scry
  |=  [care=@tas =dude:gall =path]
  ^+  path
  :*  care
      (scot %p our.bowl)
      dude
      (scot %da now.bowl)
      path
  ==
::
++  flatten
  |=  content=(list inline:h)
  ^-  cord
  %-  crip
  %-  zing
  %+  turn
    content
  |=  c=inline:h
  ?@  c  (trip c)
  ?-  -.c
      ?(%break %block)  ""
      %tag    (trip p.c)
      %link   (trip q.c)
      ?(%code %inline-code)  ""
      %ship                  (scow %p p.c)
      ?(%italics %bold %strike %blockquote)  (trip (flatten p.c))
  ==
++  watch-room
  ^+  cor
  (emit %pass /green-room %agent [our.bowl %green-room] %watch /green-room)
::
++  pass-monkey
  ^+  cor
  =/  catch  [%cord '/apps/groups/desk.js']
  =/  hatch  [%before "."]
  =/  patch
    =-  [%patch -]
    =-  !>([/groups/green-room/gallery -])
    [/apps/groups catch hatch green-room-thatch]
  (emit %pass /monkey/patch/green-room %agent [our.bowl %monkey] %poke patch)
::
++  mar
  |%
  ++  act  `mark`%green-room-action
  ++  upd  `mark`%green-room-update
  --
::
++  poke
  |=  [=mark =vase]
  ^+  cor
  ?+    mark  ~|(bad-poke/mark !!)
  ::
      %green-room-action
    =+  !<(=action vase)
    =/  track-core  (tr-abed:tr-core [p.action chan.p.q.action])
    =<  tr-abet
    (tr-update:track-core q.action)
    ::  %.  q.action
    ::  tr-update:(tr-abed:tr-core track)
 ==
::
++  load
  |=  =vase
  ^+  cor
  |^  ^+  cor
  =/  maybe-old  (mule |.(!<(versioned-state vase)))
  =/  old=versioned-state
    ?:  ?=(%| -.maybe-old)
      *current-state
    p.maybe-old
  =.  state  old
  pass-monkey
  ::
  +$  versioned-state  $%(current-state)
  --
::
++  watch
  |=  =(pole knot)
  ^+  cor
  ?+    pole  ~|(bad-watch-path/pole !!)
      [%green-room ~]  ?>(from-self cor)
      [%ui ~]      ?>(from-self cor)
  ==
::
++  agent
  |=  [=(pole knot) =sign:agent:gall]
  ^+  cor
  cor
::
++  arvo
  |=  [=wire sign=sign-arvo]
  ^+  cor
  ~&  arvo/wire
  cor
::
++  peek
  |=  =path
  ^-  (unit (unit cage))
  ?+  path  [~ ~]
  ::
    [%x %tracked ~]  ``noun+!>(tracked)
  ==
::
++  from-self  =(our src):bowl
::
::  TODO: make this a real thing
++  make-heart
  |=  =heart:h
  ^-  =heart:h
  heart
::
++  tr-core
  |_  [=track =thing =things gone=_|]
  ++  tr-core  .
  ++  tr-abet
    %_  cor
        tracked
      ?:  gone
        (~(del by tracked) track)
      (~(put ju tracked) track thing)
    ==
  ++  tr-abed
    |=  t=^track
    %_  tr-core
      track  t
      things  (fall (~(get by tracked) t) ~)
    ==
  ::
  ++  tr-pass  !!
  ::
  ++  tr-scry
    %+  welp
      (channel-scry %heap)
    /heap/(scot %p p.group.track)/[q.chan.thing]
  ::
  ++  tr-update
    |=  =update
    ^+  tr-core
    =/  diff  q.update
    =.  thing  p.update
    ?-    -.diff
        %save
      =+  .^  [=seal:h =heart:h]  %gx
            %+  welp
              tr-scry
            /curios/curio/id/(scot %ud id.thing)/noun
          ==
      ?:  &(!copy.diff !=(our.bowl author.heart))
        ~|(not-the-author/author.heart !!)
      =/  count  (lent ~(tap in things))
      =/  log=content:h  :-  ~
        :~
          [%inline-code (crip "[%green-room]: edit {<count>} | ")]
          ?~  link=q.content.heart
            'unknown'
          ?:  ?=(%link -.i.link)
            i.link(q '(original)')
          i.link
        ==
      =/  edit=heart:h
        =+  title=(fall title.heart '')
        %_    heart
            title  title.heart
            content  [~ [[%link (need content.thing) title] ~]]
            author  our.bowl
            sent  now.bowl
        ==
      =?  thing  copy.diff  thing(id `@ud`now.bowl, time now.bowl)
      =.  cor
        ?:  copy.diff
          =+  [chan.thing now.bowl %curios time.thing %add edit]
          %-  emit
          [%pass /green-room/update %agent [our.bowl %heap] %poke %heap-action !>(-)]
        =-  %-  emil
          :~
              [%pass /green-room/edit %agent [our.bowl %heap] %poke %heap-action !>(q:-)]
              [%pass /green-room/reply %agent [our.bowl %heap] %poke %heap-action !>(p:-)]
          ==
        =-  [p=[chan.thing now.bowl %curios time.seal %add new] q=act:-]
        =-  :_  act=`action:h`-
            new=%_(edit replying `time.seal, content log, title ~, sent now.bowl)
        =-  [chan.thing -]
        =-  [now.bowl %curios -]
        [time.seal %edit edit]
      tr-core
        %restore
      tr-core
    ==
  --
--
