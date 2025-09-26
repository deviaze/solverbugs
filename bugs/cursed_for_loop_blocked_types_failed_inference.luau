--!nolint LocalShadow

-- Started erroring in 675

-- really weird one where i needed to retain a bunch more functions to replicate the issue
-- modifying str.splitlines' function body to return nil :: any (thereby coercing into { string }) does NOT break the solver

local str = {}

--- check if a string starts with `prefix`
function str.startswith(s: string, prefix: string): boolean
    return string.sub(s, 1, #prefix) == prefix
end

function str.trimback(s: string, ...: string): string
    return ""
end

--- unindents multiline string by `count` characters; lines separated by `sep` (default "\n")
function str.unindent(s: string, whitespace_type: "Tabs" | "Spaces", count: number, sep: ("\n" | "\r\n")?): string
    local indent = if whitespace_type == "Tabs" then string.rep("\t", count) else string.rep(" ", count)
    local sep = sep or "\n"

    local result = {}
    --- if str.splitlines returns `nil :: any` it doesn't break here???
    for _, line in str.splitlines(s) do -- on 'line': TypeError: Type '*blocked-77758*' could not be converted into 'string'
        if str.startswith(line, indent) then -- blocked cant convert to string
            local trimmed_line = string.gsub(line, "^" .. indent, "") -- TypeError: Type function instance refine<string, *blocked-82656*> is uninhabited
            table.insert(result, trimmed_line)
        else
            table.insert(result, line) -- TypeError: Type function instance refine<*blocked-83240*, ~*blocked-83241*> is uninhabited
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