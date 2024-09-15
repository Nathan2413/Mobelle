#include <WiFi.h>
#include <ESP32Servo.h>
#include <HX711.h>

// WiFi credentials
const char* ssid = "Hello";
const char* password = "Carl020701T#an"; 

// Servo motor and infrared sensor pins
Servo myservo;
int servoPin = 13;
int irSensorPin = 34;  // Utilisez la broche connectée à SIG du capteur infrarouge
int irSensorValue = 0;

// Ultrasonic sensor pins
const int trigPin = 5;
const int echoPin = 18;
long duration;
int distance;

// LED RGB pins
const int redPin = 25;
const int greenPin = 26;
const int bluePin = 27;

// HX711 pins and configuration
#define LOADCELL_DOUT_PIN 32  // Broche de données (DT) du capteur HX711 connectée à GPIO 32
#define LOADCELL_SCK_PIN 33   // Broche d'horloge (SCK) du capteur HX711 connectée à GPIO 33

HX711 scale;
const float calibration_factor = 2;  // Exemple : ajustez ce facteur après la calibration pour convertir en grammes

void setup() {
  Serial.begin(115200);

  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");

  // Configure servo
  myservo.attach(servoPin);
  myservo.write(-25); // Initialize servo at -25 degrees

  // Configure infrared sensor pin
  pinMode(irSensorPin, INPUT);

  // Configure ultrasonic sensor pins
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  // Configure LED RGB pins
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);

  // Initialisation du capteur HX711
  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);
  scale.set_scale(calibration_factor);  // Applique le facteur de conversion
  scale.tare();  // Met à zéro le capteur
}

void loop() {
  irSensorValue = digitalRead(irSensorPin);  // Read digital value from infrared sensor

  // Measure distance using ultrasonic sensor
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  distance = duration * 0.034 / 2;

  // Print the ultrasonic distance to the Serial Monitor
  Serial.print("Ultrasonic Distance: ");
  Serial.print(distance);
  Serial.println(" cm");

  // Lecture du poids depuis le capteur HX711
  float weight = scale.get_units();  // Obtient le poids en kg

  // Si le poids est négatif ou très bas, considérez-le comme 0 pour éviter les valeurs initiales erronées
  if (weight < 0.1) {
    weight = 0.0;
  }

  // Affichage du poids mesuré en grammes
  Serial.print("Weight: ");
  Serial.print(weight * 0.01, 2);  // Convertit en grammes et affiche avec 2 décimales
  Serial.println(" g");

  // Logic for controlling servo and LED based on sensor readings
  if (irSensorValue == LOW) {  // Si l'infrarouge détecte un objet
    if (distance >= 2.5 && distance <= 100 && weight <= 150000) {  // Conditions pour déplacer le servo à 45 degrés et allumer la LED verte
      Serial.println("Conditions met. Servo at 45 degrees.");
      myservo.write(90); // Déplacer le servo à 45 degrés
      digitalWrite(redPin, HIGH);
      digitalWrite(greenPin, LOW);
      digitalWrite(bluePin, LOW);
      delay(3000);
    } 
  } else {
    // Si aucune détection infrarouge, mettre la LED en vert
    Serial.println("No infrared detection. Servo remains at -25 degrees.");
    myservo.write(-25); // Garder le servo à -25 degrés
    digitalWrite(redPin, HIGH);
    digitalWrite(greenPin, LOW);
    digitalWrite(bluePin, LOW);
  }
  // Ajout de la condition pour la LED rouge si la distance est < 2.5 cm ou > 100 cm
  if (distance < 2.5 || distance > 100 || weight > 150000) {
    digitalWrite(redPin, LOW);
    digitalWrite(greenPin, HIGH);
    digitalWrite(bluePin, LOW);
  }
  
  delay(1000); // Attendre 1 seconde avant de vérifier à nouveau
}