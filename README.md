<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/RGBCube_b.svg/2000px-RGBCube_b.svg.png" 
width=500 align=right>

# Fun with Lua

This general goal of this code 
is to document common data mining processing patterns
(see elsewhere for the excellent 
[functional programming in Lua library](http://rtsisyk.github.io/luafun/)).

The more specific goal of `Fun` is to learn, from examples,
a approximation to the function

    y = Fun(x)
    
whey `y` can be a single or multiple goals. The general tactic
will be to approximate complex functions via few  
dimensions, divided into a small number of ranges.  

## Why Fun? 

This code is an experiment in a combined data mining/multi-objective
optimization toolkit. Given 
[recent success with adding data mining inside an optimizer](http://goo.gl/nOAc7w), it might be possible to simplify and unify
data mining and optimization with a single simple set of data structures.

Or not. This is work in progress. Watch this space.

## Installation

To use:

1. Install Lua. Install LuaJit (if you want faster code). 
2. In  a fresh directory, download [fun.zip](fun.zip). 

To test:

+ All my `x.lua` files have an associated `xok.lua` file  containing
  tests for `x.lua`. To run those tests, after unzipping or checking out, run:

```
bash oks
```

which loads all the `*ok.lua` files in the current directory. That code should
**NOT** output the word _Failure_, except for the   tests  that
test if the test system is working. So please ignore the following lines:

```
Failure: aaaok.lua:5: oh dear 
Failure: aaaok.lua:10: oh dear,again 
```
      
## Documentation
  
  
### Conventions

Lua is a "batteries not included" language. To see the "batteries"
I added, which includes a small OO extension to Lua, read [aaa.lua](aaa.lua).


In the following description:

+ Anything starting with `U`pper case is  a class; 
+ Anyting starting with `l`ower case is a slot; 
+ Lua data objects are defined in `code` font ;
+ Lua methods start with a colon charatecter; e.g. `:example`;
+ Anything about files or particular data items are shown in _italic_ font.


### Details 

As mentioned above, the goal of `Fun` is to learn, from examples,
a approximation to the function

    y = Fun(x)
    
where `x,y` can be multiple `Col`umns (so these functions input mulitiple inputs
and generate mulitple outputs.

#### Columns

All columns are either:

+ `Num`bers: things that can be added, multiplied, etc
+ `Sym`bols: things that can only be counted and comparied with `==`.

The central object here is `Fun`; i.e. a `Fun`ction object
that stores examples of how outputs `y` are conneceted to inputs `x`. 

```lua
Fun=Object:new{
  name="",     rows   = {},
  x      = {}, y      = {}, headers= {},
  spec   = {}, more   = {}, less   = {},
  klass  = {}, nums   = {}, syms   = {}
}
```

As shown above, `Fun` objects store its examples as `rows`, plus some
`headers` informatiion about each column. Each header has a `name` and
knows
its `pos`ition within each row.  These `headers` are generated from
a `spec` that is a list of column names with some magic prefix character.
For example, if the `spec` is

    outlook, $temperature, windy,=play

then _outlook,windy_ are `Sym`bols while _temperature_ is `Num`ber.
Also, _play_ is a `klass` (which is also a `Sym`bol).  Other magic
characters are defined in the top of the _nsv.lua_ file.

    klass      = "=",        # for symbolic klasses, used for classification
    less       = "<",        # for numeric goal to be minimized
    more       = ">",        # for numeric goal to be maximized
    floatp     = "[\\$]",    # for numeric columns
    intp       = ":",        # for numeric columns
    goalp      = "[><=]",    # for any goal
    nump       = "[:\\$><]", # for any numeric
    dep        = "[=<>]"     # for any goal

Missing in the above is a prefix for `Sym`bol since this code assumes that
if you are not `nump` then you are a `Sym`bol.

When examples is read into a `Fun`ction, each item is `:add`ed to
the relevant header. This means that as a side effect of lading in the
rows, that the headers update their knowledge of each column.


`Num` and `Sym` are sub-classes of `Log` whose   `:add` function
blocks addition of any non-null values.  As to the specifics
of adding different types of items, note that `Log:add` calls
an `:add1` function that is specialized in `Sym` and `Num`:

```lua
function Log:add(x)
  if x ~= nil then
    if x ~= self.ignore then
      self.n = self.n + 1
      self:add1(x)
      self.some:keep(x)
    end end 
  return x
end 
 
function Sym:add1(x)
  local old = self.counts[x]
  new = (old == nil and 0 or old) + 1
  self.counts[x] = new
  if new > self.most then
    self.mode, self.most = x,new
end end

function Num:add1(x)
  if x > self.up then self.up = x end
  if x < self.lo then self.lo = x end
  local delta = x - self.mu
  self.mu     = self.mu + delta / self.n
  self.m2     = self.m2 + delta * (x - self.mu)
  if self.n > 1 then
    self.sd = (self.m2/(self.n - 1))^0.5  
end end 
```

Note that, in the above:

+ When items are `:add`ed to `Num` headers, the mean and standard deviation
  of those numbers is incrementally updated (as is our knowledge of
  the `up`per and `lo`wer values ever seen in that column.
+ When items are `:add`ed to `Sym` headers, the frequency counts of those
  items are incremcentall updated.
+ All additions are `:kept` in the `some` variable. 

This `some` variable is useful for maintaining a small sample
of a much larger space. Given a cache of fixed size (e.g. `k=256` items)
then once the cache is filled, the `n`-the item is kept in the 
cache at probablity `k/n`:

```lua
function Some:keep(x)
  self.n  = self.n + 1
  local k = #self.kept
  if k < self.max 
    then add(self.kept,x) 
  elseif r()  < k / self.n 
    then self.kept[ round(r() * k) ] = x
  end 
  return self
end
```