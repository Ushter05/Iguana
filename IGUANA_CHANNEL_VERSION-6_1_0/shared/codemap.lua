-- This code map library has a number of useful helper routines for doing mapping and checking codes etc.

codemap = {}

-- Make a set
-- MySet = codemap.set{"Fred", "Bruce", "Jim"}
-- if MySet[Msg.PID[3][1][1]] then print('One of our three amigos') end
function codemap.set(List)
   local set = {}
   for _, V in ipairs(List) do set[V] = true end
   
   setmetatable(set, set_met)
   return set
end

-- Create a map the advantage of this function is that it will take a tree node without
-- needing to convert it to a string.  Example of usage
-- SexMap = codemap.map{'M'='Male', 'm'='Male', 'F'='Female', 'f'='Female'}
function codemap.map(Map)
   setmetatable(Map, set_met)
   return Map
end

set_met = {}
function set_met.__index(T, Key)
   if type(Key) ~= 'string' then
      return T[tostring(Key)] 
   end
   return nil
end


