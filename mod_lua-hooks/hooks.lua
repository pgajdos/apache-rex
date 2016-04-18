function quick_handler(r)
  local logname = r.document_root .. "/hook_log"
  local f = io.open(logname, "a")
  if f then
    f:write(r.uri .. ": hello from quick handler\n")
    f:close()
  end
  return apache2.DECLINED
end

function hook_translate_name(r)
  local logname = r.document_root .. "/hook_log"
  local f = io.open(logname, "a")
  if f then
    f:write(r.uri .. ": hello from translate name hook\n")
    f:close()
  end
  return apache2.DECLINED
end

function hook_map_to_storage(r)
  local logname = r.document_root .. "/hook_log"
  local f = io.open(logname, "a")
  if f then
    f:write(r.uri .. ": hello from map to storage hook\n")
    f:close()
  end
  return apache2.DECLINED
end

function hook_access_checker(r)
  local logname = r.document_root .. "/hook_log"
  local f = io.open(logname, "a")
  if f then
    f:write(r.uri .. ": hello from access checker hook\n")
    f:close()
  end
  return apache2.DECLINED
end

function hook_check_user_id(r)
  local logname = r.document_root .. "/hook_log"
  local f = io.open(logname, "a")
  if f then
    f:write(r.uri .. ": hello from check user id hook\n")
    f:close()
  end
  return apache2.DECLINED
end

function hook_auth_checker(r)
  local logname = r.document_root .. "/hook_log"
  local f = io.open(logname, "a")
  if f then
    f:write(r.uri .. ": hello from auth checker hook\n")
    f:close()
  end
  return apache2.DECLINED
end

function hook_type_checker(r)
  local logname = r.document_root .. "/hook_log"
  local f = io.open(logname, "a")
  if f then
    f:write(r.uri .. ": hello from type checker hook\n")
    f:close()
  end
  return apache2.DECLINED
end

function hook_fixups(r)
  local logname = r.document_root .. "/hook_log"
  local f = io.open(logname, "a")
  if f then
    f:write(r.uri .. ": hello from fixups hook\n")
    f:close()
  end
  return apache2.DECLINED
end

function map_handler(r)
  local logname = r.document_root .. "/hook_log"
  local f = io.open(logname, "a")
  if f then
    f:write(r.uri .. ": hello from map handler\n")
    f:close()
  end
  return apache2.DECLINED
end

function hook_log(r)
  local logname = r.document_root .. "/hook_log"
  local f = io.open(logname, "a")
  if f then
    f:write(r.uri .. ": hello from log hook\n")
    f:close()
  end
  return apache2.DECLINED
end

