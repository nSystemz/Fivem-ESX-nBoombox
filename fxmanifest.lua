fx_version 'cerulean'
games {'gta5'}

author 'Nemesus.de'
description 'Adds an boombox to the ESX Framework'
contact 'info@nemesus.de'
version '1.0'

dependencies {
	"es_extended",
	"xsound"
}

server_scripts {
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'locales/de.lua',
	'locales/en.lua',
	'client/main.lua'
}