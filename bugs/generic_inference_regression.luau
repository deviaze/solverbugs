--- Most of my error handling code in *seal* returns a union of T | error, 
--- where error is a custom userdata extern type provided by seal.
--- see https://github.com/seal-runtime/seal/blob/9e1ce9450a723838fae0e2874b8c0f6611cdc2ad/.seal/typedefs/globals.d.luau#L34
--- I have overloaded `pcall` in global type definitions to return `(boolean, T | error)` to reflect this.
--- see: https://github.com/seal-runtime/seal/blob/9e1ce9450a723838fae0e2874b8c0f6611cdc2ad/.seal/typedefs/globals.d.luau#L1
--- Inference from the return of `pcall` or similar used to work perfectly in the Luau New Type Solver until like 0.700(?)
--- correctly using the type inferred by the return of `protected_callback`, 
--- but recently, second return is always typed as `unknown` instead of `T | error`

type p_call = <T, Args...>(protected_callback: (any) -> T, Args...) -> (boolean, T | error)
local p_call = function() end :: p_call

local success, result = p_call(function()
    return ""
end) --- result should be typed as string | error

if typeof(result) == "error" then
    -- this used to narrow result into the `error` userdata and allowed for nominally typed error handling
    print(`got error {result}`)
else
    -- this used to narrow result into `string` so the following worked without TypeErrors
    local lowercased_message = string.lower(result)
end

-- example usage:

local fs = require("@std/fs") -- these are all standard libraries provided by the seal runtime
local str = require("@std/str")
local json = require("@std/json")
local err = require("@std/err")

local function try_read_json(path: string, strip_comments: boolean?): string | error
    if fs.is(path) ~= "File" then
        return err.wrap(`path at {path} is not a file`) -- err.wrap returns an error userdata
    end
    if str.endswith(fs.path.child(path) :: string, ".jsonc") and not strip_comments then
        return err.wrap(`'{path}' may have comments that will be stripped, this is usually not intentional`)
    end
    
    local _, result = pcall(json.readfile, path)
    if typeof(result) == "error" then
        return err.wrap(`unable to read json file at '{path}' due to err: {result}`)
    else
        return result
    end
end

--- Additionally, I have a function `ecall` that does the exact opposite, it returns a function
--- that when called, throws any errors from a function that returns T | error and returns T

type ecall = <T, A...>(f: (A...) -> T | error) -> (A...) -> T
local ecall = function() end :: ecall

local content = ecall(function()
    return try_read_json("./some.json")
end)()
-- content used to be typed as `string` here since any error values returned by
-- try_read_json would be thrown as actual Luau errors instead of returned as an 'error' userdata

