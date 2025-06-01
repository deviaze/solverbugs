-- credit to alice on ROSS discord
type Effect = ((fn: (value: string) -> string) -> ()) & (fn: () -> ()) -> ()
local effect = (nil :: any) :: Effect -- pretend this is defined

effect(function(value) -- value is inferred as unknown instead of string
    return ""
end)