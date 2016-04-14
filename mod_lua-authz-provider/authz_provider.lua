-- http://httpd.apache.org/docs/current/mod/mod_lua.html#writingauthzproviders
-- The following authz provider function takes two arguments, one 
-- ip address and one user name. It will allow access from the given 
-- ip address without authentication, or if the authenticated user 
-- matches the second argument.
require 'apache2'

function authz_check_foo(r, ip, user)
    if r.useragent_ip == ip then
        return apache2.AUTHZ_GRANTED
    elseif r.user == nil then
        return apache2.AUTHZ_DENIED_NO_USER
    elseif r.user == user then
        return apache2.AUTHZ_GRANTED
    else
        return apache2.AUTHZ_DENIED
    end
end
