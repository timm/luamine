function state(t,name)
  t[name] = {name=name,out={},visits=0,
	     done=true,abort=true,working=true}
  return t[name]
end

function trans(t,arcs)
  for _,arc in pairs(arcs) do
    old = t[arc[1].name].out
    old[#old + 1] = {from = arc[1], to=arc[3], gaurd=arc[2]}
end end

function shuffle(t)
  table.sort(t,function (x,y) return math.random() > 0.5 end)
  return t
end

function run(t,seed)
  math.randomseed(seed or 1)
  local w,here = {},t["entry"]
  while true do
    print(here.name)
    here.visits = here.visits + 1
    if here.visits > 5 then return true end
    for _,arc in pairs( shuffle(t[here.name].out)) do
      if arc.gaurd(w,arc) then
	here=arc.to
	break
end end end end

function fsm0(t)
  local function ok (w,a)   return a.from.done end
  local function fail(w,a)  return a.from.abort end
  local function again(w,a) return a.from.working end
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

run(fsm0({}), tonumber(arg[1]))