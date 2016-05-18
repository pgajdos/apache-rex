function fix_post_param(r)
    coroutine.yield() 
    r:info(("in fix_get_param %s"):format(bucket))
    while bucket do
        local output = bucket:gsub("old_parameter", "new_parameter"):gsub("k", "000")
        r:info(("bucket: [%s] changed to [%s]"):format(bucket, output))
        coroutine.yield(output)
    end
    coroutine.yield("&new_syntax=yes")
end
