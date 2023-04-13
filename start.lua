local function printTime(action)
    local formatDate = os.date("%I:%M %p", os.time())
    rconsoleprint(action..formatDate.."\n")
end

rconsolename("Wins Info")
loadstring(game:HttpGet("https://raw.githubusercontent.com/1POP1k33kxx0x0xz/misc/main/wins.lua"))(printTime)
