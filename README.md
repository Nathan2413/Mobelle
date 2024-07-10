# Mobelle - Gestion de Poubelle Automatique

Mobelle est un projet innovant qui vise à optimiser la gestion des déchets grâce à des poubelles intelligentes connectées. Ce projet utilise des technologies modernes telles que l'ESP32 pour la détection et la transmission des données, ainsi que Flutter pour l'interface utilisateur. Le système permet de surveiller en temps réel le poids et le volume des déchets, et de localiser les poubelles pour une gestion plus efficace.

## 1. Installation du projet

Pour télécharger et installer le projet Mobelle, veuillez exécuter la commande suivante :

```bash
git clone https://github.com/Nathan2413/Mobelle.git
```

## 2. Lancement du projet

### a. Entrer dans le répertoire du projet

```bash
cd Mobelle
```

### b. Mettre à jour Flutter

```bash
flutter upgrade
```

### c. Lancer le projet Flutter

```bash
flutter run
```

### d. Lancer le projet IoT

- Ouvrez le fichier `mobelle_3.0.ino` avec l'Arduino IDE. Le fichier se trouve dans le répertoire suivant :

```bash
cd mobelle_3.0
```

- Une fois que vous avez lancé le programme sur votre Arduino IDE, fermez l'IDE, puis exécutez le code Python suivant pour voir les données envoyées par la poubelle intelligente au niveau de poids et de volume :

```bash
python3 mo_belle.py
```

## 3. Rapport

Pour plus d'informations sur le projet, vous pouvez consulter le rapport détaillé en suivant ce chemin :

```bash
cd Rapport/Mo_belle.pdf
```

---

Développeur  
Nathan RC 🇲🇬
