require("dateparse")
require("node")
require("hl7util")
require("codemap")
require("stringutil")

-- This is a skeleton example of the Translator configured to map HL7 to a database.

-- The main function is the first function called from Iguana.
-- The Data argument will contain the message to be processed.
function main(Data)
   local T = MapData(Data)
   if T then
      -- TODO - uncomment and add connection parameters to db.connect{}
      -- local Conn = db.connect{}
      -- Conn:merge{data=T}
   end 
end

function ReportFilter(Reason)
   print(Reason)
end

-- To parse XML use xml.parse{}
-- To query data from database use db.query{}
function MapData(Data)
   local Msg,Name = hl7.parse{vmd='example/demo.vmd', data=Data}
   local Out      = db.tables{vmd='example/demo.vmd', name=Name}
      
   if FilterMessage(Msg) then
      print('Filtering message.')
      return nil
   end
   
   if     Name == 'Lab' then ProcessLab(Out, Msg) 
   elseif Name == 'ADT' then ProcessADT(Out, Msg)
   end
   
   return Out
end

-- ##### Filtering Rules #####
function FilterMessage(Msg) 
   if Msg:nodeName() == 'Catchall' then
      ReportFilter('Unexpected message type.')
      return true
   end
   return false
end
-- #### End of Filtering Rules ####

-- #### Common Routines ####
-- This type of map will assign nil if the code is unknown
SexCodeMap = codemap.map{
   M='Male', 
   m='Male', 
   F='Female', 
   f='Female'
}
	 
function MapPatient(T, PID) 
   T.Id = PID[3][1][1]
   T.LastName = PID[5][1][1][1]:S():capitalize()
   T.GivenName = PID[5][1][2]
   T.Dob = PID[7][1]:D()
   T.Sex = SexCodeMap[PID[8]]
   return T
end  

function MapNextOfKin(T, NK1, Id) 
   T.PatientId = Id
   T.LastName = NK1[2][1][1][1]
   T.FirstName = NK1[2][1][2]
   T.Relationship = NK1[3][1]
end
-- #### End of Common Routines ####

-- ##### Processing ADT (Admit/Discharge/Transfer) #####
function ProcessADT(Out, Msg) 
   MapPatient(Out.patient[1], Msg.PID)
   MapWeight(Out.patient[1], Msg)
   for i = 1, #Msg.NK1 do
      MapNextOfKin(Out.kin[i], Msg.NK1[i], Out.patient[1].Id)
   end
   return Out
end

-- This code shows the real power of a script-based GUI
-- mapper.  It searches through the message looking for an
-- OBX segment that has weight information.
function MapWeight(T, Msg)
   local OBX = hl7util.findSegment(Msg, ObxWeightFilter)
   if OBX then
      T.Weight = OBX[5][1][1]
   end
end

function ObxWeightFilter(Segment)
   if Segment:nodeName() == 'OBX' then
      if Segment[3][2]:S() == "WEIGHT" then 
         return true
      end
   end
   return false
end

-- ##### End of ADT Section #####

-- ##### Processing Lab Order Section #####
function ProcessLab(Out, Msg)
   if not Msg.PATIENT.PID:isNull() then
      MapPatient(Out.patient[1], Msg.PATIENT.PID)
   end
   return Out
end
-- ##### End of Lab Section #####
