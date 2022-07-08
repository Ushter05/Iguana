-- These are obsolete as methods have been absorbed into core Iguana API
-- require 'node'
-- require 'split'
-- require 'stringutil'

test = {}

function trace(A) return end

function main(Data)
   for k,v in pairs(test) do 
      v()
   end
   
trace(Global)
local FakeGlobal = test.testLocalVar()
   
end

function test.helloWorld()
   print('Is anybody out there?')
end

function test.concatenation() 
	local Value = 1
   local Line = 'We are all '..Value..' string'
   trace(Line)
end

function test.testLocalVar()
   local MyVar = 'I am a local'
   Global = 'Peace'
   testlocal(MyVar)
end

function testlocal(MyVar)
   trace(Global)
   trace(MyVar)
end

function test.Types() 
	local ANum = 10
   type(ANum)
   local AStr = '10'
   type(AStr)
   type(true)
   type(test)
   type(testCondition)
end

function test.testLoop() 
	for i=1, 5 do
      trace(i)
   end
end

function test.whileLoop() 

end

function test.MultipleReturns() 
   foo() -- calls foo function, returns 3 values
   local A, B, three = foo() -- assigns foo values to 3 variables
   trace(A) 
   trace(B)
   trace(three)
end

function foo() 
   return 1, 2, 'C'
end

function test.Colon() 
	local AString = 'Houdini'
   string.sub(AString,1,3)
   AString.sub(AString,1,3)
   AString:sub(1,3)
end

function test.testString() 
	local A = " Never odd or even"
   A:lower()
   A:upper()
   
   A:byte(3)
   string.char(78)
   A:find('even')
   A:len()
   A:sub(1,8)
   A:sub(A:find('odd'),A:len())
   A:gsub('%s','')
   A:rep(5)
   string.rep('0',10)
   for w in A:gmatch('%a+') do
      trace(w)
   end
   
   R=A:reverse()
   -- Can you make R look like this 'Never odd or even'
   
   
end

function test.testTable() 
	local T = {I='inpatient',O='outpatient'}
   T['P'] = 'Preadmit'
   T.U = 'Urgent'
   for k,v in pairs(T) do 
      trace(k .. '=' .. v)
   end
   trace(T)
end

function test.error() 
	local Success, Error = pcall(Bang)
   trace(Success)
   trace(Error)
   
   -- How might we deal with pcall results?
   if Success==false then 
      -- log the error
      iguana.logError(Error)
      -- [[Make Iguana go to the next process
      -- or the next message]]
      return
   end
   
end

function Bang() 
	error('A meaningful error message',2)
end

function test.testIO()
   local F = io.open('IguanaConfiguration.xml', "r")
   local C = F:read("*a")
   F:close()
   local X = xml.parse{data=C}
   X.iguana_config.channel_config:childCount("channel")
   local P = io.popen('dir /B')
   local File = P:read('*a')
   local List = File:split('\n')
   
end



















