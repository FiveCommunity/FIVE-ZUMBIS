fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Seu Nome'
description 'Sistema de Zumbis com Recompensas para Elites'
version '1.0.0'

client_scripts {
    "@vrp/config/Native.lua",
    '@vrp/config/Item.lua',
    '@vrp/lib/Utils.lua',
    'client-side.lua'
}

server_scripts {
    '@vrp/config/Item.lua',
    '@vrp/lib/Utils.lua',
    'server-side.lua'
}

files {
    'stream/peds.meta'
}

data_file 'PED_METADATA_FILE' 'stream/peds.meta'