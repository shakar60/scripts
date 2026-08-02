-- by @xora_is_banned
local GameInformation = loadstring(game:HttpGet("https://raw.githubusercontent.com/XORAWasBanned/Roblox/refs/heads/main/Scripts/Utilities%20/Others%20/Game%20Information%20Fetcher.luau", true))()
if not GameInformation.Name:find("Dan FFA") then return end
local Namecall; Namecall = hookmetamethod(game, "__namecall", function(...)
    if checkcaller() then return Namecall(...) end
    local Arguments = {...}
    local Method = getnamecallmethod()
    if Method == "FireServer" and Arguments[2] == "CheatGuard" then
        return coroutine.yield()
    end
    return Namecall(...)
end)
local TaskWait; TaskWait = hookfunction(task.wait, function(Duration)
    if checkcaller() then return TaskWait(Duration) end
    local CallingScript = getcallingscript()
    if CallingScript and CallingScript.Name ~= "Animate" and CallingScript.Parent and not CallingScript.Parent:IsA("Tool") and CallingScript.Parent:IsDescendantOf(workspace) then
        Duration = 2e9
    end
    return TaskWait(Duration)
end)
