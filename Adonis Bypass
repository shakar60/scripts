-- by @xora_is_banned
if BYPASSED_ADONIS then return end
getgenv().ADONIS_BYPASS_DEBUG_MODE = true

local ScriptContext = game:service("ScriptContext")
local LocalPlayer = game:service("Players").LocalPlayer

ScriptContext:SetTimeout(1)

local function StringArguments(...)
    local Arguments = {...}
    for Index, Value in Arguments do
        Arguments[Index] = tostring(Value)
    end
    return Arguments
end

local Kick; Kick = hookfunction(LocalPlayer.Kick, function(...)
    if checkcaller() or tostring(getcallingscript()) ~= "ClientMover" then return Kick(...) end
    if ADONIS_BYPASS_DEBUG_MODE then
        warn("\n------------------------------")
        warn("DEBUG: LocalPlayer Kick function has been called, arguments:", table.concat(StringArguments(...), ", ")) 
        warn("------------------------------\n")
    end
end)

if ADONIS_BYPASS_DEBUG_MODE and Kick then warn("Debugging: Hooked Kick function!") end

local DebugInfo; DebugInfo = hookfunction(debug.info, function(...)
    if checkcaller() or tostring(getcallingscript()) ~= "ClientMover" or select(2, ...) ~= "slanf" then return DebugInfo(...) end
    if ADONIS_BYPASS_DEBUG_MODE then
        warn("\n------------------------------")
        warn("DEBUG: debug.info function has been called, arguments:", table.concat(StringArguments(...), ", ")) 
        warn("------------------------------\n")
    end
    return coroutine.yield()
end)

if ADONIS_BYPASS_DEBUG_MODE and DebugInfo then warn("Debugging: Hooked debug.info function!") end

for _, Collected in getgc(true) do
    if type(Collected) ~= "table" then continue end
    local Detected, Kill = rawget(Collected, "Detected"), rawget(Collected, "Kill")
    
    if type(Kill) == "function" and debug.info(Kill, "s") == ".Client.Client" then
        hookfunction(Kill, function(Info) 
            if ADONIS_BYPASS_DEBUG_MODE then 
                warn("\n------------------------------")
                warn("DEBUG: Kill function has been called, Information argument:", tostring(Info))
                warn("------------------------------\n")
            end 
        end)
        if ADONIS_BYPASS_DEBUG_MODE then warn("Debugging: Hooked Kill function!") end
    end
    
    if type(Detected) == "function" and debug.info(Detected, "s") == ".Client.Core.Anti" then
        hookfunction(Detected, function(Action, Info, NoCrash) 
            if ADONIS_BYPASS_DEBUG_MODE then
                warn("\n------------------------------")
                warn("DEBUG: Detected function has been called, Action argument:", tostring(Action), "Information argument:", tostring(Info), "No Crash argument:", tostring(NoCrash))
                warn("------------------------------\n")
            end
        end)
        if ADONIS_BYPASS_DEBUG_MODE then warn("Debugging: Hooked Detected function!") end
    end
end

getgenv().BYPASSED_ADONIS = true

--[[
hookfunction(getfenv, function() end)
local GetFenv; GetFenv = hookfunction(pcall, function(...) return GetFenv(...) end)
local namecall; namecall = hookmetamethod(game,"__namecall",function(self,...)return namecall(self,...)end)
local index; index = hookmetamethod(game,"__index",function(self,key)return index(self,key)end)
local newindex; newindex = hookmetamethod(game,"__newindex",function(self,key,value)return newindex(self,key,value)end)
]]
