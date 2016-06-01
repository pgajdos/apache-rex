-- https://httpd.apache.org/docs/trunk/mod/mod_lua.html#writinghandlers
-- example handler

require 'apache2'
require 'string'

--[[
     This is the default method name for Lua handlers, see the optional
     function-name in the LuaMapHandler directive to choose a different
     entry point.
--]]
function handle(r)
    r.content_type = "text/plain"

    r:puts(("Hello Lua World!\n"):lower())

    return apache2.OK
end
