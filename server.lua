local roleList = Config.roleList
local roleTracker = {}
local prefixes = {}
activeTagTracker = {}

function SendNoti(recipient, message, type)
    if Config.notify_settings.type == 0 then 
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
    elseif Config.notify_settings.type == 1 then 
        if type == "success" then 
            TriggerClientEvent('okokNotify:Alert', recipient, 'SUCCESS', message, 8000, 'success', true)
        elseif type == "error" then 
            TriggerClientEvent('okokNotify:Alert', recipient, 'ERROR', message, 8000, 'error', true)
        end
    elseif Config.notify_settings.type == 2 then 
        if type == "success" then 
            TriggerClientEvent('codem-notification', recipient, message, 8000, 'check', options)
        elseif type == "error" then 
            TriggerClientEvent('codem-notification', recipient, message, 8000, 'error', options)
        end
    elseif Config.notify_settings.type == 3 then 
        if type == "success" then 
            TriggerClientEvent('mythic_notify:client:SendAlert', recipient, { type = 'success', text = message, style = { ['background-color'] = '#000000', ['color'] = '#ffff' } })
        elseif type == "error" then 
            TriggerClientEvent('mythic_notify:client:SendAlert', recipient, { type = 'error', text = message, style = { ['background-color'] = '#000000', ['color'] = '#ffff' } })
        end
    elseif Config.notify_settings.type == 4 then 
        if type == "success" then 
        TriggerClientEvent('ox_lib:notify', -1, {
            title = 'AtlasDevLabs',
            description = message,
            type = 'success',
            position = 'center-right'
        })
        elseif type == "error" then 
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'AtlasDevLabs',
                description = 'No Chat-Tags',
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

AddEventHandler('chatMessage', function(source, name, msg)
    local args = stringsplit(msg)
    CancelEvent()
    local serverId = source
    local selectedTag = roleTracker[source] or roleList[1][2]
    local args2 = stringsplit(msg, " ")
    if string.find(args2[1], "/") then
    local cmd = args2[1]
    table.remove(args2, 1)
    else
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message ooc"><b><span style="color: #7d7d7d">[OOC] {1} {2} [{0}]:</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;"></span></b>{3}<div style="margin-top: 5px; font-weight: 300;"></div></div>',
        args = { serverId, selectedTag, name, msg }
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
			if Config.tag_hud.enabled then
				TriggerClientEvent('danboi:chatag:SetToHUD', source, prefixes[source][index])
			end
			SendNoti(source, ("Your Tag has been changed to: " .. prefixes[source][index]):gsub("[%^*|%d]", ""), "success")        
            TriggerClientEvent('danboi:chatag:SelectedTag', source, prefixes[source][index])
        end
    end
end)

RegisterCommand(Config.command.command, function(source, args, rawCommand)
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