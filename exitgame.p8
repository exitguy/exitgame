pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
 player={
  x=70,    -- x-axis
  y=112,   -- y-axis
  f=false, -- flip
  h=100,   -- health
  p=0      -- points
 }
 exitguy=1
 stimer=0
 gravity=2
 jforce=0
 state="play"
end

function _update()
  if (state=="gameover" or state=="theend") and btn(❎) then
    state="play"
    _init()
    reload(0x1000, 0x1000, 0x2000)
  end 
  dground(player)
  move(player)
  pickups(player)
  if player.h<=0 then
    state="gameover"
  end
end

function _draw()
 if state=="play" then
  cls(1)
  map()
  spr(exitguy,player.x,player.y,1,1,player.f)
  camera((player.x - 40),0)
  print("health: "..player.h,player.x - 30, 10)
  print("points: "..player.p,player.x - 30, 16)
 elseif state=="gameover" then
  cls(0)
  camera(0,0)
  print("game over!",32,32)
  print("your score: "..player.p,32,40)
  print("press ❎ to restart",32,64)
 elseif state=="theend" then
  cls(2)
  camera(0,0)
  print("you've reached the exit!",32,32)
  print("your score: "..player.p,32,40)
  print("press ❎ to play again!",32,64)
 end
end
-->8

-->8
-- collision detection --
function collide(o)

 -- find all corners of our player
 local x1=o.x/8     -- left on the x-axis
 local y1=o.y/8     -- top on the y-axis
 local y2=(o.y+7)/8 -- bottom on the y-axis
 local x2=(o.x+7)/8 -- right on the x-axis
 local x3=(o.x+3)/8 -- center on the x-axis
 
 local a=fget(mget(x1,y1),0) -- top left
 local b=fget(mget(x1,y2),0) -- bottom left
 local c=fget(mget(x2,y2),0) -- bottom right
 local d=fget(mget(x2,y1),0) -- top right
 local e=fget(mget(x3,y1),0) -- top center

 if t == "top" then
   return e
 elseif a or b or c or d then
  return true
 else
  return false
 end
end

-- is our player on a surface with flag 0?
function onground(o)
 local a = fget(mget((o.x)/8,(o.y+9)/8),0)
 local b = fget(mget((o.x+8)/8,(o.y+9)/8),0)
 if a or b then
  return true
 else
  return false
 end
end

-- is our player on deadly grounds?
function dground(o)
 local a = fget(mget((o.x+4)/8,(o.y+9)/8),1)
 if a then
   o.h-=2
   sfx(3)
 end
end

function animate()
  if stimer<4 then
   stimer+=1
  else
   if exitguy<3 then
    exitguy+=1
   else
    exitguy=1
   end
   stimer=0
  end
end

function move(o) --move an object
 local lx=o.x --last x pos
 local ly=o.y --last y pos
  
 if (btn(⬅️)) then
   if o.x >=0 then
     o.x-=2
   end 
   animate()
   o.f=true
 end
 if (btn(➡️)) then
   o.x+=2
   animate()
   o.f=false
 end

 -- if it collides, move back
 if collide(o) then
  o.x=lx
  o.y=ly
 end 

 --jumping--
 if btnp(❎) or btnp(⬆️) then
  if onground(o) then
   jforce=20
   --sfx(0)
  end
 end
 
 if jforce>0 then
  jforce=jforce*0.6
 end
 
 o.y-=jforce
 
 --gravity--
 if not onground(o) then
    o.y+=gravity
 end
 
 -- if it collides, move back
 if collide(o,"top") then
  o.x=lx
  o.y=ly
 end 
end

function pickups(o) 
 local tilex=(o.x+4)/8
 local tiley=(o.y+4)/8
 local tile = mget(tilex,tiley)

 -- floppy
 if tile == 9 then
   o.p+=14
   sfx(1)
   mset(tilex,tiley,0)
 end
 -- usb stick
 if tile == 10 then
   o.p+=100
   sfx(1)
   mset(tilex,tiley,0)
 end
 -- heart
 if tile == 11 and o.h <=99 then
   if o.h<=90 then
     o.h+=10
   elseif o.h<=99 then
     o.h=100
   end
   sfx(2)
   mset(tilex,tiley,0)
 end
 -- printer
 if tile == 12 then
   o.h-=15
   jforce=15
   sfx(3)
 end
 
 if tile == 63 then
   state="theend"
 end
