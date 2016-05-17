require 'apache2'
require 'string'

-- for given language (Accept-Language) and html document
-- in the form name.ext, serve name.language.ext
function language_document(r)
  local uri = r.uri
  r:info("got " .. uri)

  local language = r.headers_in['Accept-Language']
  if language then
    r:info("requested language: " .. language)
  else
    language = "en"
  end

  uri = uri:gsub("%.(%w+)$", "." .. language .. ".%1")

  r.filename = r.document_root .. uri
  r:info("serving: " .. r.filename)
  
  if r:stat(r.filename) then
    return apache2.OK
  else
    -- give others a chance
    return apache2.DECLINED
  end
end

function set_language(r)
  local language = r.headers_in['Accept-Language']

  if language and r:stat(r.filename) then
    r.headers_out['Language'] = language
  end

  -- give others a chance
  return apache2.DECLINED
end

