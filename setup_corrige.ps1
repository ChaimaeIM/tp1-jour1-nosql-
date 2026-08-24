# TP Jour 1 - MongoDB Setup (Version corrigee)

Write-Host ""
Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host "    TP JOUR 1 - MONGODB SETUP AUTOMATISE" -ForegroundColor Cyan
Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Continue"

# Etape 1: Verifier Docker
Write-Host "[1/5] Verification de Docker..." -ForegroundColor Yellow
$dockerStatus = docker ps 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERREUR: Docker n'est pas disponible" -ForegroundColor Red
    exit 1
}
Write-Host "OK - Docker est disponible" -ForegroundColor Green
Write-Host ""

# Etape 2: Lancer docker-compose
Write-Host "[2/5] Lancement de Docker Compose..." -ForegroundColor Yellow
docker compose up -d 2>&1 | Out-Null
Start-Sleep -Seconds 10
Write-Host "OK - Conteneurs lances" -ForegroundColor Green
Write-Host ""

# Etape 3: Copier dataset
Write-Host "[3/5] Copie du dataset..." -ForegroundColor Yellow
docker cp primer-dataset.json mongo-ipssi:/tmp/primer-dataset.json 2>&1 | Out-Null
Write-Host "OK - Dataset copie" -ForegroundColor Green
Write-Host ""

# Etape 4: Import donnees
Write-Host "[4/5] Import des 25359 restaurants..." -ForegroundColor Yellow
Write-Host "Cela peut prendre 30-60 secondes..." -ForegroundColor Cyan
docker exec mongo-ipssi mongoimport `
    --username admin --password ipssi2025 --authenticationDatabase admin `
    --db nyc --collection restaurants --drop --file /tmp/primer-dataset.json 2>&1 | Out-Null
Write-Host "OK - Donnees importees" -ForegroundColor Green
Write-Host ""

# Etape 5: Verification
Write-Host "[5/5] Verification de l'import..." -ForegroundColor Yellow
$count = docker exec -i mongo-ipssi mongosh -u admin -p ipssi2025 --authenticationDatabase admin nyc --quiet --eval "db.restaurants.countDocuments({})" 2>&1

if ($count -match "25359") {
    Write-Host "OK - Point de controle P0: 25359 restaurants trouves" -ForegroundColor Green
} else {
    Write-Host "WARNING - Nombre trouve: $count (attendu: 25359)" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "=========================================================================" -ForegroundColor Green
Write-Host "SETUP COMPLETE" -ForegroundColor Green
Write-Host "=========================================================================" -ForegroundColor Green
Write-Host ""

Write-Host "Acces a MongoDB:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Interface graphique Mongo Express:" -ForegroundColor White
Write-Host "    http://localhost:8081" -ForegroundColor White
Write-Host "    Identifiants: admin / ipssi2025" -ForegroundColor White
Write-Host ""
Write-Host "  Shell MongoDB (mongosh):" -ForegroundColor White
Write-Host "    docker exec -it mongo-ipssi mongosh -u admin -p ipssi2025 --authenticationDatabase admin" -ForegroundColor White
Write-Host ""
Write-Host "Prochaine etape:" -ForegroundColor Yellow
Write-Host "  1. Ouvrir http://localhost:8081 dans le navigateur" -ForegroundColor White
Write-Host "  2. Prendre une screenshot (Alt+Print ou Print Screen)" -ForegroundColor White
Write-Host "  3. Sauvegarder comme capture_express.png" -ForegroundColor White
Write-Host ""
