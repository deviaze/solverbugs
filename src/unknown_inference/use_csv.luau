local csv = require("./csv")

--- csv.readfile been returning ...unknown since 0.675

local data = csv.readfile("./meow.csv") -- why is this ...unknown
print(data.column_names)