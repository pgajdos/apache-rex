function log_refuse_private(r)
    if r.uri:match("/private_area/") then
        return apache2.DONE -- skip the actual logging, this is secret!
    else
        return apache2.DECLINED -- pass the buck to the other logging handlers
    end
end
