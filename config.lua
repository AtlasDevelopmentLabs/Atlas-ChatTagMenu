--------------------------------
-- [Main Config]

TagConfig = {
    roleList = {
        {0, '~w~Member | '},
        {1, '~g~Server Booster ~w~|'},
        {1, '~p~Dev Team ~w~|'},
        {1, '~b~Staff Team ~w~|'},
        {1, '~q~Management ~w~|'},
        {1, '~y~Owner ~w~|'}
    },    
    useTagMenuImage = true,
    TagMenuImage = 'https://cdn.discordapp.com/attachments/1161069645827166304/1227568064170819676/tumblr_68144a71c3035f7dc7aa8aafa9d21e78_fd150a88_2048.gif?ex=6628e0d9&is=66166bd9&hm=3b2da5214ba65c7db3aec1850a231661773ec12d35b5397ee29cbed3598e770d&', -- [Custom banner IMGUR or GIPHY URLs go here (Includes Discord Image URLS) ]
    playerNameTitle = false,
    TagMenuTitle = "", -- only works if [playerNameTitle] is set to false
    MenuPos = {
        x = 1450,
        y = 200
    },
    command = {
        command = 'chatag'
    },
    notify_settings = {
        duration = 8000,
        type = 4
    },
    tag_hud = {
        enabled = true,
        x = 1.44,
        y = 0.55,
        fontSize = 0.39,
        defaultText = "~t~Chat-Tag: \n~w~{CHATAG}"
    }
}