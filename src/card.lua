Card={}
Card.__index=Card

local SPRITESHEET=love.graphics.newImage("res/card_sheet.png")

local CARD_W=22
local CARD_H=32

local ox=CARD_W/2
local oy=CARD_H/2

local FLIP_DURATION=0.2

cross_count=2
skull_count=4

blue_count=4
red_count=4
yellow_count=2
green_count=4

local card_types={
 love.graphics.newQuad(0,0,22,32,SPRITESHEET),--card_back
 love.graphics.newQuad(22,0,22,32,SPRITESHEET),--card_red
 love.graphics.newQuad(44,0,22,32,SPRITESHEET),--card_blue
 love.graphics.newQuad(66,0,22,32,SPRITESHEET),--card_green
 love.graphics.newQuad(88,0,22,32,SPRITESHEET),--card_yellow
 love.graphics.newQuad(110,0,22,32,SPRITESHEET),--card_skull
 love.graphics.newQuad(132,0,22,32,SPRITESHEET),--card_cross
}

function Card:new(pos,spot)
 local c=setmetatable({},Card)
 c.spot=spot
 c.home_pos=pos
 c.face_img=card_types[1]
 c.position={x=120,y=-50}
 c.type=0
 c.is_face_down=true
 c.is_clickable=false
 c.is_on_board=true
 c.is_hovered=false
 c.hitbox={x=c.home_pos.x-ox,y=c.home_pos.y-oy,w=CARD_W,h=CARD_H}
 c.sx=1
 c.hand=nil
 c.is_held=false
 return c
end

function Card:update(dt)
 if self.is_held and self.hand~=nil then
  self.position=self.hand.position
 end
end

function Card:move()
end

function Card:draw()
 if self.is_hovered and self.is_clickable and player_can_click then
  love.graphics.push("all")
  love.graphics.setColor(love.math.colorFromBytes(255,255,255))
  love.graphics.rectangle("line",self.hitbox.x,self.hitbox.y,self.hitbox.w,self.hitbox.h)
  love.graphics.pop()
 end
 if self.is_face_down then
  love.graphics.draw(SPRITESHEET,self.face_img,self.position.x,self.position.y,0,self.sx,1,ox,oy)
 end
end

function Card:reset()
end

function Card:slide_to_home_position()
 flux.to(self.position,0.3,{x=self.home_pos.x,y=self.home_pos.y}):oncomplete(
  function()
   self.is_clickable=true
   self.is_held=false
   self.is_on_board=true
   self.is_hovered=false
  end
 )
end

function Card:set_face(c_idx)
 self.type=c_idx
end

function Card:remove_from_board()
 logger.debug('removing '..tostring(self))
end

function Card:show_face()
 self.is_clickable=false
 flux.to(self,FLIP_DURATION,{sx=0}):oncomplete(
  function()
   self.face_img=card_types[self.type]
   flux.to(self,FLIP_DURATION,{sx=1})
  end
 )
end

function Card:show_back()
 self.is_clickable=false
 flux.to(self,FLIP_DURATION,{sx=0}):oncomplete(
  function()
   self.face_img=card_types[1]
   flux.to(self,FLIP_DURATION,{sx=1}):oncomplete(
    function()
     logger.debug(tostring(self)..' flipped back over')
     self.is_clickable=true
    end
   )
  end
 )
end

function Card:check_if_hovered(mx,my)
 if (self.hitbox.x<=mx and self.hitbox.x+self.hitbox.w>=mx) and (self.hitbox.y<=my and self.hitbox.y+self.hitbox.h>=my) then
  self.is_hovered=true
 else
  self.is_hovered=false
 end
end

function check_cards(c1,c2)
 if c1.type==c2.type then
  if c1.type==7 then
   logger.debug("Cross cards matched. Remove skull")
   Timer.script(function(wait)
    wait(1)
    remove_skull()
    wait(1)
    grab_pairs(c1,c2)
    wait(0.5)
    reset_selected_cards()
   end)
  else
   Timer.script(function(wait)
    wait(1)
    grab_pairs(c1,c2)
    wait(0.5)
    reset_selected_cards()
   end)
  end
 else
  --Flip them back over
  Timer.script(function(wait)
   wait(1)
   c1:show_back()
   c2:show_back()
   wait(0.5)
   reset_selected_cards()
  end)
 end
end

function grab_pairs(c1,c2)
 arm_1:grab_card(c1)
 arm_2:grab_card(c2)
end

function reset_selected_cards()
 selected_card_1=nil
 selected_card_2=nil
 player_can_click=true
end

function random_float()
 local offset=1*math.random()
 return math.floor(offset*10+0.5)/10
end

function remove_skull()
 for _,c in ipairs(active_cards) do
  if c.type==6 then
   logger.debug("found a skull")
   Timer.script(function(wait)
    c:show_face()
    wait(0.5)
    arm_2:grab_card(c)
    reset_selected_cards()
   end)
   break
  end
 end
end
