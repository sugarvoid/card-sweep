love.graphics.setDefaultFilter("nearest", "nearest")
flux = require("lib.flux")

require("card")
require("arm")
require("lib.timer")


player_can_click = true

selected_card_1 = nil
selected_card_2 = nil

slots = { 2, 20, 38, 56, 74, 92, 110 }

arm_1 = Arm:new()
arm_2 = Arm:new()

pairs_left = 0
NEEDED_PAIRS = 20

graveyard = {}

DEBUG_SCALE = 0.3



hovered_card = {}

all_windlines = {}
active_cards = {}
graveyard = {}

card_pos = {
    { x = 58,  y = 65 },
    { x = 88,  y = 65 },
    { x = 118, y = 65 },
    { x = 148, y = 65 },
    { x = 178, y = 65 },
    { x = 58,  y = 105 },
    { x = 88,  y = 105 },
    { x = 118, y = 105 },
    { x = 148, y = 105 },
    { x = 178, y = 105 },
    { x = 58,  y = 145 },
    { x = 88,  y = 145 },
    { x = 118, y = 145 },
    { x = 148, y = 145 },
    { x = 178, y = 145 },
    { x = 58,  y = 185 },
    { x = 88,  y = 185 },
    { x = 118, y = 185 },
    { x = 148, y = 185 },
    { x = 178, y = 185 }
}



for i = 1, 20 do
    local _c = Card:new(card_pos[i], i)
    _c:set_face(generate_card_types())
    table.insert(active_cards, _c)
    --generate_card_types()
end



local mx, my

--WINDOW_W, WINDOW_H = love.window.getDesktopDimensions()
--WINDOW_W, WINDOW_H = WINDOW_W * 0.8, WINDOW_H * 0.8



function love.load()
    math.randomseed(os.time())
    font = love.graphics.newFont("monogram.ttf", 32)
    font:setFilter("nearest")
    love.graphics.setFont(font)


    -- if your code was optimized for fullHD:
    window = { translateX = 0, translateY = 0, scale = 3, width = 240, height = 240 }
    --width, height = love.graphics.getDimensions(0, 81, 44, 225)
    width, height = love.graphics.getDimensions()
    love.window.setMode(width, height, { resizable = true, borderless = false })
    resize(width, height) -- update new translation and scale
end

function love.update(dt)
    flux.update(dt)


    -- mouse position with applied translate and scale:
    mx = math.floor((love.mouse.getX() - window.translateX) / window.scale + 0.5)
    my = math.floor((love.mouse.getY() - window.translateY) / window.scale + 0.5)
    -- your code here, use mx and my as mouse X and Y positions
    --print(mx, my)
    arm_1:update(dt, mx, my)
    arm_2:update(dt, mx, my)
    for _, c in ipairs(active_cards) do
        c:update(dt)
        if c.is_on_board then
            c:check_if_hovered(mx, my)
        end
    end
end

function love.mousepressed(x, y, button, _)
    if player_can_click then
        if selected_card_1 == nil or selected_card_2 == nil then
            if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
                for _, c in ipairs(active_cards) do
                    if c.is_hovered and c.is_clickable then
                        if selected_card_1 == nil then
                            selected_card_1 = c
                            c:show_face()
                        elseif selected_card_1 ~= nil and selected_card_2 == nil then
                            selected_card_2 = c
                            c:show_face()
                        end

                        if selected_card_1 ~= nil and selected_card_2 ~= nil then
                            check_cards()
                        end
                        --arm:grab_card(c)
                        --c:show_face()
                    end
                end
            end
        end
        if button == 2 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
            for _, c in ipairs(active_cards) do
                if c.is_hovered and c.is_clickable then
                    arm_1:grab_card(c)
                    --c:show_face()
                end
            end
        end
    end
end

function love.draw()
    -- first translate, then scale
    love.graphics.translate(window.translateX, window.translateY)
    love.graphics.scale(window.scale)
    -- your graphics code here, optimized for fullHD


    love.graphics.push("all")

    love.graphics.setColor(love.math.colorFromBytes(0, 81, 44))
    love.graphics.rectangle("fill", 0, 0, 240, 240)
    love.graphics.pop()

    --love.graphics.print(mx .. "," .. my, 0, 0, 0, 0.6, 0.6)




    for _, c in ipairs(active_cards) do
        c:draw()
    end

    --start of draw_play()
    arm_1:draw()
    arm_2:draw()

    draw_debug()

    love.graphics.push("all")

    love.graphics.setColor(love.math.colorFromBytes(33, 33, 35))
    love.graphics.rectangle("fill", 0, 0, 240, 15)
    love.graphics.pop()



end

function draw_debug()
    if selected_card_1 ~= nil then
        love.graphics.print("Card 1- Spot: "..selected_card_1.spot.. ", Type: " .. selected_card_1.type, 0, 215, 0, DEBUG_SCALE, DEBUG_SCALE)
    else
        love.graphics.print("Card 1- Empty", 0, 215, 0, DEBUG_SCALE, DEBUG_SCALE)
    end
    if selected_card_2 ~= nil then
        love.graphics.print("Card 2- Spot: "..selected_card_2.spot.. ", Type: " .. selected_card_2.type, 0, 225, 0, DEBUG_SCALE, DEBUG_SCALE)
    else
        love.graphics.print("Card 2- Empty", 0, 225, 0, DEBUG_SCALE, DEBUG_SCALE)
    end


end

function resize(w, h)                          -- update new translation and scale:
    local w1, h1 = window.width, window.height -- target rendering resolution
    local scale = math.min(w / w1, h / h1)
    window.translateX, window.translateY, window.scale = (w - w1 * scale) / 2, (h - h1 * scale) / 2, scale
end

function love.resize(w, h)
    resize(w, h) -- update new translation and scale
end

function love.keypressed(key, scancode, isrepeat)
    --print(isrepeat)
    if key == "escape" then
        love.event.quit()
    end
    if key == "left" then -- move right
        print("left")
        put_cards_on_board()
        --print(random_float())
    elseif key == "right" then
        print("right")
    end
    if key == "z" then

    end
    if key == "x" then

    end
    if key == "space" then
        do_action()
    end
end

function put_cards_on_board()
    for _, c in ipairs(active_cards) do
        c:slide_to_home_position()
    end
end

function do_action()
    print("action")
end

function start_game()
end

function table.for_each(_list)
    local i = 0
    return function()
        i = i + 1; return _list[i]
    end
end

function table.remove_item(_table, _item)
    for i, v in ipairs(_table) do
        if v == _item then
            _table[i] = _table[#_table]
            _table[#_table] = nil
            return
        end
    end
end



function goto_gameover(reason)
    -- 0 = bad lick
    -- 1 = bad move
    -- 2 = game won
    print("game over")
end

function draw_title()

end

function draw_play()

end

function draw_gameover()

end

---Check if an object is on screen
---@param obj table
---@param rect table with screen data {x=0,y=0,w=0,h=0}
function is_on_screen(obj, rect)
    if ((obj.x >= rect.x + rect.w) or
            (obj.x + obj.w <= rect.x) or
            (obj.y >= rect.y + rect.h) or
            (obj.y + obj.h <= rect.y)) then
        return false
    else
        return true
    end
end

function does_table_contains(tbl, x)
    found = false
    for _, v in pairs(tbl) do
        if v == x then 
            found = true 
        end
    end
    return found
end

function del(_table, _item)
    for i, v in ipairs(_table) do
        if v == _item then
            _table[i] = _table[#_table]
            _table[#_table] = nil
            return
        end
    end
end
