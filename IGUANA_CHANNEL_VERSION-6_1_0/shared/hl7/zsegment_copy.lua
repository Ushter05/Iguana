
local function trace(a,b,c,d) return end

local function extractZSegment(Msg)
   local Segments = Msg:split('\r')
   local ZSegments = {}
   for i = 1, #Segments do
      if Segments[i]:sub(1,1) == 'Z' then
         trace('Found '..Segments[i])
         ZSegments[i] = Segments[i]
      end
   end
   return ZSegments
end

local function copyZSegments(Orig, Copy)
   -- enforce correct return character
   Copy = Copy:gsub('\r?\n','\r')
   Orig = Orig:gsub('\r?\n','\r')
   -- and strip return(s) from end of string
   -- '$' anchors matching to end of string
   Copy = Copy:gsub('\r+$','') 
   local ZSegments = extractZSegment(Orig)
   local SegmentList = Copy:split('\r')
   trace(SegmentList)
   for K,V in pairs(ZSegments) do
      table.insert(SegmentList, V)
   end
   trace(SegmentList)
   local Result = ''
   for i = 1, #SegmentList do
      Result = Result..SegmentList[i]..'\r'
   end
   return Result
end

return copyZSegments