-- ADD NEW SUPERFICIAL COMMENT

-- SUPERFICITIAL

phone = {}

function phone.clean_phone_us(PN)
   local Result
   if PN then
      local NumAsString = tostring(PN)
      -- Remove all non-numeric characters from the phone number.
      local N = NumAsString:gsub('[^%d]', '')
      if #N == 10 then
         Result =  '('..N:sub(1,3)..')'..N:sub(4,6)..'-'..N:sub(7,10)
      elseif #N == 7 then
         Result = N:sub(1,3)..'-'..N:sub(4,7)
      end
   else
      Result = nil
   end
   return Result
end

function phone.test () end

return phone
