require "io"
require "apache2"

function read_file(filename)
  local input = io.open(filename, "r")
  local data
  if input then
    data = input:read("*a")
    input:close()
  end
  return data
end

function write_file(filename, data)
  local input = io.open(filename, "w")
  if input then
    input:write(data)
    input:close()
  end
end

function check_cache(r)
  local cache_dir = r.subprocess_env["CACHE_DIR"]
  if cache_dir then

    if not r:stat(cache_dir) then
      r:mkrdir(cache_dir)
    end

    local cache_path = cache_dir .. r.uri:gsub("^/", ""):gsub("/", "_")
    r:debug(("check_cache: looking for %s cache file"):format(cache_path))

    local png_data = read_file(cache_path)
    if png_data then
      r:info("cache HIT: " .. cache_path)
    else
      png_data = read_file(r.filename)
      if png_data then
        r:info("cache MISS: " .. r.filename)
        write_file(cache_path, png_data)
      else
        r:debug(("check_cache: file %s does not exist"):format(r.filename))
      end
    end

    if png_data then -- if file exists, write it out
      r.status = 200
      r:write(png_data)
      r:debug(("sent data of %s to the client"):format(r.filename))
      return apache2.DONE -- skip default handler for PNG files
    end

  end

  return apache2.DECLINED
end

