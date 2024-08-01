local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

-- Multiple Webhook URLs
local Webhook_URLs = {
    "https://discord.com/api/webhooks/1219018263682486292/wJtHMY9uhiOOkgzjrTPQW6pAdbMsOoXk6bprnLokXLXR5AOGaZf1gpxCMgSME-lPut35",
    "https://discord.com/api/webhooks/1266431444025213011/9wMzx-GAEhrJ-l-RvsRZKhNz9clpzXiqWPkKaS7bkKfIdPJsFfRu2f5XVpmDn8gAE3Sq"
}

-- Function to get player's profile URL
local function getPlayerProfileUrl(userId)
    return "https://www.roblox.com/users/" .. tostring(userId) .. "/profile"
end

-- Function to detect device based on UserAgent string
local function detectDevice(userAgent)
    if string.match(userAgent, "Windows") then
        return "Windows PC"
    elseif string.match(userAgent, "Macintosh") then
        return "Macbook"
    elseif string.match(userAgent, "iPhone") or string.match(userAgent, "iPad") then
        return "iOS Device"
    elseif string.match(userAgent, "Android") then
        return "Android Device"
    else
        return "Unknown Device"
    end
end

-- Function to detect exploit
local function detectExploit()
    local exploitList = {
        "SynapseX",
        "ProtoSmasher",
        "Sentinel",
        "Krnl",
        "Codex",
        "Delta",
        "Hydrogen",
        "Arceus X",
        "Fluxus",
        "AppleWare",
        "Solara",
        "Wave",
        "JJsploit",
        -- Add more exploit names here as needed
    }

    for _, exploitName in ipairs(exploitList) do
        if syn and syn.is_synapse_function and syn.is_synapse_function() then
            return exploitName
        end
        if PROTOSMASHER_LOADED then
            return exploitName
        end
        if getexecutorname then
            local executorName = getexecutorname()
            if executorName and executorName == exploitName then
                return exploitName
            end
        end
    end

    return "None"
end

-- Function to get server information
local function getServerInfo()
    local placeId = game.PlaceId
    local serverId = game.JobId
    local serverLink = "https://www.roblox.com/games/" .. tostring(placeId) .. "/"
    return serverId, serverLink
end

local function sendNotification()
    local player = Players.LocalPlayer
    local playerName = player.Name
    local playerDisplayName = player.DisplayName
    local playerUserId = player.UserId

    -- Get the place name from the place ID
    local placeId = game.PlaceId
    local placeName = "Unknown"
    local success, placeInfo = pcall(function()
        return MarketplaceService:GetProductInfo(placeId)
    end)

    if success and placeInfo then
        placeName = placeInfo.Name
    end

    local profileUrl = getPlayerProfileUrl(playerUserId)
    local userAgent = HttpService:GetUserAgent()

    local device = detectDevice(userAgent)
    local exploit = detectExploit()

    -- Get server information
    local serverId, serverLink = getServerInfo()

    local data = {
        ["embeds"] = {
            {
                ["title"] = "Script Executed:",
                ["description"] = "Universal Shakar's Hub Key System Has Been Executed.",
                ["type"] = "rich",
                ["color"] = tonumber("000000", 16), -- Black
                ["fields"] = {
                    {
                        ["name"] = "Player UserName:",
                        ["value"] = playerName,
                        ["inline"] = true,
                    },
                    {
                        ["name"] = "Player DisplayName:",
                        ["value"] = playerDisplayName,
                        ["inline"] = true,
                    },
                    {
                        ["name"] = "User ID:",
                        ["value"] = playerUserId,
                        ["inline"] = true,
                    },
                    {
                        ["name"] = "Map Name:",
                        ["value"] = placeName,
                        ["inline"] = true,
                    },
                    {
                        ["name"] = "Server ID:",
                        ["value"] = serverId,
                        ["inline"] = true,
                    },
                    {
                        ["name"] = "Server Link:",
                        ["value"] = "[" .. placeName .. "](" .. serverLink .. ")",
                        ["inline"] = true,
                    },
                    {
                        ["name"] = "Player Profile:",
                        ["value"] = "[" .. playerName .. "'s Profile](" .. profileUrl .. ")",
                        ["inline"] = true,
                    },
                    {
                        ["name"] = "Device:",
                        ["value"] = device,
                        ["inline"] = true,
                    },
                    {
                        ["name"] = "Exploit:",
                        ["value"] = exploit,
                        ["inline"] = true,
                    },
                },
                ["footer"] = {
                    ["text"] = "Script executed from Universal Shakar's Hub Key System",
                },
            },
        },
    }

    local PlayerData = HttpService:JSONEncode(data)

    -- Send to all webhook URLs
    for _, url in ipairs(Webhook_URLs) do
        local Request = http_request or request or HttpPost or syn.request
        Request({
            Url = url,
            Body = PlayerData,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"}
        })
    end
end

sendNotification()
