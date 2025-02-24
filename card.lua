Card = {}
Card.__index = Card

local SPRITESHEET = love.graphics.newImage("card_sheet.png")


local CARD_W = 22
local CARD_H = 32

local ox = CARD_W / 2
local oy = CARD_H / 2

local FLIP_DURATION = 0.2

NORMAL_CHANCE = 0.70
SKULL_CHANCE = 0.20
CROSS_CHANCE = 0.10


local card_types = {
  love.graphics.newQuad(0, 0, 22, 32, SPRITESHEET),     --card_back =
  love.graphics.newQuad(22, 0, 22, 32, SPRITESHEET),    --card_red =
  love.graphics.newQuad(44, 0, 22, 32, SPRITESHEET),    --card_blue =
  love.graphics.newQuad(66, 0, 22, 32, SPRITESHEET),    --card_green =
  love.graphics.newQuad(88, 0, 22, 32, SPRITESHEET),    --card_yellow =
  love.graphics.newQuad(110, 0, 22, 32, SPRITESHEET),   --card_skull =
  love.graphics.newQuad(132, 0, 22, 32, SPRITESHEET),   --card_cross =
}

-- local card_back = love.graphics.newQuad(0, 0, 22, 32, SPRITESHEET)
-- local card_red = love.graphics.newQuad(22, 0, 22, 32, SPRITESHEET)
-- local card_blue = love.graphics.newQuad(44, 0, 22, 32, SPRITESHEET)
-- local card_green = love.graphics.newQuad(66, 0, 22, 32, SPRITESHEET)
-- local card_yellow = love.graphics.newQuad(88, 0, 22, 32, SPRITESHEET)
-- local card_skull = love.graphics.newQuad(110, 0, 22, 32, SPRITESHEET)
-- local card_cross = love.graphics.newQuad(132, 0, 22, 32, SPRITESHEET)


function generate_card_types()
  local roll = random_float()
  if roll <= NORMAL_CHANCE then
    --print("normal")
    return love.math.random(2, 5)
  elseif roll > NORMAL_CHANCE and roll <= (NORMAL_CHANCE + SKULL_CHANCE) then
    --print("skull")
    return 6
  elseif roll > (NORMAL_CHANCE + SKULL_CHANCE) then
    --print("cross")
    return 7
  end
end

function Card:new(pos, spot)
  local _card = setmetatable({}, Card)
  _card.spot = spot
  _card.home_pos = pos
  _card.face_img = card_types[1]
  _card.position = { x = 120, y = -50 }
  _card.type = 0   -- or type???
  _card.is_face_down = true
  _card.is_clickable = false
  _card.is_on_board = true
  _card.is_hovered = false
  _card.hitbox = { x = _card.home_pos.x - ox, y = _card.home_pos.y - oy, w = CARD_W, h = CARD_H }
  _card.sx = 1
  _card.hand = nil
  _card.is_held = false
  return _card
end

function Card:update(dt)
  if self.is_held and self.hand ~= nil then
    self.position = self.hand.position
  end
end

function Card:move()

end

function Card:draw()
  if self.is_hovered and self.is_clickable and player_can_click then
    love.graphics.push("all")
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
    love.graphics.rectangle("line", self.hitbox.x, self.hitbox.y, self.hitbox.w, self.hitbox.h)
    love.graphics.pop()
  end

  if self.is_face_down then
    love.graphics.draw(SPRITESHEET, self.face_img, self.position.x, self.position.y, 0, self.sx, 1, ox, oy)
  else

  end
end

function Card:reset()

end

function Card:slide_to_home_position()
  flux.to(self.position, 0.3, { x = self.home_pos.x, y = self.home_pos.y }):oncomplete(
    function()
      self.is_clickable = true
      self.is_held = false
      self.is_on_board = true
      self.is_hovered = false
    end
  )
end

function Card:set_face(c_idx)
  self.type = c_idx
end

function Card:remove_from_board()
  -- body
  print('removing ' .. tostring(self))
end

function Card:show_face()
  self.is_clickable = false
  flux.to(self, FLIP_DURATION, { sx = 0 }):oncomplete(
    function()
      --print(self.type)
      --print(card_types[self.type])
      self.face_img = card_types[self.type]

      flux.to(self, FLIP_DURATION, { sx = 1 })
    end
  )

end

function Card:show_back()
  self.is_clickable = false
  flux.to(self, FLIP_DURATION, { sx = 0 }):oncomplete(
    function()
      self.face_img = card_types[1]

      flux.to(self, FLIP_DURATION, { sx = 1 }):oncomplete(
        function()
          print('ding')
          self.is_clickable = true
        end
      )
    end
  )

end

function Card:check_if_hovered(mx, my)
  if (self.hitbox.x <= mx and self.hitbox.x + self.hitbox.w >= mx) and (self.hitbox.y <= my and self.hitbox.y + self.hitbox.h >= my) then
    self.is_hovered = true
  else
    self.is_hovered = false
  end
end

function check_cards(c1, c2)
  --return selected_card_1.type == selected_card_2.type

  if c1.type == c2.type then
    --TODO: Remove cards
    Timer.script(function(wait)
      wait(1)
      arm_1:grab_card(c1)
      arm_2:grab_card(c2)
      wait(0.5)
      selected_card_1 = nil
      selected_card_2 = nil
      player_can_click = true
    end)
  else
    --TODO: Flip them back over
    Timer.script(function(wait)
      wait(1)
      c1:show_back()
      c2:show_back()
      wait(0.5)
      selected_card_1 = nil
      selected_card_2 = nil
      player_can_click = true
    end)
  end
end

function random_float()
  local offset = 1 * math.random()
  return math.floor(offset * 10 + 0.5) / 10
end
