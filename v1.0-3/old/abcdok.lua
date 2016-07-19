require "abcd"

do
  local function _abcd(s)
    local ws = {}
    local log = abcd0()
    for w in s:gmatch("%w+") do table.insert(ws, w) end
    for i = 1,#ws,2 do
      abcd1(ws[i], ws[i+1], log)
    end
    print("")
    for k, v in pairs(abcdz(log)) do
      print(k,{a=v.a,b=v.b,c=v.c,d=v.d,pd=v.pd,prec=v.prec })
    end
  end

  --[[
              a b c == actual
  predicted a 1 0 0
            b 0 4 0
            c 0 0 2
  ]]--
  _abcd([[ a a b b b b b b c c b b c c  ]])
  
  --[[
              a b c == actual
  predicted a 3 2 1
            b 5 6 1
            c 2 2 8
  ]]--
  _abcd([[   a a a a a a
                  b a b a
                  c a 
                  a b a b a b a b a b
                  b b b b b b b b b b b b
                  c b
                  a c a c
                  b c b c
                  c c c c c c c c 
                  c c c c c c c c 
             ]])
   --[[
              a b c == actual
  predicted a 1 1 0
            b 1 1 1
            c 0 1 1
  ]]--
  _abcd([[ a a b a a b b b c b b c c c  ]])
end
