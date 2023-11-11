term.clear()
peripheral.find("modem", rednet.open)

print("SUBHAN TRANSPORT COMPUTER SYSTEM")
print("SUBHAN SERVER SOFTWARE")

function checkFileCreated(username)
    local tbl = fs.find("/data/"..username)
    for _, _ in pairs(tbl) do
        return true
    end
    return false 
end





while true do
    print("Listening for payment requests...")
    local id, msg = rednet.receive()
    if msg[1] == "payment" then
        --payment sent
        local username = msg[2]
        print("Recieved payment request from ".. username)

        if checkFileCreated(username) == false then
            print(username .. " has never used the train network!")
            print("Creating a file for "..username)
            
            local f = fs.open("/data/"..username, "w")
            f.write("0")
            f.close()

            print("Sending unauthorised packet")

            rednet.broadcast({"paymentAuthorised", username, false})
        else
            print("File already created")
            
            print("Checking if train fare rate file is created..")
            if checkFileCreated("rate") == false then
                print("Not created! Creating fare rate file")
                local f = fs.open("/data/rate", "w")
                f.write("1")
                f.close()
            end

            print("Reading data file..")

            local f = fs.open("/data/"..username, "r")
            local credits = tonumber(f.readLine())
            f.close()

            print(username.. " has ".. credits .. " credits")

            local f2 = fs.open("/data/rate", "r")
            local rate = tonumber(f2.readLine())
            f2.close()

            print("Using train fare rate: ".. rate.. " credits")

            local remaining = credits-rate

            if remaining <0 then
                print(username .. " is unable to pay!!")
                rednet.broadcast({"paymentAuthorised", username, false})
            else
                print(username .. " has paid!!")
                
                local f = fs.open("/data/".. username, "w")
                f.write(tostring(remaining))
                f.close()

                rednet.broadcast({"paymentAuthorised", username, true})
            end

        end
    end
end
