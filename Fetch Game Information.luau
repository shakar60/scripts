-- made by @xora_is_banned
local MarketplaceService = game:GetService("MarketplaceService")
local GameProductInfo = MarketplaceService:GetProductInfo(game.PlaceId)

local GameInformation = {}

setmetatable(GameInformation, {
    __index = function(_, Key)
        Key = tostring(Key):lower()
        if Key == "name" then
            return GameProductInfo.Name
        elseif Key == "id" or Key == "identification" then
             return game.PlaceId
        elseif Key == "description" or Key == "desc" then
            return GameProductInfo.Description
        elseif Key == "created" then
            return GameProductInfo.Created
        elseif Key == "lastupdatedate" or Key == "lastupdated" then
            return GameProductInfo.Updated
        elseif Key == "isnew" then
            return GameProductInfo.IsNew
        elseif Key == "creator" then
            local Creator = {}
            setmetatable(Creator, {
                __index = function(_, Key)
                    Key = tostring(Key):lower()
                    if Key == "name" then
                        return GameProductInfo.Creator.Name
                    elseif Key == "id" or Key == "identification" then
                        return GameProductInfo.Creator.Id
                    elseif Key == "type" then
                        return GameProductInfo.Creator.CreatorType
                    elseif Key == "isverified" or Key == "hasverifiedbadge" then
                        return GameProductInfo.Creator.HasVerifiedBadge
                    end
                end
            })
            table.freeze(Creator)
            return Creator
        end
    end
})
table.freeze(GameInformation)

return GameInformation

-- loadstring(game:HttpGet("https://raw.githubusercontent.com/TheRealXORA/Roblox/refs/heads/Main/Scripts%20/Utilities%20/Fetch%20Game%20Information.luau", true))()
