local naughty = require("naughty")
local awful = require("awful")
local client = client
function GetClientByClass(class)
    for _, c in ipairs(client.get()) do
        if class == c.class then
            return c
        end
    end
    return nil
end


function SpawnOrFocusClient(class, cmd, jump)
    local c = GetClientByClass(class)
    if c == nil then
        awful.spawn(cmd)
        return
    end
    c:jump_to(jump)

end