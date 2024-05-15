fx_version 'cerulean'
game 'gta5'
author 'JaredScar - Edited by AtlasDevLabs'
description 'an Edited Verison of DiscordChatRoles'
lua54 'yes'

files {
    'web/*.*'
}

shared_script 'config.lua'

client_scripts {
    'dependancy/NativeUI.lua', 
    'hud.lua', 
    'client.lua'
}

server_scripts {
    'server.lua'
}

