import paho.mqtt.client as mqtt
import configparser
import json

config = configparser.ConfigParser()
config.read('config.ini')

broker = config['MQTT']
# Define Variables
MQTT_BROKER = broker['broker']
MQTT_PORT = broker['port']
MQTT_KEEPALIVE_INTERVAL = 45
MQTT_TOPIC = "micData"

print("MQTT BROKER: ", MQTT_BROKER)
print ("MQTT PORT: ", MQTT_PORT)

# Define on_connect event Handler
def on_connect(mosq, obj, rc):
    #Subscribe to a the Topic
    mqttc.subscribe(MQTT_TOPIC, 0)

# Define on_subscribe event Handler
def on_subscribe(mosq, obj, mid, granted_qos):
    print ("Subscribed to MQTT Topic")

# Define on_message event Handler
def on_message(mqttc, userdata, message):
    msg = (str(message.payload.decode("utf-8")))
    print(msg)
    data = json.loads(msg)
    for item in data["mics"]:
        if item["state"] == 1:
            print(item["angle"])

# Initiate MQTT Client
mqttc = mqtt.Client()

# Register Event Handlers
mqttc.on_message = on_message
mqttc.on_connect = on_connect
mqttc.on_subscribe = on_subscribe

# Connect with MQTT Broker
mqttc.connect(MQTT_BROKER)

# Continue the network loop
mqttc.loop_forever()