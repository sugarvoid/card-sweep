Card = {}
Card.__index = Card

local SPRITESHEET = love.graphics.newImage("card_sheet.png")


local CARD_W = 22
local CARD_H = 32

local ox = CARD_W/2
local oy = CARD_H/2

NORMAL_CHANCE = 0.70
SKULL_CHANCE = 0.20
CROSS_CHANCE = 0.10


local card_types = {
    love.graphics.newQuad(0, 0, 22, 32, SPRITESHEET),--card_back = 
    love.graphics.newQuad(22, 0, 22, 32, SPRITESHEET),--card_red = 
    love.graphics.newQuad(44, 0, 22, 32, SPRITESHEET),--card_blue = 
    love.graphics.newQuad(66, 0, 22, 32, SPRITESHEET),--card_green = 
    love.graphics.newQuad(88, 0, 22, 32, SPRITESHEET),--card_yellow = 
    love.graphics.newQuad(110, 0, 22, 32, SPRITESHEET),--card_skull = 
    love.graphics.newQuad(132, 0, 22, 32, SPRITESHEET),--card_cross = 
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
  print(roll)
  if roll <= NORMAL_CHANCE then
    print("normal")
    return love.math.random(2, 5)
  elseif roll > NORMAL_CHANCE and roll <= (NORMAL_CHANCE + SKULL_CHANCE) then
    print("skull")
    return 6
  elseif roll > (NORMAL_CHANCE + SKULL_CHANCE) then
    print("cross")
    return 7
  end
end


function Card:new(pos, spot)
    local _card = setmetatable({}, Card)
    _card.spot = spot
    _card.home_pos = pos
    _card.face_img = card_types[1]
    _card.position = {x= 120, y=-50}
    _card.type = 0 -- or type???
    _card.is_face_down = true
    _card.is_clickable = false
    _card.is_on_board = true
    _card.is_hovered = false
    _card.hitbox = { x = _card.home_pos.x - ox, y = _card.home_pos.y - oy, w = CARD_W, h = CARD_H }
    _card.sx = 1
    _card.hand = nil
    _card.is_held = false   


    --_card.position = _card.home_pos

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

    if self.is_hovered and self.is_clickable then
        love.graphics.push("all")
        love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
        love.graphics.rectangle("line", self.hitbox.x, self.hitbox.y, self.hitbox.w, self.hitbox.h)
        love.graphics.pop()
    end

    if self.is_face_down then
        love.graphics.draw(SPRITESHEET, self.face_img, self.position.x, self.position.y, 0, self.sx, 1, ox, oy)
        --love.graphics.points(self.position.x, self.position.y)
        --love.graphics.rectangle("line", self.hitbox.x, self.hitbox.y, self.hitbox.w, self.hitbox.h)
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
  print("c_index = " .. tostring(c_idx))
    self.type = c_idx
    --self.face_img = card_types[c_idx]
end

function Card:remove_from_board()
  -- body
  print('removing ' .. tostring(self))
end

function Card:show_face()
  self.is_clickable = false
  flux.to(self, 0.3, { sx = 0}):oncomplete(
        function()
          print(self.type)
            print(card_types[self.type])
            self.face_img = card_types[self.type]
            
            flux.to(self, 0.3, { sx = 1}):oncomplete(
                function()
                    print('ding')
                    --self.is_clickable = true
                    if selected_card_1 ~= nil and selected_card_2 ~= nil then
                        if check_cards() then
                          --TODO: Remove cards
                          selected_card_1:remove_from_board()
                          selected_card_2:remove_from_board()
                        else
                          --TODO: Flip them back over
                          
                        end
                        selected_card_1 = nil
                        selected_card_2 = nil
                    end
                end
            )
        end
    )


    --self.face_img = card_types.card_red
end

function Card:show_back()
  self.is_clickable = false
  flux.to(self, 0.3, { sx = 0}):oncomplete(
        function()
            self.face_img = card_types[1]
            
            flux.to(self, 0.3, { sx = 1}):oncomplete(
                function()
                    print('ding')
                    self.is_clickable = true
                end
            )
        end
    )


    --self.face_img = card_types.card_red
end

function Card:check_if_hovered(mx, my)
    if (self.hitbox.x <= mx and self.hitbox.x + self.hitbox.w >= mx) and (self.hitbox.y <= my and self.hitbox.y + self.hitbox.h >= my) then
        self.is_hovered = true
    else
        self.is_hovered = false
    end
end

function check_cards()
  return selected_card_1.type == selected_card_2.type
end


function random_float()
  --local range = max - min
  local offset = 1 * math.random()
  --local unrounded = min + offset
  --local powerOfTen = 10 ^ precision
  return math.floor(offset * 10 + 0.5) / 10
end