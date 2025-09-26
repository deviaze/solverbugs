--!strict

type CatImpl = {
	meow: () -> string,
	derived: {
		sit: () -> string,
		eat: () -> string,
	}
}

-- defining late-constructed tables like this errors when annotated
local impl: CatImpl = {} -- Table type '{  }' not compatible with type 'CatImpl' because the former is missing fields 'derived', and 'meow'
impl.meow = function()
	return ""
end
impl.derived = {} -- TypeError: Table type '{  }' not compatible with type '{ eat: () -> string, sit: () -> string }' because the former is missing fields 'eat', and 'sit'
impl.derived.eat = function() return "" end
impl.derived.sit = function() return "" end

local function get_impl(): CatImpl
	local impl = {}
	impl.meow = function()
		return ""
	end
	-- nonsense TypeError since these functions weren't defined within the table literal?
	impl.derived = {} -- TypeError: Table type '{ eat: (...any) -> string, sit: (...any) -> string }' not compatible with type '{ eat: (...any) -> string, sit: (...any) -> string }' because the former is missing fields 'eat', and 'sit'
	impl.derived.eat = function() return "" end
	impl.derived.sit = function() return "" end
	return impl
end
