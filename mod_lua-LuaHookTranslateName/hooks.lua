require 'apache2'
require 'string'

-- docs were moved from /old-location to /new except README,
-- which was moved from /old-location/README to /README
function old_to_new(r)
  r:info("got " .. r.uri)
  if r.uri:match("^/old%-location") then
    if r.uri == "/old-location/README" then
      -- not under /new
      -- could be done also via r.uri = /README
      r.filename = r.document_root .. '/README'
      r:info("pointing /old-location/README to " .. r.filename);
      return apache2.OK
    else
      new_uri = r.uri:gsub("^/old%-location", "/new")
      r:info("rewriting " .. r.uri .. " to " .. new_uri);
      r.uri = new_uri 
      return apache2.DECLINED
    end
  end
  return apache2.DECLINED
end
