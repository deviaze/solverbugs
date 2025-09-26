type function minimal(t: type): type
    return types.singleton("{ meow: string, cats: { number } }")
end

local min = {} :: minimal<"hi">
-- TypeError: Cannot cast '{  }' into '"\123 meow: string, cats: \123 number } }"' because the types are unrelated

type Cat = setmetatable<{
    name: string,
    age: number,
    kittens: { Cat },
}, {
    __type_tag: "Cat",
    __tostring: (self: Cat) -> string,
}>

type function stringify(t: type)
    --- this probably doesn't handle function types or most edge cases or anything
    --- cause the type function api is an incredibly annoying api that doesn't even have type safety enough
    --- to prevent you from calling :properties() on a fried chicken instead of a table type
    --- and i cba to write an additional 200 lines to make it work
    local function stringify_table(t: type, depth: number?): string
        depth = depth or 0
        if depth > 4 then
            return if t:is("table") then "{...}" else t.tag
        end
        local result: { string } = {}
        local function push(s: string)
            table.insert(result, s)
        end
        push("{ ")
        local indexer = t:indexer()
        if indexer then
            -- map-like
            local key = indexer.index.tag
            push(if key == "number" then "" else `[{key}]: `)
            local read = indexer.readresult
            push(if read.tag == "table" then stringify_table(read, depth + 1) else read.tag)
        else
            for key: type, read_write in t:properties() do
                if key.tag == "singleton" then
                    push(`{key:value()}: `)
                end
                if read_write.read then -- not supporting write types because i dont use them and annoying
                    local read = read_write.read
                    push( 
                        (if read.tag == "singleton" then 
                            tostring(read:value())
                        elseif read:is("table") then
                            stringify_table(read, depth + 1)
                        else
                            read.tag
                        ) .. ", "
                    )
                end
            end
            local metatable_type = t:metatable()
            if metatable_type then
                if metatable_type:is("table") then
                    push(`@metatable {stringify_table(metatable_type)}`)
                else
                    error("why do you have a non-table metatable type???")
                end
            end
        end
        push("}")
        local stringified_result = table.concat(result)
        stringified_result = string.gsub(stringified_result, ", }", " }")
        if depth == 0 then
            print(stringified_result)
        end
        return stringified_result
    end
    if t:is("table") then
        return types.singleton(stringify_table(t))
    else
        error(`expected table type, got: {t.tag}`)
    end
end

local x = {} :: stringify<Cat>
--[[
TypeError: Cannot cast '{  }' into '"\123 name: string, kittens: \123 \123 kittens: \123 \123 name: string, kittens: \123...}, age: number, @metatable \123 __tostring: function, __type_tag: Cat }}}, age: number, name: string, @metatable \123 __type_tag: Cat, __tostring: function }}}, age: number, @metatable \123 __type_tag: Cat, __tostring: function }}"' because the types are unrelated
]]
local y = {} :: stringify<{ [string]: Cat }>
--[[
TypeError: Cannot cast '{  }' into '"\123 [string]: \123 name: string, kittens: \123 \123 kittens: \123 \123...}}, age: number, name: string, @metatable \123 __tostring: function, __type_tag: Cat }}}, age: number, @metatable \123 __tostring: function, __type_tag: Cat }}}"' because the types are unrelated
    TypeError: { [string]: { kittens: { { kittens: { {...}}, age: number, name: string, @metatable { __tostring: function, __type_tag: Cat }}}, age: number, name: string, @metatable { __type_tag: Cat, __tostring: function }}}
]]