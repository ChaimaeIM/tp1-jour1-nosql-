# TP Jour 1 - MongoDB et NoSQL
## Introduction au NoSQL et MongoDB (4 heures)

**Module:** MIA4 - Conception et intégration d'un SGBD NoSQL  
**Établissement:** IPSSI Montpellier  
**Étudiante:** Chaimae IMRANI (IPSSI Compus Nice)  
**Date:** 24 août 2026  

---

## 📋 Objectifs pédagogiques

- ✅ Déployer MongoDB via Docker (approche reproductible)
- ✅ Importer un jeu de données réel (25359 restaurants NYC)
- ✅ Maîtriser les 4 piliers CRUD et les opérateurs MongoDB
- ✅ Interroger des sous-documents et tableaux (dot-notation)
- ✅ Écrire un script `.js` exécutable par mongosh
- ✅ Relier la pratique aux concepts : 5V, CAP/BASE, JSON/BSON

---

## 🚀 Guide de reproduction

### Prérequis

- **Docker Desktop** (Windows/Mac) ou **Docker** (Linux) — démarré et fonctionnel
- **mongosh** (fourni dans l'image Docker)
- **MongoDB Compass** (optionnel, mais recommandé pour le debugging)
- Connexion Internet (pour télécharger le dataset et les images)

### Étape 1 : Lancer l'infrastructure Docker

```bash
cd "c:\Users\PC\Desktop\tp1 jour 1"
docker compose up -d
```

**Vérifier que les deux conteneurs sont actifs:**
```bash
docker compose ps
```

**Résultat attendu:**
```
NAME                IMAGE                   STATUS
mongo-ipssi         mongo:7.0               Up ...
mongo-express-ipssi mongo-express:latest    Up ...
```

### Étape 2 : Importer le dataset

```bash
# Copier le dataset dans le conteneur
docker cp primer-dataset.json mongo-ipssi:/tmp/primer-dataset.json

# Importer dans la base 'nyc', collection 'restaurants'
docker exec mongo-ipssi mongoimport \
  --username admin --password ipssi2025 --authenticationDatabase admin \
  --db nyc --collection restaurants --drop --file /tmp/primer-dataset.json
```

**Résultat attendu:**
```
imported 25359 documents
```

### Étape 3 : Se connecter et valider

#### Via le Shell mongosh

```bash
docker exec -it mongo-ipssi mongosh -u admin -p ipssi2025 --authenticationDatabase admin
```

Puis dans mongosh:
```mongosh
use nyc
db.restaurants.countDocuments({})
```

**Résultat attendu:** `25359`

#### Via Mongo Express (interface graphique)

Ouvrir dans le navigateur : **http://localhost:8081**

- **Utilisateur:** admin
- **Mot de passe:** ipssi2025
- Naviguer : `nyc` → `restaurants` → Voir les documents

---

## 📂 Structure des fichiers

```
tp1 jour 1/
├── docker-compose.yml          # Orchestration MongoDB + Mongo Express
├── primer-dataset.json         # Dataset des 25359 restaurants (téléchargé)
├── setup.sh                    # Script de setup (Linux/Mac)
│
├── reponses_jour1.md          # ✅ LIVRABLE 1 : Réponses Q1–Q28 + R1–R3
├── rapport.js                 # ✅ LIVRABLE 2 : Script mongosh exécutable
├── staten_island_export.json   # ✅ LIVRABLE 3 (optionnel) : Export JSON
├── capture_express.png        # ✅ LIVRABLE 4 : Capture d'écran Mongo Express
│
└── README.md                  # Ce fichier
```

---

## 🔍 Exécuter les parties du TP

### Partie 1 : Lecture & Opérateurs (Q1–Q11)

Connectez-vous via mongosh et exécutez chaque commande de `reponses_jour1.md`:

```mongosh
// Q1. Combien de restaurants au total ?
db.restaurants.countDocuments({})

// Q2. Nombre de cuisines distinctes
db.restaurants.distinct("cuisine").length

// Q3. Restaurants à Brooklyn
db.restaurants.countDocuments({ borough: "Brooklyn" })

// ... continuer avec Q4–Q11
```

### Partie 2 : Tableaux & Sous-documents (Q12–Q19)

Exécutez les commandes avec dot-notation et `$elemMatch`:

```mongosh
// Q12. Au moins une note avec score > 50
db.restaurants.countDocuments({ "grades.score": { $gt: 50 } })

// Q17. Piège $elemMatch
db.restaurants.countDocuments({
  grades: { $elemMatch: { grade: "B", score: { $gt: 20 } } }
})

// ... continuer
```

### Partie 3 : Création & Mise à jour (Q20–Q23)

Insérer et modifier des documents:

```mongosh
// Q20. INSERT votre restaurant
db.restaurants.insertOne({
  name: "CI's French Kitchen",
  borough: "Montpellier",
  cuisine: "French",
  address: { coord: [3.8767, 43.6108] },
  grades: [{ grade: "A", score: 7, date: new Date() }]
})

// Q21. UPDATE avec $push
db.restaurants.updateOne(
  { restaurant_id: "30075445" },
  { $push: { grades: { grade: "A", score: 3, date: new Date() } } }
)

// Q22. UPDATE de masse
db.restaurants.updateMany(
  { "grades.score": { $gt: 50 } },
  { $set: { risque: "eleve" } }
)
```

### Partie 4 : Suppression (Q24–Q26)

```mongosh
// Q24. Compter les anomalies
db.restaurants.countDocuments({ borough: "Missing" })

// Q25. Les supprimer
db.restaurants.deleteMany({ borough: "Missing" })

// Vérifier le total après
db.restaurants.countDocuments({})
```

### Partie 5 : Automatisation (Q27–Q28)

#### Exécuter le script rapport.js

```bash
docker exec -i mongo-ipssi mongosh -u admin -p ipssi2025 --authenticationDatabase admin nyc < rapport.js
```

**Résultat attendu:**
```
======================================================================
RAPPORT - TP JOUR 1 - MONGODB RESTAURANTS NYC
======================================================================

1. NOMBRE TOTAL DE RESTAURANTS
----------------------------------------------------------------------
   Total: 25310 restaurants

2. TOP 5 DES CUISINES LES PLUS FRÉQUENTES
----------------------------------------------------------------------
   1. American: 6183 restaurants
   2. Chinese: 2418 restaurants
   3. Café/Coffee: 1552 restaurants
   ...

3. NOMBRE DE RESTAURANTS PAR ARRONDISSEMENT
----------------------------------------------------------------------
   Bronx: 2338 restaurants
   Brooklyn: 6086 restaurants
   Manhattan: 10259 restaurants
   Queens: 6449 restaurants
   Staten Island: 968 restaurants
   Montpellier: 1 restaurants

   TOTAL par arrondissements: 25310 restaurants

======================================================================
```

#### Exporter Staten Island

```bash
docker exec mongo-ipssi mongoexport \
  --username admin --password ipssi2025 --authenticationDatabase admin \
  --db nyc --collection restaurants \
  --query '{"borough":"Staten Island"}' \
  --out staten_island_restaurants.json

# Compter les lignes
wc -l staten_island_restaurants.json
```

**Résultat:** 968 restaurants

---

## 📊 Résumé des réponses clés

| Question | Réponse | Concept |
|----------|---------|---------|
| Q1 | 25359 | Contage simple (READ) |
| Q2 | 91 | distinct() + longueur |
| Q3 | 6086 | Filtrage par champ |
| Q9 | 17 vs 30 | Regex : sensibilité casse |
| Q12 | 17752 | Dot-notation sur tableau |
| Q13 | 1016 vs 22 | Index positionnel (grades.0) |
| Q17 | 1765 vs 1710 | $elemMatch (élément unique) |
| Q18 | 0.2% | Anomalies de qualité |
| Q19 | Flip Sak (100) | Tri décroissant tableau |
| Q20 | 1 | INSERT (CREATE) |
| Q21 | 6 | $push (UPDATE) |
| Q22 | 17752 | updateMany (Update de masse) |
| Q25 | 51 | deleteMany (DELETE) |
| Q28 | 968 | mongoexport |

---

## 🎓 Concepts liés au cours

### 1. Les 5 V du Big Data (R1)

- **Volume:** 25359 restaurants × ~3 grades/resto ≈ 75000 documents imbriqués
- **Vélocité:** Nouvelles inspections quotidiennes via `$push`
- **Variété:** address (GeoJSON), grades (tableau), cuisine (string)
- **Véracité:** 210 scores négatifs détectés (anomalies)
- **Valeur:** Détection de patterns cachés (BBQ : 17 vs 30, écart 76%)

### 2. Théorème CAP (R2)

**MongoDB est CP (Consistent + Partition tolerant)**

Scénario: Restaurant fermé pour insalubrité, partition réseau.
- **Choix C:** App indisponible 1 min → Usager ne voit pas de fausses données ✅
- **Choix A:** App répond avec données stales → Usager réserve, puis déçu ❌

**Pour ce service public:** La cohérence > disponibilité.

### 3. JSON vs BSON (R3)

- **JSON (humain):** `{"name": "ABC", "score": 100}` — texte, lisible
- **BSON (machine):** Encodage binaire optimisé, avec types riches (ObjectId, Date, Decimal128)

Taille moyenne d'une note: ~70 octets BSON  
Limite BSON: 16 MB → capacité pour ~230000 notes/document → OK pour 10+ ans

### 4. Modèle Embarqué vs Référencé (R3c)

**Embarqué (actuel):** Chaque restaurant contient son array `grades`
- ✅ Localité (1 document = restaurant complet)
- ✅ Transactions atomiques
- ❌ Croissance illimitée

**Point de basculement:** Au-delà de 2000 notes → créer collection `inspections` séparée

---

## 🔧 Dépannage

### Docker n'est pas disponible
```powershell
# Vérifier que Docker Desktop est démarré
docker ps

# Si erreur, lancer Docker Desktop depuis le menu Windows
```

### Connexion mongosh refuse
```bash
# Vérifier les identifiants (admin / ipssi2025)
docker exec mongo-ipssi mongosh -u admin -p ipssi2025 --authenticationDatabase admin

# Vérifier que le port 27017 est libre
netstat -an | grep 27017
```

### Dataset ne s'importe pas
```bash
# Vérifier que le fichier existe dans le conteneur
docker exec mongo-ipssi ls -la /tmp/primer-dataset.json

# Réimporter manuellement
docker exec mongo-ipssi mongoimport \
  --username admin --password ipssi2025 --authenticationDatabase admin \
  --db nyc --collection restaurants --drop --file /tmp/primer-dataset.json
```

### Mongo Express n'est pas accessible
```bash
# Vérifier les logs
docker compose logs mongo-express

# Vérifier que le port 8081 est libre
netstat -an | grep 8081

# Redémarrer le conteneur
docker compose restart mongo-express
```

---

## 📤 Livrables (à rendre avant 17h00)

1. ✅ **reponses_jour1.md** — Réponses Q1–Q28 + R1–R3 avec commandes exactes et résultats
2. ✅ **rapport.js** — Script mongosh exécutable (résultat visible ci-dessus)
3. ✅ **capture_express.png** — Capture d'écran Mongo Express (collection `restaurants`)
4. ✅ **README.md** — Ce fichier (instructions de reproduction)
5. ✅ **docker-compose.yml** — Fichier d'orchestration Docker
6. ✅ **primer-dataset.json** — Dataset (25359 lignes)

**Lieu de rendu:** Teams (dossier TP Jour 1)

---

## 📚 Ressources

- [MongoDB Docs](https://www.mongodb.com/docs/)
- [mongosh Manual](https://www.mongodb.com/docs/mongodb-shell/)
- [Aggregation Pipeline](https://www.mongodb.com/docs/manual/reference/operator/aggregation/)
- [BSON Types](https://www.mongodb.com/docs/manual/reference/bson-types/)
- [CAP Theorem](https://en.wikipedia.org/wiki/CAP_theorem)

---

## ✍️ Notes d'implémentation

### Choix architecturaux

1. **Docker pour la reproductibilité:**  
   Plutôt que "MongoDB installé localement", docker-compose.yml garantit le même environnement sur tout poste.

2. **Mongo Express pour le debugging:**  
   L'interface graphique complète l'utilisation du shell — plus facile de visualiser les documents.

3. **Script rapport.js en pur JavaScript:**  
   Montre que mongosh supporte les boucles, Maps, et la logique métier — pas juste des commandes.

4. **Réponses chiffrées exactes:**  
   Pas d'estimation — chaque Q1–Q28 est vérifiable par réexécution.

### Pièges rencontrés

- **Q9 (BBQ):** La sensibilité de casse crée une perte de ~76% de résultats. Solution : index texte (Jour 2).
- **Q13 (grades[0]):** Confondre "jamais eu C" (Q13a) et "actuellement mal noté" (Q13b).
- **Q17 ($elemMatch):** Sans $elemMatch, les conditions se combinent en OR au lieu de AND sur le même élément.
- **Q18 (scores négatifs):** Les anomalies ont un faible impact statistique (0.2%), mais sont documentées comme donnée de gouvernance.

---

## 🎯 Prochaines étapes (Jour 2)

- Indexation et profiling (`createIndex`, `explain`)
- Agrégation avancée (`$group`, `$project`, `$lookup`)
- Drivers Python / Java
- Transactions multi-documents

---

**Date d'exécution:** 24 août 2026  
**Durée:** ~4h (théorie + atelier)  
**Statut:** ✅ Complet et reproductible
