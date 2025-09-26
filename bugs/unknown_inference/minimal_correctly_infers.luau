-- What's weird is this attempt at getting a minimal repro correctly infers

type CsvRow = {
	columns: { string },
	values: { string },
}

type Csv = {
	rows: { CsvRow },
}

local fs = (require)("@std/fs") :: { 
	readfile: (path: string) -> string,
}

local csv = {}

function csv.parse(raw: string): Csv
	return {
		rows = {
			{
				columns = { "enter", "exit" },
				values = { "hi", "bye" },
			},
		},
	} :: Csv
end

function csv.readfile(path: string) -- correctly inferred as Csv
	local raw = fs.readfile("./meow.csv")
	return csv.parse(raw)
end

return csv