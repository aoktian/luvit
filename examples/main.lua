
_G.__ROOT_DIR = "examples"

local path = require("path")
local fs = require("fs")
fs.readdir(__ROOT_DIR, function (err, files)
    if err then
        p("on_readdir", {err = err, files = files})
        return
    end

    for k, file in pairs(files) do
        if file ~= "main.lua" then
            print("--------------------------------------->test file", file)
            local ok, ret = pcall(dofile, path.join(__ROOT_DIR, file))
            if not ok then
                print(ret)
            end
            print("\n")
        end
    end
end)

