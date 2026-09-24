# Amplifon Assets

Repository pubblica degli asset statici utilizzati dalle landing Amplifon / EarPros.

## Regola fondamentale: asset legacy nella root

I file presenti direttamente nella root della repository possono essere giÃ  utilizzati da landing page live.

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

Asset realmente condivisi tra piÃ¹ mercati, per esempio logo Amplifon, icone comuni e badge.

### `<country>/common/`

Asset riutilizzati da piÃ¹ landing dello stesso mercato.

### `<country>/<page>/`

Asset specifici di una landing. Per esempio:

```text
de/de365/hero/hero-v1.jpg
de/de365/content/hearing-aid-v1.jpg
de/de365/reviews/google-reviews-v1.png
```

Per i mercati in cui non Ã¨ ancora necessario creare una cartella per pagina viene mantenuta temporaneamente la directory `pages/`.

## Versionamento dei file

Per i nuovi asset evitare di sostituire un file giÃ  utilizzato da una landing live.

Preferire nomi versionati:

```text
hero-v1.jpg
hero-v2.jpg
advisor-v1.png
google-reviews-v1.png
```

Quando cambia una creativitÃ , caricare un nuovo file e aggiornare la configurazione della landing.

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
