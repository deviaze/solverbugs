local process = {} :: {
    exit: (code: number) -> never
}

local colors = {} :: {
    red: (text: string) -> string,
}

--- custom error handler fn
local function err(message: string): never
    -- format error message nicely
    local formatted = `{colors.red("ERROR:")} {message}`
    print(formatted)
    process.exit(1)
end -- TypeError: Not all codepaths in this function return 'never'

local function returns_never_explicitly(message: string): never
    -- format error message nicely
    local formatted = `{colors.red("ERROR:")} {message}`
    print(formatted)
    return process.exit(1)
end -- all good!

local function uses_error_function(message: string): never
    -- format error message nicely
    local formatted = `{colors.red("ERROR:")} {message}`
    error(formatted)
end -- all good!

local function errors_sometimes(cat: string): string
    if cat == "T" then
        return "Taz"
    elseif cat == "N" then
        return "Nanuk"
    else
        err("meow") -- using error instead of err here does the intended behavior
    end
end -- TypeError: Not all codepaths in this function return 'string'

local hmm = (nil :: any) :: () -> string?
local ok_or_error = hmm() or error("oops") -- hmm is correctly typed as string
local ok_or_err = hmm() or err("oops") -- this works correctly! ok_or_err is correctly typed as string
