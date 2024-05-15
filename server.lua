local roleList = TagConfig.roleList
local roleTracker = {}
local prefixes = {}
activeTagTracker = {}

---------------
-- Main
--------------- 
AddEventHandler('chatMessage', function(source, name, msg)
    local args = stringsplit(msg)
    CancelEvent()
    local serverId = source
    local selectedTag = roleTracker[source] or roleList[1][2]
    local args2 = stringsplit(msg, " ")
    local coloredMsg = msg:gsub("~b~", "^4"):gsub("~g~", "^2"):gsub("~y~", "^3"):gsub("~r~", "^1"):gsub("~p~", "^6"):gsub("~q~", "^9")
    local selectedTag = selectedTag:gsub('~b~', "^4"):gsub('~y~', "^3"):gsub('~r~', "^1"):gsub('~p~', "^6"):gsub('~o~', "^1"):gsub('~s~', ""):gsub('~w~', "^0"):gsub("~l~", ""):gsub("~q~", "^9"):gsub("~u~", "~l~")
    if string.find(args2[1], "/") then
        local cmd = args2[1]
        table.remove(args2, 1)
    else
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-message ooc"><b><span style="color: #7d7d7d">^0{1} <br>{2} [{0}]:</span>&nbsp;<span style="font-size: 14px; color: #7d7d7d";"></span></b>{3}<div style="margin-top: 5px; font-weight: 300;"></div></div>',
            args = { serverId, selectedTag, name, coloredMsg }
        })
    end
end)

RegisterNetEvent("danboi:chatag:setTag")
AddEventHandler("danboi:chatag:setTag", function(selectedTag)
    local source = source
    if prefixes[source] then
        local index = nil
        for i, tag in ipairs(prefixes[source]) do
            if tag == selectedTag then
                index = i
                break
            end
        end
        if index then
            roleTracker[source] = prefixes[source][index]
			if TagConfig.tag_hud.enabled then
				TriggerClientEvent('danboi:chatag:SetToHUD', source, prefixes[source][index])
			end
			SendNoti(source, ("Your Tag has been changed to: " .. prefixes[source][index]):gsub("[%|%d]", ""), "success")        
            TriggerClientEvent('danboi:chatag:SelectedTag', source, prefixes[source][index])
        end
    end
end)

RegisterCommand(TagConfig.command.command, function(source, args, rawCommand)
    local tags = prefixes[source]
    if tags ~= nil then
        local tagData = {}
        for i, tag in ipairs(tags) do
            table.insert(tagData, { id = i, tag = tag })
        end
        TriggerClientEvent("danboi:Chatags:receiveData", source, tagData)
    else
        SendNoti(source, "No Chat-Tags", "error")
    end
end, false)    

AddEventHandler('playerDropped', function(reason)
    activeTagTracker[source] = nil
    prefixes[source] = nil
end)

RegisterNetEvent('Chatags:Server:GetTag')
AddEventHandler('Chatags:Server:GetTag', function()
    local src = source
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
        end
    end
    local roleAccess = {}
    local defaultRole = roleList[1][2]
    if identifierDiscord then
        local roleIDs = exports.Badger_Discord_API:GetDiscordRoles(src)
        if roleIDs then
            table.insert(roleAccess, defaultRole)
            activeTagTracker[src] = roleAccess[1]
            for i = 1, #roleList do
                for j = 1, #roleIDs do
                    if exports.Badger_Discord_API:CheckEqual(roleList[i][1], roleIDs[j]) then
                        local roleGive = roleList[i][2]
                        table.insert(roleAccess, roleGive)
                        activeTagTracker[src] = roleGive
                    end
                end
            end
            prefixes[src] = roleAccess
        else
            table.insert(roleAccess, defaultRole)
            prefixes[src] = roleAccess
            activeTagTracker[src] = roleAccess[1]
        end
    else
        table.insert(roleAccess, defaultRole)
        prefixes[src] = roleAccess
        activeTagTracker[src] = roleAccess[1]
    end
end)

---------------
-- Functions
---------------

function SendNoti(recipient, message, type)
    if TagConfig.notify_settings.type == 0 then 
        if type == "success" then 
            local type = "SYSTEM"
            local message = "~g~[" .. type .. "] ~w~" .. message
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div class="chat-message ooc"><b><span style="color: #7d7d7d">{1}: </span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;"></span></b><div style="margin-top: 5px; font-weight: 300;"></div></div>',
                args = { recipient, message }
            })
        elseif type == "error" then 
            local type = "SYSTEM"
            local message = "~r~[" .. type .. "] ~w~" .. message
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div class="chat-message ooc"><b><span style="color: #7d7d7d">{1}: </span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;"></span></b><div style="margin-top: 5px; font-weight: 300;"></div></div>',
                args = { recipient, message }
            })
        end
    elseif TagConfig.notify_settings.type == 1 then 
        if type == "success" then 
            local coloredMsg = message:gsub("~b~", ""):gsub("~g~", ""):gsub("~y~", ""):gsub("~r~", ""):gsub("~p~", ""):gsub("~q~", ""):gsub("~w~", "")
            TriggerClientEvent('okokNotify:Alert', recipient, 'SUCCESS', coloredMsg, 8000, 'success', true)
        elseif type == "error" then 
            TriggerClientEvent('okokNotify:Alert', recipient, 'ERROR', coloredMsg, 8000, 'error', true)
        end
    elseif TagConfig.notify_settings.type == 2 then 
        if type == "success" then 
            local coloredMsg = message:gsub("~b~", ""):gsub("~g~", ""):gsub("~y~", ""):gsub("~r~", ""):gsub("~p~", ""):gsub("~q~", ""):gsub("~w~", "")
            TriggerClientEvent('codem-notification', recipient,  coloredMsg, 8000, 'check', options)
        elseif type == "error" then 
            TriggerClientEvent('codem-notification', recipient,  coloredMsg, 8000, 'error', options)
        end
    elseif TagConfig.notify_settings.type == 3 then 
        if type == "success" then 
            local coloredMsg = message:gsub("~b~", ""):gsub("~g~", ""):gsub("~y~", ""):gsub("~r~", ""):gsub("~p~", ""):gsub("~q~", ""):gsub("~w~", "")
            TriggerClientEvent('mythic_notify:client:SendAlert', recipient, { type = 'success', text = coloredMsg, style = { ['background-color'] = '#000000', ['color'] = '#ffff' } })
        elseif type == "error" then 
            TriggerClientEvent('mythic_notify:client:SendAlert', recipient, { type = 'error', text = coloredMsg, style = { ['background-color'] = '#000000', ['color'] = '#ffff' } })
        end
    elseif TagConfig.notify_settings.type == 4 then 
        if type == "success" then 
        local coloredMsg = message:gsub("~b~", ""):gsub("~g~", ""):gsub("~y~", ""):gsub("~r~", ""):gsub("~p~", ""):gsub("~q~", ""):gsub("~w~", "")
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'AtlasDevLabs',
            description = coloredMsg,
            type = 'success',
            position = 'center-right'
        })
        elseif type == "error" then 
        local coloredMsg = message:gsub("~b~", ""):gsub("~g~", ""):gsub("~y~", ""):gsub("~r~", ""):gsub("~p~", ""):gsub("~q~", ""):gsub("~w~", "")
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'AtlasDevLabs',
                description = coloredMsg,
                type = 'error',
                position = 'center-right'
            })
        end
    end
end

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    local i = 1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

---------------
-- END
---------------