end
__gfx__
0000000000bbbb0000bbbb0000bbbb00000000000000000000000000000000000000000099669690006660000880088005555550000000000000000000000000
0000000000bbbb0000bbbb0000bbbb00000000000000000000000000000000000000000099669699006560008888888805777750000000000000000000000000
00700700000bb000000bb000000bb000000000000000000000000000000000000000000099666699033333008888888805555550000000000000000000000000
000770000bbbbbb00bbbbb000bbbbbb0000000000000000000000000000000000000000099999999033333008888888855777755000000000000000000000000
00077000b0bbb00000bbb000b0bbb000000000000000000000000000000000000000000097777779033333008888888855555555000000000000000000000000
0070070000bbb00000bbb00000bbb000000000000000000000000000000000000000000097777779033333000888888055555555000000000000000000000000
00000000bbb0bb0000b0b00000b0b000000000000000000000000000000000000000000097777779033333000088880055555575000000000000000000000000
0000000000000bb000b0b0000b000b00000000000000000000000000000000000000000097777779033333000008800055555555000000000000000000000000
08800880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd5555dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddd5dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55ddd5dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd5ddddddd5ddddd4444444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd5ddddddd5ddddd4444444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd5dd5dddd5dd5dd5555444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d55dd5ddd55dd5dd4445554400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddd555ddddd5554444444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddd4555554400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddd55dddddd55ddd4444455500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddd5ddddddd5ddd4444444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050005555
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050005555
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050005555
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050005555
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050005055
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005555555550005555
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000000550000055
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000005550000005
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000bbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000bbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000b0bbb00000000000000000000000000000000000000000000dd5ddddd000000000000000000000000000000000000000000000000
0000000000000000000000000bbb00000000000000000000000000000000000000000000dd5ddddd000000000000000000000000000000000000000000000000
00000000000000000000000bbb0bb0000000000000000000000000000000000000000000dd5dd5dd000000000000000000000000000000000000000000000000
0000000000000000000000000000bb000000000000000000000000000000000000000000d55dd5dd000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000ddddd555000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000dddddddd000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000ddd55ddd000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000dddd5ddd000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000dd5ddddd000000000000000000000000dd5ddddd000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000dd5ddddd000000000000000000000000dd5ddddd000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000dd5dd5dd000000000000000000000000dd5dd5dd000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000d55dd5dd000000000000000000000000d55dd5dd000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000ddddd555000000000000000000000000ddddd555000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000dddddddd000000000000000000000000dddddddd000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000ddd55ddd000000000000000000000000ddd55ddd000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000dddd5ddd000000000000000000000000dddd5ddd000000000000000000000000000000000000000000000000
dd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddd
dd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddd
dd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dd
d55dd5ddd55dd5ddd55dd5ddd55dd5ddd55dd5ddd55dd5ddd55dd5ddd55dd5ddd55dd5ddd55dd5ddd55dd5ddd55dd5ddd55dd5ddd55dd5ddd55dd5ddd55dd5dd
ddddd555ddddd555ddddd555ddddd555ddddd555ddddd555ddddd555ddddd555ddddd555ddddd555ddddd555ddddd555ddddd555ddddd555ddddd555ddddd555
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
ddd55dddddd55dddddd55dddddd55dddddd55dddddd55dddddd55dddddd55dddddd55dddddd55dddddd55dddddd55dddddd55dddddd55dddddd55dddddd55ddd
dddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddd

__gff__
0000000000000000000400000000000003000000000000000000000000000000010001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2020202020200000000000000000000000000000090909090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020202020202020
2020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
2020202020200000000000000000000000000020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
2020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
2020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
20202020202000000000000009000020202020000000000000000000000000000000000000090000000c0900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
2020202020200000000000090000000000000000000000000000000000000020202000000020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
20202020202000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
202020202020000000202020102020000b000000000000002020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a20
20202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0a20
20202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0a20
202020202120202020202000000000000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002020200000000000000000000000000000000000000000000000000000000000000000000000000000000000222222222220
0000202020202000000000000020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020
0a002121212121000000000000000020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003e0020
0a002020202020000000002000000920201000000000000900000000000000000000000000000000202020000000202000000000000000000000000000000000000000000000202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003f0a20
2020202020202020202020202020202020202020202000002020202020202020202020202020202020202020202020202020202020202020202020202000002020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020
0000000000000000000000000000000000000000001000001000000000000000000000000000000000000000000000000000000000000000000000001000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000001000001000000000000000000000000000000000000000000000000000000000000000000000001000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000001000001000000000000000000000000000000000000000000000000000000000000000000000001000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000001000001000000000000000000000000000000000000000000000000000000000000000000000001000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000001010101000000000000000000000000000000000000000000000000000000000000000000000001010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010000000000000000000000000000000000000000000000000000000000025350283502c3503035000000343500000036350000003435000000303502b3502535000000000000000000000000000000000000
00080000250502e050330503705000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400002c0503005033050350503a0503c0503e0503f050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000705001050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
