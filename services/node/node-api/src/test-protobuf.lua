local pb = require "pb"
local protoc = require "protoc"

-- load schema from text (just for demo, use protoc.new() in real world)
assert(protoc:load [[
   message Phone {
      optional string name        = 1;
      optional int64  phonenumber = 2;
   }
   message Person {
      optional string name     = 1;
      optional int32  age      = 2;
      optional string address  = 3;
      repeated Phone  contacts = 4;
   } ]])

-- lua table data
local dataX = { foo: 'bar'}
local data = {
   name = "ilse",
   age  = 18,
   contacts = {
      { name = "alice", phonenumber = 12312341234 },
      { name = "bob",   phonenumber = 45645674567 }
   }
}

-- encode lua table data into binary format in lua string and return
local bytes = assert(pb.encode("Person", dataX))
print(pb.tohex(bytes))

-- and decode the binary data back into lua table
local data2 = assert(pb.decode("Person", bytes))
--print(require "serpent".block(data2))
print(data2)
