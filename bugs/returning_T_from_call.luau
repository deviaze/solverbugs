

type call = <T>(callback: (any) -> T | string) -> T
local call = function() end :: call

local function t_or_error(): { message: string } | string
    return { message = "hi" }
end

local result = call(function() 
    return t_or_error()
end)
