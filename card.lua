Card = {}
Card.__index = Card

local SPRITESHEET = love.graphics.newImage("card_sheet.png")


local CARD_W = 22
local CARD_H = 32

local ox = CARD_W/2
local oy = CARD_H/2




local card_types = {
    card_back = love.graphics.newQuad(0, 0, 22, 32, SPRITESHEET),
    card_red = love.graphics.newQuad(22, 0, 22, 32, SPRITESHEET),
    card_blue = love.graphics.newQuad(44, 0, 22, 32, SPRITESHEET),
    card_green = love.graphics.newQuad(66, 0, 22, 32, SPRITESHEET),
    card_yellow = love.graphics.newQuad(88, 0, 22, 32, SPRITESHEET),
    card_skull = love.graphics.newQuad(110, 0, 22, 32, SPRITESHEET),
    card_cross = love.graphics.newQuad(132, 0, 22, 32, SPRITESHEET),
}

-- local card_back = love.graphics.newQuad(0, 0, 22, 32, SPRITESHEET)
-- local card_red = love.graphics.newQuad(22, 0, 22, 32, SPRITESHEET)
-- local card_blue = love.graphics.newQuad(44, 0, 22, 32, SPRITESHEET)
-- local card_green = love.graphics.newQuad(66, 0, 22, 32, SPRITESHEET)
-- local card_yellow = love.graphics.newQuad(88, 0, 22, 32, SPRITESHEET)
-- local card_skull = love.graphics.newQuad(110, 0, 22, 32, SPRITESHEET)
-- local card_cross = love.graphics.newQuad(132, 0, 22, 32, SPRITESHEET)

function Card:new(pos)
    local _card = setmetatable({}, Card)
    _card.home_pos = pos

    --_card.position = {x= 0, y=0}
    _card.type = nil -- or type???
    _card.is_face_down = true
    _card.is_clickable = true
    _card.is_hovered = false
    _card.hitbox = { x = _card.home_pos.x - ox, y = _card.home_pos.y - oy, w = CARD_W, h = CARD_H }


    _card.position = _card.home_pos
    print(_card.position.x, _card.position.y)

    return _card
end

function Card:update(dt)

end

function Card:move()

end

function Card:draw()

    if self.is_hovered then
        love.graphics.push("all")
        love.graphics.setColor(love.math.colorFromBytes(252, 186, 3))
        love.graphics.rectangle("line", self.hitbox.x, self.hitbox.y, self.hitbox.w, self.hitbox.h)
        love.graphics.pop()
    end

    if self.is_face_down then
        love.graphics.draw(SPRITESHEET, card_types.card_back, self.position.x, self.position.y, 0, 1, 1, ox, oy)
        love.graphics.points(self.position.x, self.position.y)


       

        --love.graphics.rectangle("line", self.hitbox.x, self.hitbox.y, self.hitbox.w, self.hitbox.h)
    else

    end
end

function Card:reset()

end

function Card:flip_over()

end

function Card:check_if_hovered(mx, my)
    if (self.hitbox.x <= mx and self.hitbox.x + self.hitbox.w >= mx) and (self.hitbox.y <= my and self.hitbox.y + self.hitbox.h >= my) then
        self.is_hovered = true
    else
        self.is_hovered = false
    end
end
