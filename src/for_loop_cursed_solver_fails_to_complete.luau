--!nolint LocalShadow

-- really weird one where i needed to retain a bunch more functions to replicate the issue
-- modifying str.splitlines' function body to return nil :: any (thereby coercing into { string }) does NOT break the solver

local str = {}

--- check if a string starts with `prefix`
function str.startswith(s: string, prefix: string): boolean
    return string.sub(s, 1, #prefix) == prefix
end

function str.trimback(s: string, ...: string): string
    local patterns = {...}
    if #patterns == 0 then
        s = string.gsub(s, "%s*$", "")
    else
        for _, pattern in patterns do
            while string.find(s, pattern .. "$") do
                s = string.gsub(s, pattern .. "$", "")
            end
        end
    end
    
    return s
end

--- unindents multiline string by `count` characters; lines separated by `sep` (default "\n")
function str.unindent(s: string, whitespace_type: "Tabs" | "Spaces", count: number, sep: ("\n" | "\r\n")?): string
    local indent = if whitespace_type == "Tabs" then string.rep("\t", count) else string.rep(" ", count)
    local sep = sep or "\n"

    local result = {}
    --- if str.splitlines returns `nil :: any` it doesn't break here???
    for _, line in str.splitlines(s) do
        if str.startswith(line, indent) then
            local trimmed_line = string.gsub(line, "^" .. indent, "")
            table.insert(result, trimmed_line)
        else
            table.insert(result, line)
        end
    end

    return table.concat(result, sep)
end


--- splits `s` by newlines, correctly handling carriage returns, trimming trailing whitespace,
--- without an extra empty string, etc.
function str.splitlines(s: string, trim_trailing_whitespace: boolean?): { string }
    trim_trailing_whitespace = trim_trailing_whitespace ~= false -- handle true and nil
    local splitted = str.split(s, "\n", "\r\n")
    if trim_trailing_whitespace then
        for i, sp in splitted do
            splitted[i] = str.trimback(sp)
        end
    end
    return splitted
    -- if this returns nil :: any instead it doesn't break solver
end

local str_internal = (require)("@std/str_internal")

str.split = str_internal.split :: (s: string, ...string) -> { string }

str.graphemes = str_internal.graphemes :: (s: string) -> (...any) -> (number, string)