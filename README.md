# Personal Training

Henkilokohtainen treenisovellus voimaharjoittelun seurantaan. Single-file web app, joka toimii mobiilissa kuntosalilla yhden kaden kaytolla.

**Live**: [leiskis.github.io/Training](https://leiskis.github.io/Training/)

## Ominaisuudet

- **Treeniohjelmat** — Luo ja muokkaa ohjelmia, lisaa liikkeita kirjastosta, jarjesta drag & dropilla
- **Sarjatason seuranta** — Merkkaa jokainen sarja tehdyksi, kirjaa toteutuneet painot ja toistot
- **Kalenteri** — Merkitse treenipaivia, valitse fiilis ja rasitustaso
- **Historia & analytiikka** — Painokehitysgraafit, volyymi, intensiteetti, lihasryhmavolyymi
- **Apple Watch** — Companion-appi treenin seurantaan ranteesta
- **PWA** — Asennettavissa kotinaytolle, offline-tuki
- **FI/EN** — Kaksikielinen kayttoliittyma
- **Dark/Light** — Teemavalitsin

## Tech Stack

| Komponentti | Teknologia |
|------------|-----------|
| Frontend | Vanilla HTML/CSS/JS (single-file `index.html`) |
| Backend | [Supabase](https://supabase.com) REST API (custom client, ei SDK) |
| Hosting | GitHub Pages (automaattinen deploy) |
| CI/CD | GitHub Actions |
| Watch | SwiftUI (TrainingWatch) |

## Dokumentaatio

| Dokumentti | Kuvaus |
|-----------|--------|
| [Arkkitehtuuri](docs/architecture.md) | Sovelluksen rakenne, funktiot, datavirta |
| [Tietokanta](docs/database.md) | Supabase-taulut, sarakkeet, RLS |
| [Kayttoliittyma](docs/ui.md) | Teemat, komponentit, CSS-muuttujat |
| [Agentit](docs/agents.md) | Claude Code -agenttikomennot |
| [Kehitys](docs/development.md) | Kehitysymparisto, saannot, deploy |

## Pikastartti

```bash
# Kloonaa repo
git clone https://github.com/leiskis/Training.git
cd Training

# Avaa selaimessa
open index.html
```

Sovellus toimii suoraan selaimessa — ei build-vaihetta, ei riippuvuuksia.

## Lisenssi

Yksityinen projekti.
