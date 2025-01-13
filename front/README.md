### Comment Créer un APK avec Flutter

Suivez ces étapes pour générer un APK pour votre projet Flutter.

---

#### Étapes pour Créer un APK

1. **Naviguer vers le Répertoire du Projet**  
   Ouvrez votre terminal et placez-vous dans le répertoire de votre projet Flutter :
   ```bash
   cd <nom-du-projet>
   ```

2. **Vérifier la Configuration de Flutter**  
   Avant de créer l'APK, assurez-vous que tout est correctement configuré :
   ```bash
   flutter doctor
   ```
   Cette commande vérifie que votre environnement Flutter et le SDK Android sont prêts.

3. **Nettoyer le Projet (Optionnel)**  
   Il est souvent utile de nettoyer le projet avant de le construire :
   ```bash
   flutter clean
   ```

4. **Construire l'APK**  
   Pour générer un APK en **mode release** (optimisé pour la production), utilisez la commande suivante :
   ```bash
   flutter build apk --release
   ```

   - Cette commande crée un APK optimisé qui peut être installé sur des appareils Android.
   - L'APK généré sera situé dans le répertoire `build/app/outputs/flutter-apk/` sous le nom `app-release.apk`.

5. **Vérifier l'APK**  
   Une fois la construction terminée, vous trouverez votre fichier APK ici :
   ```bash
   build/app/outputs/flutter-apk/app-release.apk
   ```

6. **Installer l'APK sur un Appareil Android**  
   Vous pouvez installer l'APK sur un appareil Android connecté avec la commande suivante :
   ```bash
   flutter install
   ```

---

#### Commandes Utiles
- **Construire un APK pour Debug** :  
   Si vous souhaitez créer un APK pour le débogage (non optimisé) :
   ```bash
   flutter build apk --debug
   ```

- **Construire un APK pour Profilage (Mesurer les Performances)** :  
   Pour profiler l'application avant sa publication :
   ```bash
   flutter build apk --profile
   ```

---

Votre APK est maintenant prêt à être distribué ou testé sur des appareils Android ! 🎉

### Utilisation de l'IP

1. **Obtenir l'adresse IP locale de votre machine** :
   - **Windows** : Ouvrez un terminal (cmd) et tapez la commande suivante :
     ```bash
     ipconfig
     ```
     Cherchez l'adresse sous **"IPv4 Address"**. Cela devrait ressembler à `192.168.x.x`.
   - **macOS/Linux** : Ouvrez un terminal et tapez :
     ```bash
     ifconfig
     ```
     Cherchez l'adresse sous l'interface `en0` ou `eth0` (selon votre configuration réseau). Cela devrait être quelque chose comme `192.168.x.x`.

2. **Remplacer à la ligne 245** :  
   Au lieu d'utiliser `localhost`, vous devez utiliser l'adresse IP locale de votre machine. Par exemple, si votre adresse IP locale est `192.168.1.100`, modifiez le code comme suit :

   ```dart
   final response = await http.get(Uri.parse('http://192.168.1.100:5000/items'));
   ```

   Cela permet à votre application Flutter (qu'elle soit sur un émulateur ou un appareil physique) de se connecter au serveur qui s'exécute sur votre machine locale.

### Exemple Complet

Si votre serveur est exécuté sur `http://192.168.1.100:5000/items`, voici comment la fonction complète devrait apparaître :

```dart
Future<void> fetchIceCreams() async {
  try {
    // Remplacez localhost par votre IP locale
    final response = await http.get(Uri.parse('http://192.168.1.100:5000/items'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        iceCreams = data.map((json) => IceCream.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Échec du chargement des crèmes glacées');
    }
  } catch (e) {
    setState(() {
      isLoading = false;
    });
  }
}
```

Votre application Flutter devrait maintenant pouvoir récupérer les données depuis votre serveur local.
