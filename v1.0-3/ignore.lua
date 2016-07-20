SEP  = "([^,]+)"

local function ignorep(x) return string.find(x,"$") == nil end

row, use, line = 0, {}, io.read()

while line ~= nil do
  col, kept, row = 0, {}, row + 1
  for cell in string.gmatch(line, SEP ) do
    col = col + 1
    if row == 1 then use[col] = ignorep(cell) end
    if use[col] then kept[#kept+1] = cell end
  end
  print(table.concat(kept,","))
  line = io.read()
end
