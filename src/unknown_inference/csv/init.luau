local fs = (require)("@std/fs") :: { 
	readfile: (path: string) -> string
}
local str = (require)("@std/str")

local types = require("@self/types")
export type Csv = types.Csv

local row = require("@self/row")
type CsvRow = row.CsvRow

--[=[
	A simple, utf8-aware csv library with nice pretty printing capabilities and even some
	select/filter operations.

	This library is pretty barebones for now, please add expansions (and pr them in) for more features.
]=]
local csv = {}

local function parse_line(line: string): { string }
	local result: { string } = {}
	return result
end

-- why is the return type inferred as ...unknown
function csv.readfile(path: string) -- return type inferred correctly as types.Csv until 0.675
	local text = fs.readfile(path)
	return csv.parse(text) -- hovering on parse correctly shows its return type as types.Csv
end

function csv.readfileinferredcorrectly(path: string)
	local text = fs.readfile(path)
	-- calling the stub function instead correctly infers return type as types.Csv
	return csv.parsestub(text)
end

function csv.parsestub(raw_text: string)
	return ({} :: any) :: Csv
end

--- create/parse a `Csv` from a properly formatted csv string
---
--- note that escaped quotes inside a string should be double quoted as per the csv specification
function csv.parse(raw_text: string)
	local lines = str.splitlines(raw_text) :: { string }
	local first_line = table.remove(lines, 1) or error("csv empty?")

	local column_names = parse_line(first_line)
	-- stylua: ignore
	local column_map = {} do
		for column_index, name in column_names do
			column_map[name] = column_index
		end
	end

	local rows = {}
	-- stylua: ignore
	local columns = {} do
		for column_index, column_name in column_names do
			columns[column_index] = {
				column_name = column_name,
				values = {},
			}
		end
	end

	for row_index, line in lines do
		local current_row = {}
		local parsed_line = parse_line(line)
		for column_index_in_row, value in parsed_line do
			current_row[column_index_in_row] = value
			local current_column_values = columns[column_index_in_row].values
			table.insert(current_column_values, value)
		end
		table.insert(rows, current_row)
	end

	local new_csv = {
		column_names = column_names,
		column_map = column_map,
		columns = columns,
		rows = rows,
	}
	return new_csv :: Csv
end

return csv
