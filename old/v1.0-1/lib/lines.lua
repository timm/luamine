

-- File stuff ------------------------

function lines(white,comment)
  -- kill white space, join comma-ending files
  -- to next line, skip empty lines
  -- has to precluded with io.input(file)
  return function()  
    local pre, line = "", io.read()
    while line ~= nil do
      line = line:gsub(white,""):gsub(comment,"")
      if line ~= "" then
	    if lastchar(line) == "," then
	      pre  = pre .. line
      else
	      line =  pre .. line
	      pre  = ""
	      return line
    end end
    line = io.read()
    end
    if len(pre) > 0 then return pre end
end end