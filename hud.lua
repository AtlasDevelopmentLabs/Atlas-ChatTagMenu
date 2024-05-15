function txtHead(x, y, width, height, scale, text)
    SetTextFont(6)
    SetTextProportional(false)
    SetTextCentre(true)
    SetTextScale(scale, scale)
    SetTextDropShadow()
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width / 2, y - height / 2 + 0.005)
end

RegisterNetEvent("danboi:chatag:SetToHUD")
AddEventHandler("danboi:chatag:SetToHUD", function (chatag)
    chatag = tostring(chatag) or "~b~None set"
    if chatag == " " or chatag == "" then
        chatag = "~b~None"
    end
    chatag = chatag:gsub("[%^*|%d]", "") 
    playerChatTag = chatag
end)

playerChatTag = "None Set";
function setplayerChatTagGui(value)
 	playerChatTag = value
end

Citizen.CreateThread(function()
	Wait(800);
	while true do 
		Wait(0);
		local enabled = TagConfig.tag_hud.enabled;
		if enabled then 
			local disp = TagConfig.tag_hud.defaultText;
			local scale = TagConfig.tag_hud.fontSize;
			local x = TagConfig.tag_hud.x;
			local y = TagConfig.tag_hud.y;
			if (disp:find("{CHATAG}")) then 
				disp = disp:gsub("{CHATAG}", playerChatTag);
			end 
			txtHead(x, y, 1.0, 1.0, scale, disp);
		end
	end
end)
