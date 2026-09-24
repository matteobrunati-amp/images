$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "AMPLIFON IMAGES - setup struttura repository" -ForegroundColor Cyan
Write-Host "Nessun file gia presente nella root verra spostato, rinominato o eliminato." -ForegroundColor Yellow
Write-Host ""

# Verifica repository Git
if (-not (Test-Path ".git")) {
    throw "Questa cartella non sembra essere una repository Git. Apri PowerShell nella cartella locale della repository matteobrunati-amp/images."
}

$remote = git remote get-url origin 2>$null
if (-not $remote) {
    throw "Remote 'origin' non trovato."
}
if ($remote -notmatch "matteobrunati-amp/images") {
    throw "Repository inattesa: $remote. Lo script e previsto per matteobrunati-amp/images."
}

# Evita di procedere con modifiche locali non salvate
$status = git status --porcelain
if ($status) {
    Write-Host "Ci sono modifiche locali non salvate:" -ForegroundColor Red
    Write-Host $status
    throw "Fai commit/stash delle modifiche prima di eseguire lo script."
}

# Aggiorna main
git checkout main
git pull origin main

$branch = "chore/assets-structure-v1"

# Se la branch locale esiste gia, fermati per evitare comportamenti inattesi
$existing = git branch --list $branch
if ($existing) {
    throw "La branch '$branch' esiste gia localmente. Eliminala o usa quella esistente."
}

git checkout -b $branch

# Nuova struttura. I file legacy gia presenti in root NON vengono toccati.
$folders = @(
    "common/logos",
    "common/icons",
    "common/google",
    "common/ui",

    "de/common",
    "de/de365/hero",
    "de/de365/content",
    "de/de365/reviews",
    "de/de365/icons",

    "it/common",
    "it/pages",

    "fr/common",
    "fr/pages",

    "es/common",
    "es/pages",

    "au/common",
    "au/pages",

    "uk/common",
    "uk/pages",

    "us/common",
    "us/pages"
)

foreach ($folder in $folders) {
    New-Item -ItemType Directory -Path $folder -Force | Out-Null

    # Git non versiona cartelle vuote: .gitkeep rende visibile la struttura.
    $keep = Join-Path $folder ".gitkeep"
    if (-not (Test-Path $keep)) {
        New-Item -ItemType File -Path $keep | Out-Null
    }
}

$readme = @'
# Amplifon Assets

Repository pubblica degli asset statici utilizzati dalle landing Amplifon / EarPros.

## Regola fondamentale: asset legacy nella root

I file presenti direttamente nella root della repository possono essere già utilizzati da landing page live.

**Non spostare, rinominare, sostituire o eliminare questi file senza avere prima verificato tutte le dipendenze live.**

La nuova struttura viene aggiunta accanto agli asset legacy. Nessun file storico viene migrato automaticamente.

## Struttura per i nuovi asset

```text
common/
  logos/
  icons/
  google/
  ui/

de/
  common/
  de365/
    hero/
    content/
    reviews/
    icons/

it/
  common/
  pages/

fr/
  common/
  pages/

es/
  common/
  pages/

au/
  common/
  pages/

uk/
  common/
  pages/

us/
  common/
  pages/
```

### `common/`

Asset realmente condivisi tra più mercati, per esempio logo Amplifon, icone comuni e badge.

### `<country>/common/`

Asset riutilizzati da più landing dello stesso mercato.

### `<country>/<page>/`

Asset specifici di una landing. Per esempio:

```text
de/de365/hero/hero-v1.jpg
de/de365/content/hearing-aid-v1.jpg
de/de365/reviews/google-reviews-v1.png
```

Per i mercati in cui non è ancora necessario creare una cartella per pagina viene mantenuta temporaneamente la directory `pages/`.

## Versionamento dei file

Per i nuovi asset evitare di sostituire un file già utilizzato da una landing live.

Preferire nomi versionati:

```text
hero-v1.jpg
hero-v2.jpg
advisor-v1.png
google-reviews-v1.png
```

Quando cambia una creatività, caricare un nuovo file e aggiornare la configurazione della landing.

## URL

Base repository:

```text
https://raw.githubusercontent.com/matteobrunati-amp/images/main/
```

Esempio:

```text
https://raw.githubusercontent.com/matteobrunati-amp/images/main/de/de365/hero/hero-v1.jpg
```

Nel framework Amplifon gli URL degli asset devono essere definiti nella configurazione della pagina e non hardcodati nel renderer.

## Sicurezza

Questa repository deve contenere esclusivamente asset pubblici destinati al browser.

Non inserire:
- API key;
- token;
- password;
- dati personali;
- file riservati.

## Modifiche

Per i nuovi interventi:
1. creare una branch;
2. aggiungere i nuovi asset senza modificare quelli legacy;
3. aprire una Pull Request;
4. verificare gli URL delle landing interessate;
5. eseguire il merge solo dopo il controllo.
'@

Set-Content -Path "README.md" -Value $readme -Encoding UTF8

git add .

$changed = git status --porcelain
if (-not $changed) {
    Write-Host "Nessuna modifica da committare." -ForegroundColor Yellow
    exit 0
}

git commit -m "Add structured asset directories without moving legacy files"
git push -u origin $branch

Write-Host ""
Write-Host "Operazione completata." -ForegroundColor Green
Write-Host "I file legacy nella root non sono stati modificati." -ForegroundColor Green
Write-Host ""
Write-Host "Apri la Pull Request qui:" -ForegroundColor Cyan
Write-Host "https://github.com/matteobrunati-amp/images/compare/main...$branch?expand=1"
