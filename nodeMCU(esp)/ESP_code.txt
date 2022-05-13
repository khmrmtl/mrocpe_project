#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <Firebase_ESP_Client.h>
#include <AccelStepper.h>

//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Insert your network credentials
#define WIFI_SSID "CHANGE TO NETWORK SSID"
#define WIFI_PASSWORD "NETWORK PASSWORD"

// Insert Firebase project API Key
#define API_KEY "AIzaSyDiGnLUPo61bKrSmCCfUuIixvuxaevbnek"

// Insert RTDB URLefine the RTDB URL 
#define DATABASE_URL "https://testproject-54d36-default-rtdb.firebaseio.com/" 

//Define output pins
#define LED D0 ;LED and Fan
#define IN1a 5 ;Assign ULN2003 to ESP8266 pins
#define IN2a 4
#define IN3a 0
#define IN4a 2
#define IN1b 14
#define IN2b 12
#define IN3b 13
#define IN4b 15

//Define Step Constant
#define STEP 4 ; 

//Create Stepper Class with pins entered in proper sequence IN1-IN3-IN2-IN4
AccelStepper stepper1 = AccelStepper(STEP, IN1a, IN3a, IN2a, IN4a);
AccelStepper stepper2 = AccelStepper(STEP, IN1b, IN3b, IN2b, IN4b);


//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;

const int water_sensor = A0;

double test_reading = 0.0;
double reading = 0.0;
bool signupOK = false;

void setup(){
  Serial.begin(9600);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  //database setup
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;
  if (Firebase.signUp(&config, &auth, "", "")){
    Serial.println("ok");
    signupOK = true;
  }
  else{
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  // Assign the callback function for the long running token generation task 
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  // pinmode initialization
  pinMode(LED, OUTPUT);
  //set motor speed 
  stepper1.setMaxSpeed(1000);
  stepper1.setAcceleration(200);
  stepper2.setMaxSpeed(1000);
  stepper2.setAcceleration(200);
  
}

void loop(){
  
  reading = analogRead (water_sensor);
  Serial.println (reading);
  
  //&& (millis() - sendDataPrevMillis > 9600 || sendDataPrevMillis == 0) dagdag sa condition sa babab
  if (Firebase.ready() && signupOK ){
    // upload the reading to firebase database
    if (Firebase.RTDB.setFloat(&fbdo, "project/reading", reading )){
      Serial.println("Uploaded to database");
    }
    else {
      Serial.println("FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }
  }

  if (reading >= 390.0){ // HIGH
    // turn on LED(heater)
    digitalWrite(LED, HIGH);
    delay(5000);
  }
  else if(reading >= 290.0){ // MEDIUM
    // turn on MOTOR (motor pulls a plastic sheet)
    digitalWrite(LED, LOW);
    //move to target position then reset
    stepper1.moveTo(2048);
    stepper1.runToPosition();
    delay(1000);
    stepper1.moveTo(0);
    stepper1.runToPosition();
    delay(1000);
  }
  else if(reading >= 200.0){ // LOW
    // turn on MOTOR (motor pulls a net)
    digitalWrite(LED, LOW);
    //move to target position then reset
    stepper2.moveTo(2048);
    stepper2.runToPosition();
    delay(1000);
    stepper2.moveTo(0);
    stepper2.runToPosition();
    delay(1000);
  }
  else{ //water empty
    // turn off everything
    digitalWrite(LED, LOW);
  }
}

