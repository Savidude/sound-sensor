ssid = "Skynet WiFi"
password = "DeathToCapitalists"

wifi.setmode(wifi.STATION)
wifi.sta.config(ssid, password)

client_connected = false
m = mqtt.Client("ESP8266-" .. node.chipid(), 120)

mic1 = 5
gpio.mode(mic1, gpio.INPUT)
mic1Level = gpio.HIGH

function connectMQTTClient()
    local ip = wifi.sta.getip()
    if ip == nil then
        print("Waiting for network")
    else
        print("Client IP: " .. ip)
        print("Trying to connect MQTT client")
        m:connect("192.168.43.157", 1883, 0, function(client)
            client_connected = true
            print("MQTT client connected")
--            subscribeToMQTTQueue()
        end)
    end
end


tmr.alarm(0, 5000, 1, function()    
    if (client_connected) then
        local payload = "3333333"
        mic1Level = gpio.read(mic1)
        print(mic1Level)
        if(mic1Level == gpio.LOW) then 
            m:publish("testTopic", payload, 0, 0, function(client)
                print("Published")
            end)
        end
    else
        connectMQTTClient()
    end
end)