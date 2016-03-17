function fsm0(t)
  local function maybe()    return math.random() > 0.5 end
  local function ok (w,a)   return maybe() end
  local function fail(w,a)  return maybe() end
  local function again(w,a) return maybe() end
  local entry = state(t,"entry")
  local foo   = state(t,"foo")
  local bar   = state(t,"bar")
  local stop  = state(t,"stop")
  trans(t,{
	       {entry, ok,     foo},
	       {entry, fail,   stop},
	       {foo,   ok,     bar},
	       {foo,   fail,   stop},
	       {foo,   again,  entry},
	       {bar,   ok,     stop},
	       {bar,   fail,   stop},
	       {bar,   again, foo}})
  return t
end

function state(t,name)
  local new = {name=name,out={}, visits=0}
  t[name] = new
  return new
end

function trans(t,arcs)
  for _,arc in pairs(arcs) do
    local out = t[arc[1].name].out
    out[#out + 1] = {from = arc[1], to=arc[3], gaurd=arc[2]}
end end

function shuffle( t )
  for i = #t, 2, -1 do
    local j = math.random(i)
    t[i], t[j] = t[j], t[i]
  end
  return t
end

function rseed() math.randomseed(tonumber(arg[1]) or 1) end

function run(t)
  rseed()
  local w,here = {},t["entry"]
  while true do
    print(here.name)
    here.visits = here.visits + 1
    if here.visits > 5 then return true end
    local arcs= t[here.name].out
    for _,arc in pairs( shuffle(arcs) ) do
      if arc.gaurd(w,arc) then
	here=arc.to
	break
end end end end



run(fsm0({}))
