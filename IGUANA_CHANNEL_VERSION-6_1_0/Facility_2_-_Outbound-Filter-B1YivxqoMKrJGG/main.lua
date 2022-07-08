-- The main function is the first function called from Iguana.
-- The Data argument will contain the message to be processed.
require 'cleanphone'
require 'dateparse'
require 'split'
hl7.parseZsegment = require 'hl7.zsegment'
hl7.copyZsegment = require 'hl7.zsegment_copy'

local function trace(A) return end

function main(Data)

   local Orig = hl7.parse{vmd="demo.vmd",data=Data}
   if Orig:nodeName() == 'Catchall' then 
      iguana.logInfo('This message was filtered '..Orig.MSH[9][1]..' '..Orig.MSH[9][2]) 
      return
   end

   
   
   local Out = hl7.message{vmd='demo.vmd', name=Orig:nodeName()}
   
   CheckForVIP(Orig)
   
   Out:mapTree(Orig)
   
   
   AlterMSH(Out.MSH)
   if Orig:nodeName() == 'Lab' then 
      AlterPID(Out.PATIENT.PID)
   elseif Orig:nodeName() == 'ADT' then 
      AlterPID(Out.PID)
   end
   
   if Out:nodeName() == 'Lab' then
      AddNote(Out)  
   end
   
   trace(Out)

   local DataOut = tostring(Out)
   

   
   queue.push{data=DataOut}

end

function CheckForVIP(Msg)
   if Msg:nodeName() == 'ADT' then 
      if Msg.PV1[16]:nodeValue() == 'VIP' then 
         Alert("VIP: "..Msg.PID[5][1][1][1]..', '..Msg.PID[5][1][2]..' has arrived')
      end
   end
end

function Alert(Message)
   iguana.logInfo('ALERT:\n'..Message)
end


function AlterMSH(MSH) 
   MSH[3][1] = 'MyApp'
   MSH[4][1] = 'MyOffice'
   return MSH
end

function AlterPID(PID)
   PID[5][1][2] = PID[5][1][2]:nodeValue():upper()
   PID[5][1][1][1] = PID[5][1][1][1]:nodeValue():upper()
   PID[13][1][1] = phone.clean_phone_us(PID[13][1][1])
	local DOB = dateparse.parse(PID[7][1]:nodeValue())
   PID[7][1] = os.date('%Y%m%d',DOB)
   return PID
end

function AddNote(Out)
   local Lines = NoteTemplate:split('\n')
   for i=1, #Lines do 
      Out.NTE[i][1]    = i 
      Out.NTE[i][3][1] = Lines[i]
   end
   return Out   
end

NoteTemplate=[[
Positive attitude is now known to be a root cause of many positive life benefits.
A positive attitude is the inclination towards a hopeful state of mind.
Your way of thinking, whether positive or negative, is a habit.
Let go of the assumption that the world is against you.
Understand that the past does not equal the future. 
See yourself as a cause, not an effect. 
Use positive affirmations.
Remember that life is short.
Be a balanced optimist.
]]
