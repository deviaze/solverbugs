-- credit to alice on ROSS discord
type Effect = ((fn: (value: string) -> string) -> ()) & (fn: () -> ()) -> ()
local effect = (nil :: any) :: Effect -- pretend this is defined

effect(function(value) -- value is inferred as unknown instead of string
    return ""
end)

type EffectNotOverloaded = (fn: (value: string) -> string) -> ()
local effect2 = (nil :: any) :: EffectNotOverloaded

effect2(function(value) -- value correctly infers as string
    return "hi"
end)

type EffectWithGenerics = (fn: <T>(value: T) -> T) -> ()
local effect3 = (nil :: any) :: EffectWithGenerics

effect3(function(a) -- correctly inferred as T
    return a
end)

type EffectOverloadedWithGenerics = (fn: 
    (<T>(value: T) -> T) & (() -> ())
) -> ()
local effect4 = (nil :: any) :: EffectOverloadedWithGenerics

effect4(function(value) -- incorrectly inferred as unknown
    
end)
