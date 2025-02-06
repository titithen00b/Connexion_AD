# Définir les paramètres
$1ogName = "Security"
$eventID = 4624 # Connexion réussie
$username = "Administrateur"

# Définir la période de recherche (YYYY-MM-DD HH:mm:ss)
$dateDebut = Get-Date "2025-02-04 00:00:00"
$dateFin   = Get-Date "2025-02-06 23:59:59"

# Filtrage optimisé

$filter = @{
    LogName     = $logName
    ID          = $eventID
    StartTime   = $dateDebut
    EndTime     = $dateFin
}

# Récupération des logs
$logins = Get-WinEvent -FilterHashtable $filter -ErrorAction SilentlyContinue | Where-Object {
    $_.Properties[5].Value -eq $username
}

# Vérification et affichage
if ($logins) {
    $logins | ForEach-Object {
        [PSCustomObject]@{
            TimeCreated = $_.TimeCreated
            User        = $_.Properties[5].Value
            Domaine     = $_.Properties[6].Value
            LogonType   = $_.Properties[8].Value
            IPAddress   = $_.Properties[18].Value
        }
    } | Format-Table -AutoSize
} else {
    Write-Host "Aucune connexion réussie trouvée pour '$username' entre $dateDebut et $dateFin."
}
