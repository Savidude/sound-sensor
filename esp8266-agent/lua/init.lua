ssid = "Skynet WiFi"
password = "DeathToCapitalists"
mqtt_broker_ip = "192.168.43.157"
mqtt_broker_port = 1883
mqtt_topic = "micData"

wifi.setmode(wifi.STATION)
wifi.sta.config(ssid, password)

client_connected = false
m = mqtt.Client("ESP8266-" .. node.chipid(), 120)

mic1 = 5
gpio.mode(mic1, gpio.INPUT)
mic1Level = gpio.HIGH

mic2 = 4
gpio.mode(mic2, gpio.INPUT)
mic2Level = gpio.HIGH

mic3 = 0
gpio.mode(mic3, gpio.INPUT)
mic3Level = gpio.HIGH

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
--            subscribeToMQTTQueue()
        end)
    end
end


tmr.alarm(0, 5000, 1, function()    
    if (client_connected) then
        mic1Level = gpio.read(mic1)
        mic2Level = gpio.read(mic2)
        mic3Level = gpio.read(mic3)

        if(mic1Level == gpio.LOW) then
            payload = "{\"mics\":[{\"state\": 1,\"angle\": 75},{\"state\": 0,\"angle\": 90},{\"state\": 0,\"angle\": 45}]}"
            m:publish(mqtt_topic, payload, 0, 0, function(client)
                print(payload)
            end)
        end
        elseif(mic2Level == gpio.LOW) then
            payload = "{\"mics\":[{\"state\": 0,\"angle\": 75},{\"state\": 1,\"angle\": 90},{\"state\": 0,\"angle\": 45}]}"
            m:publish(mqtt_topic, payload, 0, 0, function(client)
                print(payload)
            end)
        elseif(mic3Level == gpio.LOW) then
            payload = "{\"mics\":[{\"state\": 0,\"angle\": 75},{\"state\": 0,\"angle\": 90},{\"state\": 1,\"angle\": 45}]}"
            m:publish(mqtt_topic, payload, 0, 0, function(client)
                print(payload)
            end)
    else
        connectMQTTClient()
    end
end)