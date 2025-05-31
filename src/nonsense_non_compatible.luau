--!strict

type Cat = {
	name: string,
	age: number,
	actions: {
		meow: () -> string,
	}
}

local function new(): Cat
	local self = {}
	self.name = "Taz"
	self.age = 12
	self.actions = {} -- TypeError: Table type '{ meow: (...any) -> string }' not compatible with type '{ meow: (...any) -> string }' because the former is missing field 'meow'
	self.actions.meow = function() return "meow" end
	return self
end
