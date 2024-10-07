Arm = {}
Arm.__index = Arm



function Arm:new(pos)
    local _arm = setmetatable({}, Arm)

    return _arm
end

function Arm:update(dt)

end

function Arm:move()

end

function Arm:draw()

end

function Arm:reset()

end

function Arm:grab_card(card_idx)
    
end


