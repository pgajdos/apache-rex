-- http://www.modlua.org/hooks/access
function localhost_only(r)
  if r.useragent_ip == '127.0.0.1' then
    r:info("access checker: allowed for " .. r.useragent_ip)
    return apache2.OK
  end
    
  r:info("access_checker: forbidden for " .. r.useragent_ip)
  return 403
end

