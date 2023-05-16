fx_version 'cerulean'
game 'gta5'

description 'moon-helis'
version '1.0.0'

server_scripts {
    'server.lua',
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'config.lua',
    'client.lua',
}

shared_scripts {
    'shared.lua',
    '@ox_lib/init.lua',
} 

lua54 'yes'