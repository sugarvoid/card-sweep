love.graphics.setDefaultFilter("nearest", "nearest")
flux = require("lib.flux")

require("card")


slots = { 2, 20, 38, 56, 74, 92, 110 }


all_windlines = {}
cards = {}

local card_pos = {
    {x = 58, y = 65},
    {x = 88, y = 65},
    {x = 118, y = 65},
    {x = 148, y = 65},
    {x = 178, y = 65},
    {x = 58, y = 105},
    {x = 88, y = 105},
    {x = 118, y = 105},
    {x = 148, y = 105},
    {x = 178, y = 105},
    {x = 58, y = 145},
    {x = 88, y = 145},
    {x = 118, y = 145},
    {x = 148, y = 145},
    {x = 178, y = 145},
    {x = 58, y = 185},
    {x = 88, y = 185},
    {x = 118, y = 185},
    {x = 148, y = 185},
    {x = 178, y = 185}
}



for i = 1, 20 do
    local _c = Card:new(card_pos[i])
    table.insert(cards, _c)
end

print(#cards)

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
    width, height = love.graphics.getDimensions(0, 81, 44, 225)
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

    love.graphics.print(mx .. "," .. my, 0, 0, 0, 0.6, 0.6)


   print(cards[3].is_hovered)

    for _, c in ipairs(cards) do
        c:draw()
        c:check_if_hovered(mx, my)
    end

    --start of draw_play()
end

function resize(w, h)                       -- update new translation and scale:
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

function draw_debug()
    love.graphics.print("player slot " .. "add", 4, 2)
    love.graphics.print("human slot " .. "add", 4, 22)
    love.graphics.print("future slot " .. "add", 4, 44)
    love.graphics.print("p looking left: " .. "add", 4, 66)
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
