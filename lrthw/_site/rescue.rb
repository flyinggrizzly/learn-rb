def will_fail
  pen = "I have a pen"
  pineapple = "I have pineapple"

  puts pen, pineapple
  puts pineapple_pen
end

def badger
  badgers = "badgerbadgerbadgerbadgermushroOMMUSHRO00000OM"
  puts badgers
end

begin
  will_fail
rescue
  badger
end
