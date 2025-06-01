local str = (require)("@std/str")

type CsvRowStruct = { { [string]: string } }
type CsvRowImpl = {
	values: (self: CsvRow) -> { string },
	display: (self: CsvRow) -> string,
}

export type CsvRow = setmetatable<CsvRowStruct, {
	__index: CsvRowImpl,
}>

local row = {}

local impl = {}

function impl.values(self: CsvRow): { string }
	local result: { string } = {}
	for column_index, map in self do
		for _col, value in map do
			table.insert(result, value)
		end
	end
	return result
end

function impl.display(self: CsvRow): string
	local col_widths = {} :: { number }

	-- unannotated param 'row_data' used to be correctly inferred as { string } until 0.675
	local function format_row(row_data)
		local formatted = {}
		for column_index, value in row_data do -- on 'row_data': TypeError: Value of type 'unknown' could be nil
			table.insert(
				formatted,
				value .. string.rep(" ", math.max(0, col_widths[column_index] - str.width(value)))
			)
		end
		return table.concat(formatted, "  ")
	end

	local separator = table.concat({} :: { string }, "  ")

	local headers: { string }, values: { string } = {}, {}

	return format_row(headers) .. "\n" .. separator .. "\n" .. format_row(values)
end

return row
