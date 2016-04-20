require 'apache2'
require 'string'

-- http://www.modlua.org/hooks/quick

function server_in_maintenance(r)
    if r.uri == "/administration" then
      r.uri = "/administration/"
    end

    if r.uri == "/administration/" and r.useragent_ip == "127.0.0.1" then
        -- we don't care about this URL, give another module a chance
        return apache2.DECLINED
    end
    r.content_type = "text/html"
    r:puts(r.uri .. ": this site is currently down to maintenance, try later again\n")
    return apache2.DONE
end
