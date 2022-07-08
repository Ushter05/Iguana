require 'dateparse'
require 'retry'

function trace(A) return end

conn = db.connect{api=db.SQLITE, name='test.sqlite'}

function main(Data)
   conn:query{sql='SELECT * FROM Patient'}

   conn:query{sql="Select name from sqlite_master where type = 'table'"}
   conn:query{sql="select * from patient"}
   
   local T = MapData(Data)
   trace(T)
   conn:merge{data=T,live=true}
   
end

function MapData(Data) 
	local Msg, Name = hl7.parse{vmd='hl7.vmd',data=Data}
   local T = db.tables{vmd='tables.vmd',name='Message'}

   if Name == 'Lab' then ProcessLab(T, Msg)
   elseif Name == 'ADT' then ProcessADT(T, Msg)
   end

   return T
end

function ProcessADT(T, Msg) 
   MapPatient(T.Patient[1], Msg.PID)
end

function MapPatient(T, PID)
   T.Id    = PID[3][1][1]
   T.LastName  = PID[5][1][1][1]
   T.GivenName = PID[5][1][2]
   T.Sex       = PID[8]
   T.Ssn       = PID[19]   
   T.Dob       = PID[7]:D()
   T.Updated   = 1
   return T
   
end

function ProcessLab(T, Msg)

end






