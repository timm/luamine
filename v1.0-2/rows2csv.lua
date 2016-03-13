pre, line = "", io.read()
while line ~= nil do
  line = line:gsub("[ \t\n]*",""):gsub("#.*","")
  if line ~= "" then
    if
      string.sub(line, -1) == ","
    then
      pre  = pre .. line
    else
      print(pre .. line)
      pre = ""
  end end
  line = io.read()
end
if string.len(pre) > 0 then print(line) end
