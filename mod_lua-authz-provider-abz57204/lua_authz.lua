-- http://httpd.apache.org/docs/trunk/mod/mod_lua.html#comment_3245
require 'apache2'

function lua_authz(request, n)
  request:warn('lua_auth: request lua_authz ' .. n) 
  return apache2.AUTHZ_GRANTED 
end 
