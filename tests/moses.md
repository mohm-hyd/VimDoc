
*Moses: a utility-belt library for functional programming in Lua*

__Moses__ is a Lua utility library which provides support for functional programming. 
It complements built-in Lua functions, making easier common operations on tables, arrays, lists, collections, objects, and a lot more.
<br/>
<br/>

# <a name='TOC'>Sections</a>


* [Adding *Moses* to your project](#adding)
* [Table functions](#table)
* [Array functions](#array)
* [Utility functions](#utility)
* [Object functions](#object)
* [Chaining](#chaining)
* [Import](#import)
<br/><br/>
# <a name='adding'>Adding *Moses* to your project</a>

Drop the file [moses.lua](http://github.com/Yonaba/Moses/blob/master/moses.lua) into your project and add it to your code with the *require* function:

```lua
local M = require ("moses")
````

*Moses* provides a large set of functions that can be classified into four categories:

* [__Table functions__](#table), which are mostly meant for tables, i.e Lua tables which contains both an array-part and a hash-part,
* [__Array functions__](#array), meant for array lists (or sequences),
* [__Utility functions__](#utility),
* [__Object functions__](#object).

**[[⬆]](#TOC)**

## <a name='table'>Table functions</a>

### clear (t)

Clears a table. All its values becomes nil. Returns the passed-in table.

```lua
M.clear({1,2,'hello',true}) -- => {}
````

### each (t, f)
*Aliases: `forEach`*.

Iterates over each value-key pair in the passed-in table.

```lua
M.each({4,2,1},print)

-- => 4 1
-- => 2 2
-- => 1 3
````

The table can be map-like (both array part and hash part).

```lua
M.each({one = 1, two = 2, three = 3},print)

-- => 1 one
-- => 2 two
-- => 3 three
````

Can index and assign in an outer table or in the passed-in table:

```lua
t = {'a','b','c'}
M.each(t,function(v,i)
  t[i] = v:rep(2)
  print(t[i])
end)

-- => aa
-- => bb
-- => cc
````

### eachi (t, f)
*Aliases: `forEachi`*.

Iterates only on integer keys in an array table. It returns value-key pairs.

```lua
M.eachi({4,2,1},print)

-- => 4 1
-- => 2 2
-- => 1 3
````

The given array can be sparse, or even have a hash-like part.

```lua
local t = {a = 1, b = 2, [0] = 1, [-1] = 6, 3, x = 4, 5}
M.eachi(t,print)

-- => 6 -1
-- => 1 0
-- => 3 1	
-- => 5 2
````

### at (t, ...)
