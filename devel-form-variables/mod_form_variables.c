#include "httpd.h"
#include "http_core.h"
#include "http_protocol.h"
#include "http_request.h"
#include "apr_strings.h"

typedef struct {
    const char *key;
    const char *value;
} keyValuePair;

static void register_hooks(apr_pool_t *pool);
static int handler(request_rec *r);

module AP_MODULE_DECLARE_DATA   form_variables_module =
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

keyValuePair *readPost(request_rec *r) {
    apr_array_header_t *pairs = NULL;
    apr_off_t len;
    apr_size_t size;
    int res;
    int i = 0;
    char *buffer;
    keyValuePair *kvp;

    res = ap_parse_form_data(r, NULL, &pairs, -1, HUGE_STRING_LEN);
    if (res != OK || !pairs) return NULL; /* Return NULL if we failed or if there are is no POST data */
    kvp = apr_pcalloc(r->pool, sizeof(keyValuePair) * (pairs->nelts + 1));
    while (pairs && !apr_is_empty_array(pairs)) {
        ap_form_pair_t *pair = (ap_form_pair_t *) apr_array_pop(pairs);
        apr_brigade_length(pair->value, 1, &len);
        size = (apr_size_t) len;
        buffer = apr_palloc(r->pool, size + 1);
        apr_brigade_flatten(pair->value, buffer, &size);
        buffer[len] = 0;
        kvp[i].key = apr_pstrdup(r->pool, pair->name);
        if (!kvp[i].key) kvp[i].key = "";
        kvp[i].value = buffer;
        if (!kvp[i].value) kvp[i].value = "";
        i++;
    }
    kvp[i].key = NULL;
    return kvp;
}

static int handler(request_rec *r)
{
    if (!r->handler || strcmp(r->handler, "form-variables")) return (DECLINED);

    /*~~~~~~~~~~~~~~~~~~~~~~*/
    keyValuePair *formData;
    /*~~~~~~~~~~~~~~~~~~~~~~*/

    formData = readPost(r);
    if (formData) {
        int i = 0;
        while (formData[i].key) {
            ap_rprintf(r, "[%s=%s] ", formData[i].key, formData[i].value);     
            i++;
        }
        ap_rputs("\n", r);
    }

    return OK;    
}
