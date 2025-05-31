--!strict
-- still broken in 675
-- type inference fails to complete
local function map<K, V>(t: { [K]: V}, f: (k: K, v: V) -> string?): string
    for k, v in t do
        local s = f(k, v) -- TypeError: Function only returns 0 values, but 1 is required here
    end
end
