fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_script'client-side/*'
server_script 'server-side/*'

shared_scripts {
	'@vrp/config/Global.lua',
	'@vrp/lib/Utils.lua',
	'shared-side/*'
}

files { 'web-side/**/*' }
ui_page 'web-side/index.html'