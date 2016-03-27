SEP    = ","
IGNORE = "?"

row, use, line = 0, {}, io.read()
while line ~= nil do
  col, kept, row = 0, {}, row + 1
  for str in string.gmatch(line, "([^".. SEP.. "]+)" ) do
    col = col + 1
    if row == 1 then
      use[col] = string.find(str,IGNORE) == nil
    end
    if use[col] then
      kept[#kept+1] = str
    end
  end
  print(table.concat(kept,SEP))
  line = io.read()
end
