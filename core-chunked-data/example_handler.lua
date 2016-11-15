require 'apache2'
require 'string'

function handle(r)
    r.content_type = "text/plain"

    r:info("hello from lua module");
    if r.method == 'POST' then
        for k, v in pairs( r:parsebody() ) do
            r:puts( string.format("%s: %s\n", k, v) )
        end
    else
        return 501
    end
    return apache2.OK
end
