function show (x)
  if #x > 0 then print(table.concat(x)) end
end

cache, line = {}, io.read()

while line ~= nil do
  line = line:gsub("%s*(.-)%s*","%1") -- kill space around words
             :gsub("['\"\t\n\r]*","")  -- kill white space
             :gsub("#.*","")          -- kill comments
  if line ~= "" then
    cache[#cache + 1] = line       -- always cache current line
    if string.sub(line, -1) ~= "," -- and if lines does not end with ","
      then
	show(cache)                -- dump cache
	cache = {}                 -- reset cache
  end end
  line = io.read()
end

show(cache) 
