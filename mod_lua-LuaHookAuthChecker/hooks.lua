require "apache2"
require "io"

function user_activity(r)
  if r.user then
    dir = r.filename:gsub("(.*/)[^/]*", "%1")
    activity_filename = dir .. r.user .. ".activity"
    r:info(r.user .. " hit a page in " .. dir)

    f = io.open(activity_filename, "a+")
    f:write("|")
    f:close()
  end

  return apache2.OK
end

