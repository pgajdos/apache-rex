#include "httpd.h"
#include "http_core.h"
#include "http_protocol.h"
#include "http_request.h"

static void register_hooks(apr_pool_t *pool);
static int handler(request_rec *r);

module AP_MODULE_DECLARE_DATA   print_headers_module =
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

static int handler(request_rec *r)
{
    if (!r->handler || strcmp(r->handler, "print-headers")) return (DECLINED);

    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    const apr_array_header_t    *fields;
    int                         i;
    apr_table_entry_t           *e = 0;
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

    fields = apr_table_elts(r->headers_in);
    e = (apr_table_entry_t *) fields->elts;
    for(i = 0; i < fields->nelts; i++) {
        ap_rprintf(r, "%s: %s\n", e[i].key, e[i].val);
    }
    return OK;    
}
