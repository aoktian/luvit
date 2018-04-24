--[[

Copyright 2014 The Luvit Authors. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS-IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

--]]

-- Create a luvit powered main that does the luvit CLI interface

local uv = require('uv')
local luvi = require('luvi')
print('luvi version: ' .. luvi.version)
for k, v in pairs(luvi.options) do
    print(k .. ' version: ' .. tostring(v))
end

package.path = "./share/?.lua;./share/?/init.lua"
package.cpath = "./lib/?.so"

local utils = require('utils')
_G.p = utils.prettyPrint

-- Inject the global process table
_G.process = require('process').globalProcess()

-- Seed Lua's RNG
local math = require('math')
math.randomseed(os.time())

-- Load Resolver
local dns = require('dns')
dns.loadResolver()

local success, err = xpcall(function ()
    -- Call the main app
    p("app args:", args)

    local app = args[1]
    if app then
        table.remove(args, 1)
        dofile(app)
    end

    -- Start the event loop
    uv.run()
end, debug.traceback)

if success then
    -- Allow actions to run at process exit.
    require('hooks'):emit('process.exit')
    uv.run()
else
    _G.process.exitCode = -1
    require('pretty-print').stderr:write("Uncaught exception:\n" .. err .. "\n")
end

-- When the loop exits, close all unclosed uv handles (flushing any streams found).
uv.walk(function (handle)
    if handle then
        local function close()
            if not handle:is_closing() then handle:close() end
        end
        if handle.shutdown then
            handle:shutdown(close)
        else
            close()
        end
    end
end)
uv.run()

-- Send the exitCode to luvi to return from C's main.
return _G.process.exitCode
