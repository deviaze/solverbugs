--!strict
local function maptostring<K, V>(t: { [K]: V }, f: (key: K, val: V) -> string?): string
	local result = ""
	for k, v in t do
		local s = f(k, v) -- TypeError: Function only returns 0 values, but 1 is required here
		if s then
			-- result ..= "\n" .. s -- TypeError: Type function instance refine<*blocked-14022*, ~(false?)> is uninhabited
		end
	end
	return result
end
