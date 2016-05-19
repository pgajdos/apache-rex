require "apache2"
require "io"
require "string"

function pangram_read(r)
   local locale = r.args:gsub("id=", "")
   local filename = r.document_root .. ("/pangrams/%s.txt"):format(locale)

   r:info(("reading %s"):format(filename))
   local file = io.open(filename, "r")
   if not file then
     return nil
   end

   local string = file:read("*all")
   file:close()
   return string
end

function orig(r)
   local string = pangram_read(r)
   if not string then
     r:puts("pangram not found this language\n")
     r.status = 404
     return apache2.OK
   end

   r.content_type = "text/plain"
   r:puts(string)
   r:info(("pangram: %s"):format(string))
   return apache2.OK
end

function to_lower(r)
   local string = pangram_read(r):lower()
   if not string then
     r:puts("pangram not found this language\n")
     r.status = 404
     return apache2.OK
   end

   r.content_type = "text/plain"
   r:puts(string)
   r:info(("pangram: %s"):format(string))
   return apache2.OK
end

function to_upper(r)
   local string = pangram_read(r):upper()
   if not string then
     r:puts("pangram not found this language\n")
     r.status = 404
     return apache2.OK
   end

   r.content_type = "text/plain"
   r:puts(string)
   r:info(("pangram: %s"):format(string))
   return apache2.OK
end
