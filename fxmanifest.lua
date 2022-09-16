fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

name         'toffleeca'
version      '1.0.0'
description  'Jewels Robbery system'
author       'ChrisToF29380'
repository   'https://github.com/ChrisToFLuA/tofjewrobbery'

shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua'
}

files{
    'locale/en.json'
}

server_scripts {
	'server/serverrobbery.lua'
}

client_scripts {
	'client/clientrobbery.lua',
}

