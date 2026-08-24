# TP Jour 1 - MongoDB et NoSQL

**Module:** MIA4 - Conception et integration d'un SGBD NoSQL  
**Etudiant:** Chaimae IMRANI (IPSSI Compus Nice)  
**Date:** 24 aout 2026

---

## Resume

Ce travail pratique couvre l'introduction a MongoDB et aux principes NoSQL. Il inclut :

- 28 questions (Q1-Q28) avec commandes mongosh exactes et resultats
- 3 questions de reflexion theorique (R1-R3) sur les 5V, CAP/BASE, et modeles embarques
- Un script rapport.js executable
- Une infrastructure Docker reproducible avec docker-compose.yml
- Import de 25359 restaurants de New York

---

## Livrables

1. **reponses_jour1.md** - Reponses Q1-Q28 + R1-R3
2. **rapport.js** - Script mongosh executable
3. **docker-compose.yml** - Configuration Docker
4. **README.md** - Ce fichier
5. **capture_express.png** - Screenshot Mongo Express

---

## Lancement rapide

```bash
cd "c:\Users\PC\Desktop\tp1 jour 1"

# Lancer Docker Compose
docker compose up -d

# Importer les donnees
docker cp primer-dataset.json mongo-ipssi:/tmp/primer-dataset.json
docker exec mongo-ipssi mongoimport --username admin --password ipssi2025 --authenticationDatabase admin --db nyc --collection restaurants --drop --file /tmp/primer-dataset.json

# Verifier
docker exec -it mongo-ipssi mongosh -u admin -p ipssi2025 --authenticationDatabase admin
use nyc
db.restaurants.countDocuments({})
```

---

## Concepts cles

- **CRUD:** Create, Read, Update, Delete
- **Operateurs:** $gt, $lt, $in, $exists, $size, $elemMatch
- **Dot-notation:** "address.zipcode", "grades.score"
- **CAP Theorem:** MongoDB est CP (Coherence + Partition tolerant)
- **Les 5 V:** Volume, Velocite, Variete, Veracite, Valeur
- **JSON vs BSON:** Format texte vs binaire

---

## Resultats clés

| Question | Reponse | Concept |
|----------|---------|---------|
| Q1 | 25359 restaurants | Contage simple |
| Q2 | 91 cuisines distinctes | distinct() |
| Q9 | 17 vs 30 | Regex case-sensitive |
| Q13 | 1016 vs 22 | Index positionnel |
| Q17 | 1765 vs 1710 | $elemMatch piege |
| Q28 | 968 restaurants | mongoexport |

---

## Technologies

- MongoDB 7.0
- Docker / Docker Compose
- Mongo Express (interface graphique)
- mongosh (shell interactif)

---

**Statut:** Complet et reproductible
