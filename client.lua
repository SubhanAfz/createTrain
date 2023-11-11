peripheral.find("modem", rednet.open)
local speaker = peripheral.find("speaker")

term.clear()

print("SUBHAN TRANSPORT SYSTEM CLIENT")

while true do
    local _, username = os.pullEvent("playerClick")

    print("Detected player click! payment sent to authorise")
    rednet.broadcast({"payment", username})
    
    print("Waiting for response...")

    local id, msg = rednet.receive()
    if msg[1] == "paymentAuthorised" and msg[2] == username then
        if msg[3] == true then
            print("Authorised!")

            rs.setOutput("back", true)
            sleep(2)
            rs.setOutput("back", false)
            speaker.playNote("bell", 1, 1)
            
        else
            print("Unauthorised!")
            speaker.playNote("bass", 1, 0)
        end
    end
    
end