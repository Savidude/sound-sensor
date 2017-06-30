ssid = ""
password = ""
mqtt_broker_ip = "192.168.8.101"
mqtt_broker_port = 1883
mqtt_topic = "micData"

wifi.setmode(wifi.STATION)
wifi.sta.config(ssid, password)

client_connected = false
m = mqtt.Client("ESP8266-" .. node.chipid(), 120)

--4 = D4
--3 = D3
--5 = D5
--6 = D6
--7 = D7

angle = 0
mic = 5
gpio.mode(mic, gpio.INPUT)

function connectMQTTClient()
    local ip = wifi.sta.getip()
    if ip == nil then
        print("Waiting for network")
    else
        print("Client IP: " .. ip)
        print("Trying to connect MQTT client")
        m:connect(mqtt_broker_ip, mqtt_broker_port, 0, function(client)
            client_connected = true
            print("MQTT client connected")
        end)
    end
end

last = {}
index = 0;
ready = false


tmr.alarm(0, 100, 1, function()
    if (client_connected) then
        micLevel = gpio.HIGH        
        micLevel = gpio.read(mic)
        if (index == 20) then
            index = 0
            ready = true
        end
        print("Mic level: " .. micLevel)
        last[index] = micLevel
        index = index + 1

        if ready then
            count = 0
                        
            for i=0, 19, 1
            do
                if (last[i] == 0) then
                    count = count +1
                end
            end  
            print ("Count: " .. count)          
                
            if (count > 2) then
                payload = "{\"angle\":" .. angle .. "}"
                ready = false
                index = 0
                m:publish(mqtt_topic, payload, 0, 0, function(client)
                    print(payload)
                end)
            end
        end
    else
        connectMQTTClient()
    end
end)
