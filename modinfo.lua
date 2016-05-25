-- This information tells other players more about the mod
name = "Mod Character Rebalancing 2"
id = "mod.character.rebalancing.2"
description = ""
author = "DrSmugleaf"
version = "1.0.0"

priority = -100

-- This is the URL name of the mod's thread on the forum; the part after the ? and before the first & in the url
forumthread = ""

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = true
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {"mod character rebalancing","mod character rebalancing 2","mcr","mcr2"}

configuration_options =	{
	{
		name = "ACE_BALANCED",
		label = "Ace(P)",
		hover = "By Silh. Latest supported version: 1.1.16",
		options = 	{
						{description = "Balanced", data = true},
						{description = "Ignored", data = false},
					},
		default = true,
	},
	{
		name = "SDABIGAIL_BALANCED",
		label = "Abigail(Stardew)",
		hover = "By Silhh and Arcade. Latest supported version: 1.2.1",
		options = 	{
						{description = "Balanced", data = true},
						{description = "Ignored", data = false},
					},
		default = true,
	},
	{
		name = "LUFFY_BALANCED",
		label = "Luffy(OS 4.0)",
		hover = "By Silhh and Arcade. Latest supported version: 1.2.1",
		options = 	{
						{description = "Balanced", data = true},
						{description = "Ignored", data = false},
					},
		default = true,
	},
	{
		name = "RIN_BALANCED",
		label = "Tohsaka Rin(P)",
		hover = "By Silh and Arcade. Latest supported version: 1.3.5",
		options = 	{
						{description = "Balanced", data = true},
						{description = "Ignored", data = false},
					},
		default = true,
	},
	{
		name = "SABER_BALANCED",
		label = "Saber(P)",
		hover = "By Silh. Latest supported version: 1.2.4",
		options = 	{
						{description = "Balanced", data = true},
						{description = "Ignored", data = false},
					},
		default = true,
	},
		{
		name = "SAKURA_BALANCED",
		label = "(Dark)Sakura Matou(P)",
		hover = "By Silh and Arcade. Latest supported version: 1.3.9",
		options = 	{
						{description = "Balanced", data = true},
						{description = "Ignored", data = false},
					},
		default = true,
	},
	{
		name = "TAMAMO_BALANCED",
		label = "Tamamo(OS 4.0)",
		hover = "By Silhh and Arcade. Latest supported version: 1.3.5",
		options = 	{
						{description = "Balanced", data = true},
						{description = "Ignored", data = false},
					},
		default = true,
	},
	{
		name = "ZORO_BALANCED",
		label = "Zoro(P)",
		hover = "By Silh and Arcade. Latest supported version: 1.1.19",
		options = 	{
						{description = "Balanced", data = true},
						{description = "Ignored", data = false},
					},
		default = true,
	},
}
