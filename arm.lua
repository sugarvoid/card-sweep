Arm = {}
Arm.__index = Arm





function Arm:new(pos)
    local _arm = setmetatable({}, Arm)
    _arm.position = {x=0, y=0}
    _arm.img = love.graphics.newImage("arm.png")
    _arm.ox = 15
    _arm.oy = 15
    _arm.rot = math.rad(0)
    _arm.starting_pos = {x=0, y=0}
    return _arm
end

function Arm:update(dt, mx, my)
    self.position.x = mx
    self.position.y = my
end

function Arm:move()

end

function Arm:set_rotation(dir)
    if dir == "top" then
        self.rot = math.rad(-90)

    elseif dir == "left" then
        self.rot = math.rad(180)
    elseif dir == "right" then
        self.rot = math.rad(0)
    elseif dir == "bottom" then
        self.rot = math.rad(90)
    end
end

function Arm:draw()
    -- from the right offset = 15,15
    -- from the top = -90
    -- from the left = 180
    -- from the right = 0 
    -- from the bottom = 90
    love.graphics.draw(self.img, self.position.x, self.position.y, self.rot, 1, 1, self.ox, self.oy)
end

function Arm:reset()

end

function Arm:grab_card(card)
    card.hand = self
    flux.to(self.position, 0.3, { x = card.home_pos.x, y = card.home_pos.y }):oncomplete(
        function()
            card.is_held = true
            card.is_on_board = false
            card.is_hovered = false
            flux.to(self.position, 0.3, { x = self.starting_pos.x, y = self.starting_pos.y }):oncomplete(
                function()
                    card.is_held = false
                    card.hand = nil
                end
            )
        end
    )
end


