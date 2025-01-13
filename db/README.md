# ice-cream-app

### Serveur Node.js avec MongoDB

Ce code met en place un serveur Node.js qui utilise **MongoDB** comme base de données. Voici une explication détaillée des fonctionnalités et des technologies utilisées.

---

#### 1. **Technologies Utilisées**
- **Node.js** : Environnement d'exécution JavaScript côté serveur.
- **Express** : Framework minimaliste pour construire des API REST.
- **MongoDB** : Base de données NoSQL utilisée pour stocker les données.
- **Mongoose** : Bibliothèque permettant de manipuler MongoDB avec des schémas dans Node.js.
- **dotenv** : Charge les variables d'environnement à partir d'un fichier `.env`.
- **body-parser** : Permet d'analyser les corps des requêtes HTTP.
- **cors** : Active le partage de ressources entre origines multiples.

---

#### 2. **Structure de la Base de Données (MongoDB)**
Deux collections principales sont définies dans MongoDB :

1. **Items (Objets)** :
   - Schéma : 
     ```javascript
     const ItemSchema = new mongoose.Schema({
       path: { type: String, required: true },
       name: { type: String, required: true },
       price: { type: Number, required: true },
       stock: { type: Number, required: true },
     });
     ```
   - Utilisation : Permet de gérer les objets, leur prix, et leur stock.

2. **Coordinates (Coordonnées)** :
   - Schéma : 
     ```javascript
     const CoordinateSchema = new mongoose.Schema({
       latitude: { type: Number, required: true },
       longitude: { type: Number, required: true },
     });
     ```
   - Utilisation : Permet de stocker des positions géographiques.

---

#### 3. **Fonctionnalités Principales**
- **Items (Objets)** :
  - `POST /items` : Ajouter un nouvel objet.
  - `GET /items` : Récupérer la liste des objets.
  - `PUT /items/:id` : Mettre à jour un objet existant.
  - `DELETE /items/:id` : Supprimer un objet par son ID.

- **Coordinates (Coordonnées)** :
  - `POST /coordinates` : Ajouter une nouvelle coordonnée.
  - `GET /coordinates` : Récupérer toutes les coordonnées.
  - `GET /coordinates/:id` : Récupérer une coordonnée spécifique par son ID.
  - `PUT /coordinates/:id` : Mettre à jour une coordonnée existante.
  - `DELETE /coordinates/:id` : Supprimer une coordonnée par son ID.

---

#### 4. **Connexion à MongoDB**
La connexion à MongoDB est établie via la méthode suivante :
```javascript
mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('MongoDB Connected'))
  .catch((err) => console.error(err));
```
- **`process.env.MONGO_URI`** : Doit contenir l'URI de connexion MongoDB, défini dans un fichier `.env`. Exemple d'URI :
  ```
  MONGO_URI=mongodb+srv://<user>:<password>@cluster0.mongodb.net/myDatabase
  ```

---

#### 5. **Exécution du Serveur**
Le serveur écoute sur le port spécifié dans `process.env.PORT` ou sur le port `5000` par défaut :
```javascript
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log('Server is running on port 5000');
});
```

---

#### 6. **Installation et Lancement**
1. **Installer les dépendances** :
   ```bash
   npm install
   ```
2. **Lancer le serveur** :
   ```bash
   node server.js
   ```

---

Ce serveur fournit une API REST qui interagit avec une base de données MongoDB pour gérer des objets et des coordonnées géographiques.
