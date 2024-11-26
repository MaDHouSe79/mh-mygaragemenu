fx_version 'cerulean'
game 'gta5'

author 'MaDHouSe'
description 'MH My Garage Menu'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua', -- change en to your language
    'config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/update.lua',
}

lua54 'yes'
