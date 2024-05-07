Config = {
	--[[
    List in order of least priority to highest with 
    highest priority overtaking role before it if 
    they have that discord role.
	]]--
	roleList = { 
		{0, '^0^*Member | '},
		{0, '^9^*Server Boostesr ^0^*| '},
		{0, '^9^*Server Donator ^0^*| '},
		{0, '^4^*Law Enforcement^0^*| '},
		{0, '^6^*Dev Team ^0^*| '},
		{0, '^6^*Staff Team ^0^*| '},
		{0, '^6^*Management ^0^*| '},
		{0, '^4^*Owner ^0^*| '} -- done
		-- change 0's to the role ids you have configured in Badger_Discord_API for each role. if you want a default role everyone has (i.e member) use 0
	},	
	useTagMenuImage = true,
	TagMenuImage = 'https://cdn.discordapp.com/attachments/1161069645827166304/1227568064170819676/tumblr_68144a71c3035f7dc7aa8aafa9d21e78_fd150a88_2048.gif?ex=6628e0d9&is=66166bd9&hm=3b2da5214ba65c7db3aec1850a231661773ec12d35b5397ee29cbed3598e770d&', -- [Custom banner IMGUR or GIPHY URLs go here (Includes Discord Image URLS) ]
	playerNameTitle = false,
	TagMenuTitle = "", -- only work if [ playerNameTitle ] is set to false
	MenuPos = {
		x = 1450,
		y = 200
	},
	command = {
		command = 'chattag',
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
		defaultText = "~t~Chat-Tag: \n~w~{CHATAG}",
	} 
}