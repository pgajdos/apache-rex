#include "httpd.h"
#include "http_core.h"
#include "http_protocol.h"
#include "http_request.h"

static void register_hooks(apr_pool_t *pool);
static int handler(request_rec *r);

module AP_MODULE_DECLARE_DATA   read_request_body_module =
{
    STANDARD20_MODULE_STUFF,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    register_hooks   
};


static void register_hooks(apr_pool_t *pool) 
{
    ap_hook_handler(handler, NULL, NULL, APR_HOOK_LAST);
}

static int util_read(request_rec *r, const char **rbuf, apr_off_t *size)
{
    /*~~~~~~~~*/
    int rc = OK;
    /*~~~~~~~~*/

    if((rc = ap_setup_client_block(r, REQUEST_CHUNKED_ERROR))) {
        return(rc);
    }

    if(ap_should_client_block(r)) {

        /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
        char         argsbuffer[HUGE_STRING_LEN];
        apr_off_t    rsize, len_read, rpos = 0;
        apr_off_t length = r->remaining;
        /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

        *rbuf = (const char *) apr_pcalloc(r->pool, (apr_size_t) (length + 1));
        *size = length;
        while((len_read = ap_get_client_block(r, argsbuffer, sizeof(argsbuffer))) > 0) {
            if((rpos + len_read) > length) {
                rsize = length - rpos;
            }
            else {
                rsize = len_read;
            }

            memcpy((char *) *rbuf + rpos, argsbuffer, (size_t) rsize);
            rpos += rsize;
        }
    }
    return(rc);
}

static int handler(request_rec *r)
{
    //if (!r->handler || strcmp(r->handler, "read-request-body")) return (DECLINED);

    /*~~~~~~~~~~~~~~~~*/
    apr_off_t   size;
    const char  *buffer;
    /*~~~~~~~~~~~~~~~~*/

    if(util_read(r, &buffer, &size) == OK) {
        ap_rprintf(r, "Read: %" APR_OFF_T_FMT " bytes\n", size);
        ap_rprintf(r, "%s\n", buffer);
    }

    return OK;    
}
