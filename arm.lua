Arm = {}
Arm.__index = Arm


q1 = {1,2,3,6,7,8}
q2 = {4,5,9,10}
q3 = {11,12,13,16,17}
q4 = {14,15,18,19,20}


function Arm:new(pos)
    local _arm = setmetatable({}, Arm)
    _arm.position = {x=0, y=-100}
    _arm.img = love.graphics.newImage("arm.png")
    _arm.ox = 15
    _arm.oy = 15
    _arm.rot = math.rad(0)
    _arm.starting_pos = {x=0, y=0}
    return _arm
end


function Arm:move(new_x, new_y)
    self.position.x = new_x
    self.position.y = new_y
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
    local v = card.spot
    local start = {}
    
    if does_table_contains(q1, v) then
        print("card in q1")
        self:set_rotation("top")
        start = {x=120, y=-40}
    elseif does_table_contains(q2, v) then
        self:set_rotation("right")
        start = {x=250, y=120}
        print("card in q2")
    elseif does_table_contains(q3, v) then
        self:set_rotation("left")
        start = {x=-40, y=120}
        print("card in q3")
    elseif does_table_contains(q4, v) then
        self:set_rotation("bottom")
        start = {x=120, y=250}
        print("card in q4")
    end

    card.hand = self
    self:move(start.x, start.y)
    flux.to(self.position, 0.3, { x = card.home_pos.x, y = card.home_pos.y }):oncomplete(
        function()
            card.is_held = true
            card.is_on_board = false
            card.is_hovered = false
            flux.to(self.position, 0.3, { x = start.x, y = start.y }):oncomplete(
                function()
                    card.is_held = false
                    card.hand = nil
                    del(active_cards, card)
                    table.insert(graveyard, card)
                end
            )
        end
    )
end


