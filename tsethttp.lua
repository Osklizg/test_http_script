local log = require('log')
local console = require('console')
local server = require('http.server')

local HOST = 'localhost'
local PORT = 8008

box.cfg {
log_level = 5,
slab_alloc_arena = 0.1,
}
console.listen('172.27.27.85:33013')

if not box.space.users then
     s = box.schema.space.create('users')
	    s:create_index('primary',
		   {type = 'tree', parts == {1, 'NUM'}})
end

function handler(self)
    local id = self:cookie('tarantool_id')
	local ip = self.peer.host
	local data = ''
	log.info('Users id = %s', id)
	if not id then
	     data = 'Welcome to tarantool server!'
		 box.space.users:auto_increment({ip})
		 id = box.space.users:len()
		 return self:render({ text = data}):
		        setcookie({ name = 'tarantool_id', value = id, expires = '+1y' })
	else
	     local count = box.space.users:len()
		 data = 'You id is ' .. id .. '. We have' .. cont .. ' users'
		 return self:render({ text = data })
	end
end

httpd = server.new(HOST, PORT)
httpd:route({ path = '/' }, handler)
httpd:start()
