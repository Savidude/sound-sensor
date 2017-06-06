#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266mDNS.h>
#include <PubSubClient.h>

// Replace with your network credentials and mqtt settings
const char* ssid = "";
const char* password = "";
const char* mdnsName = "nodemcu";
const char* mqttServer = "";
const char* mqttUser = "";
const char* mqttPassword = "";
const char* mqttPubTopic = "micData";

WiFiClient espClient;
PubSubClient client(espClient);
MDNSResponder mdns;

int mic1Pin = 10; // Use Pin 10 as our Input
int mic1Level = HIGH; // This is where we record our Sound Measurement

int mic2Pin = 11;
int mic2Level = HIGH;

int mic3Pin = 12;
int mic3Level = HIGH;

void setup() {
  //Connecting nodemcu to WiFi  
  WiFi.begin(ssid, password);
  Serial.begin(115200); 
  Serial.println("Setting up");
  delay(5000);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.print("Connected to ");  Serial.println(ssid);
  Serial.print("IP address: ");   Serial.println(WiFi.localIP());

  client.setServer(mqttServer, 1883);

  //Device pin configuration
  pinMode (mic1Pin, INPUT) ; // input from the Sound Detection Module
  pinMode (mic2Pin, INPUT) ;
  pinMode (mic3Pin, INPUT) ;
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    if (client.connect("ESP8266Client", mqttUser, mqttPassword)) {
      Serial.println("connected");
    }
    else {
      Serial.print("Failed, state="); Serial.print(client.state());
      Serial.println(" will try again in 5 seconds...");
      delay(5000);
    }
  }
}

void loop() {
  if (!client.connected())
    reconnect();
  client.loop();

  mic1Level = digitalRead (mic1Pin) ; // read the sound alarm time
  mic2Level = digitalRead (mic2Pin) ;
  mic3Level = digitalRead (mic3Pin) ;

  char* payload = "";
  if (mic1Level == LOW) { // If we hear a sound
    payload = "{\"mics\":[{\"state\": 1,\"angle\": 75},{\"state\": 0,\"angle\": 90},{\"state\": 0,\"angle\": 45}]}";
  } else if (mic2Level == LOW) {
    payload = "{\"mics\":[{\"state\": 0,\"angle\": 75},{\"state\": 1,\"angle\": 90},{\"state\": 0,\"angle\": 45}]}";
  } else if (mic3Level == LOW) {
    payload = "{\"mics\":[{\"state\": 0,\"angle\": 75},{\"state\": 0,\"angle\": 90},{\"state\": 1,\"angle\": 45}]}";
  }

  if (payload != "") {
    client.publish(mqttPubTopic, payload);
  }
}
