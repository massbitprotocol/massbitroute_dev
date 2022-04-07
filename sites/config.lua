local _config = {
    modules = [[
      load_module _GBC_CORE_ROOT_/bin/openresty/nginx/modules/ngx_http_link_func_module.so;
      load_module _GBC_CORE_ROOT_/bin/openresty/nginx/modules/ngx_http_geoip2_module.so;
      load_module _GBC_CORE_ROOT_/bin/openresty/nginx/modules/ngx_stream_geoip2_module.so;
      load_module _GBC_CORE_ROOT_/bin/openresty/nginx/modules/ngx_http_vhost_traffic_status_module.so;
      load_module _GBC_CORE_ROOT_/bin/openresty/nginx/modules/ngx_http_stream_server_traffic_status_module.so;
      load_module _GBC_CORE_ROOT_/bin/openresty/nginx/modules/ngx_stream_server_traffic_status_module.so;
	]],
    lua_package_path = [[_GBC_CORE_ROOT_/gbc/src/?.lua;]],
    lua_package_cpath = [[_GBC_CORE_ROOT_/gbc/src/?.so;]],
    sites = {
        service_api = {
            disabled = false,
            -- package_path = [[_SITE_ROOT_/src/?.lua]],
            -- package_cpath = [[_SITE_ROOT_/src/?.so]],
            path = "services/api",
            maininit = [[
            env BIND_ADDRESS;
         ]],
            httpinit = [[
            resolver 8.8.8.8 ipv6=off;
            variables_hash_bucket_size 512;
            #ssl
            lua_shared_dict auto_ssl 1m;
            lua_shared_dict auto_ssl_settings 64k;

            #lua
            lua_capture_error_log 32m;
            #lua_need_request_body on;
            lua_regex_match_limit 1500;
            lua_check_client_abort on;
            lua_socket_log_errors off;
            lua_shared_dict _GBC_ 1024k;
            lua_code_cache on;
        ]],
            luainit = [[
	   require("framework.init")
	   local appKeys = dofile("_GBC_CORE_ROOT_/tmp/app_keys.lua")
	   local globalConfig = dofile("_GBC_CORE_ROOT_/tmp/config.lua")
	   cc.DEBUG = globalConfig.DEBUG
	   local gbc = cc.import("#gbc")
	   cc.exports.nginxBootstrap = gbc.NginxBootstrap:new(appKeys, globalConfig)
        ]],
            luawinit = [[

        ]]
        },
        services_git = {
            disabled = false,
            path = "services/git"
        },
        services_gwman = {
            disabled = false,
            path = "services/gwman"
        },
        services_stat = {
            disabled = false,
            path = "services/stat"
        },
        services_session = {
            disabled = false,
            path = "services/session"
        },
        services_monitor = {
            disabled = false,
            path = "services/monitor"
        },
        services_gateway = {
            disabled = true,
            path = "services/gateway"
        },
        services_node = {
            disabled = true,
            path = "services/node"
        }
    },
    supervisor = [[

]]
}
return _config
