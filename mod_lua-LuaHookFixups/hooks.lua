require 'apache2'
require 'string'

function language_document(r)
  local uri = r.uri

  language = r.headers_in['Accept-Language']
  if not language then
    language = "en"
  end

  uri = uri:gsub("%.(%w+)$", "." .. language .. ".%1")

  return r.document_root .. uri
end

function translate_name_hook(r)
  local filename = language_document(r)

  if r:stat(filename) then
    r.filename = filename
    r:info(("translate %s -> %s"):format(r.uri, r.filename))
    return apache2.OK
  else
    -- give others a chance
    return apache2.DECLINED
  end
end

-- wrongly assigns value to r.filename
function evil_hook(r)
  r.filename = r.document_root .. r.uri
  r:info(("wrongly translate %s -> %s"):format(r.uri, r.filename))
  return apache2.OK
end

-- ensure that filename is set as we intended 
function fixups_hook(r)
  local filename = language_document(r)

  r:info("in fixups " .. filename .. " " .. r.filename)
  if r:stat(filename) and filename ~= r.filename then
    r:warn(("translate again (%s -> %s), there is some wrong module"):format(r.filename, filename))
  end
  r.filename = filename
  --  r.filename = filename
  return apache2.OK
end

