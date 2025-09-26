-- fixed by 674/675
-- local fs = require("@std/fs")

local fs = {} :: {
    path: {
        parent: (p: string) -> string?,
    }
}

local function get_closest_luaurc()
    local current_path = fs.path.parent("")
    while current_path ~= nil do
        current_path =   fs.path.parent(current_path)
    end
end