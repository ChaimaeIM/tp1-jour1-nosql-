// TP Jour 1 - Rapport MongoDB
// Auteur: Chaimae IMRANI (IPSSI Compus Nice)
// Script exécutable: mongosh < rapport.js

print("=".repeat(70));
print("RAPPORT - TP JOUR 1 - MONGODB RESTAURANTS NYC");
print("=".repeat(70));
print("");

// Utiliser la base nyc
use("nyc");

// ============================================================================
// 1. NOMBRE TOTAL DE RESTAURANTS
// ============================================================================
print("1. NOMBRE TOTAL DE RESTAURANTS");
print("-".repeat(70));

const totalRestaurants = db.restaurants.countDocuments({});
print(`   Total: ${totalRestaurants} restaurants`);
print("");

// ============================================================================
// 2. TOP 5 DES CUISINES LES PLUS FRÉQUENTES
// ============================================================================
print("2. TOP 5 DES CUISINES LES PLUS FRÉQUENTES");
print("-".repeat(70));

// Récupérer tous les types de cuisine
const allCuisines = db.restaurants.distinct("cuisine");

// Créer une Map avec les comptages
const cuisineMap = new Map();
for (const cuisine of allCuisines) {
  const count = db.restaurants.countDocuments({ cuisine: cuisine });
  cuisineMap.set(cuisine, count);
}

// Trier par fréquence décroissante et prendre le top 5
const sortedCuisines = Array.from(cuisineMap.entries())
  .sort((a, b) => b[1] - a[1])
  .slice(0, 5);

let rank = 1;
for (const [cuisine, count] of sortedCuisines) {
  print(`   ${rank}. ${cuisine}: ${count} restaurants`);
  rank++;
}
print("");

// ============================================================================
// 3. NOMBRE DE RESTAURANTS PAR ARRONDISSEMENT
// ============================================================================
print("3. NOMBRE DE RESTAURANTS PAR ARRONDISSEMENT");
print("-".repeat(70));

// Récupérer tous les arrondissements
const allBoroughs = db.restaurants.distinct("borough");

// Créer une Map avec les comptages
const boroughMap = new Map();
for (const borough of allBoroughs) {
  const count = db.restaurants.countDocuments({ borough: borough });
  boroughMap.set(borough, count);
}

// Trier par arrondissement (alphabétique)
const sortedBoroughs = Array.from(boroughMap.entries())
  .sort((a, b) => a[0].localeCompare(b[0]));

let totalByBorough = 0;
for (const [borough, count] of sortedBoroughs) {
  print(`   ${borough}: ${count} restaurants`);
  totalByBorough += count;
}
print("");
print(`   TOTAL par arrondissements: ${totalByBorough} restaurants`);
print("");

// ============================================================================
// RÉSUMÉ FINAL
// ============================================================================
print("=".repeat(70));
print("RÉSUMÉ FINAL");
print("=".repeat(70));
print(`Total général: ${totalRestaurants} restaurants`);
print(`Cuisines détectées: ${allCuisines.length} types différents`);
print(`Arrondissements: ${allBoroughs.length} zones`);
print("");
print("✓ Rapport généré avec succès");
print("=".repeat(70));
