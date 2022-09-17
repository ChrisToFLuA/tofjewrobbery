fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

name         'tofjewrobbery'
version      '1.0.1'
description  'Jewels Robbery system'
author       'ChrisToF29380'
repository   'https://github.com/ChrisToFLuA/tofjewrobbery'

dependency 'ox_lib'

shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua'
}

server_scripts {
	'config.lua',
	'server/*.lua'
}

client_scripts {
	'config.lua',
	'client/*.lua'
}

files{
    'locales/*.json'
}

