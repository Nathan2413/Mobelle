import serial
import time

# Remplacez 'COM4' par le port série approprié pour votre ESP32
serial_port = 'COM4'
baud_rate = 115200  # Assurez-vous que ce taux de baud correspond à celui défini dans votre code ESP32

# Tentez d'initialiser la connexion série
try:
    ser = serial.Serial(serial_port, baud_rate, timeout=1)
    # Laissez un peu de temps pour que la connexion s'établisse
    time.sleep(2)
    print(f"Connecté à {serial_port}")
except serial.SerialException as e:
    print(f"Erreur lors de l'ouverture du port série {serial_port}: {e}")
    print("Assurez-vous que le port n'est pas utilisé par une autre application et que vous avez les droits nécessaires.")
    exit()

try:
    while True:
        if ser.in_waiting > 0:
            line = ser.readline().decode('utf-8').rstrip()
            print(line)
except KeyboardInterrupt:
    print("Programme arrêté")

# Fermez la connexion série
ser.close()
