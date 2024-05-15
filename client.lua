local tagsMenu
local tagData = {}

_menuPool = NativeUI.CreatePool()

local function CreateTagMenu()
    local menuTitle = TagConfig.playerNameTitle and playerName or TagConfig.TagMenuTitle
    tagsMenu = NativeUI.CreateMenu(menuTitle, "Select a Tag", TagConfig.MenuPos.x, TagConfig.MenuPos.y)
    if TagConfig.useTagMenuImage then
        local RuntimeTXD = CreateRuntimeTxd('Custom_Menu_Head3')
        local Object = CreateDui(TagConfig.TagMenuImage, 512, 128)
        local TextureThing = GetDuiHandle(Object)
        local Texture = CreateRuntimeTextureFromDuiHandle(RuntimeTXD, 'Custom_Menu_Head3', TextureThing)
        local background = Sprite.New("Custom_Menu_Head3", "Custom_Menu_Head3", 0, 0, 512, 128)
        tagsMenu:SetBannerSprite(background, true)
    end
    _menuPool:Add(tagsMenu)
end

local function RefreshTagsMenu()
    tagsMenu:Clear()
    for _, data in ipairs(tagData) do
        local tagItemText = "[" .. data.id .. "] " .. data.tag:gsub("[%|%d]", "")
		local tagItem = NativeUI.CreateItem(tagItemText, "Select a Tag: " .. data.tag:gsub("[%|%d]", ""))		
        tagsMenu:AddItem(tagItem)
    end
    tagsMenu.OnItemSelect = function(sender, item, index)
        local selectedTag = tagData[index].tag
        TriggerServerEvent("danboi:chatag:setTag", selectedTag)
    end
    tagsMenu:Visible(true)
end

RegisterNetEvent("danboi:Chatags:receiveData")
AddEventHandler("danboi:Chatags:receiveData", function(receivedTagData)
    tagData = receivedTagData or {}
    if #tagData > 0 then
        RefreshTagsMenu()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
    end
end)

Citizen.CreateThread(function()
    Wait(1000)
    CreateTagMenu()
    TriggerServerEvent('Chatags:Server:GetTag')
end)
