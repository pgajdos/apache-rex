function c_content_type(r)
  if r.filename:match(".c$") then
    r:info(("setting content_type text/x-c for %s"):format(r.filename))
    r.content_type = "text/x-c"
  end
  return apache2.OK
end

function c_to_html(r)
  r:info(("c_to_html: called for [%s] content-type"):format(r.content_type))

  -- this could also be done via checking r.filename directly
  if not r.content_type or not r.content_type:match("text/x%-c") then
    return
  end

  coroutine.yield(("<h1>C source %s</h1>\n<pre>\n"):format(r.uri:gsub(".*/", ""))) 

  while bucket do
    local output = r:escape_html(bucket)
    coroutine.yield(output)
  end

  coroutine.yield("</pre>\n")
end

