# Kehitys

## Ymparisto

- **Editori**: Claude Code (CLI)
- **Selain**: Safari / Chrome (mobiilitestaus)
- **Deploy**: `git push origin main` → GitHub Actions → GitHub Pages
- **Ei build-vaihetta** — index.html toimii sellaisenaan

## Koodisaannot

### JavaScript

- **EI inline onclick** — kaikki event handlerit `addEventListener`:lla
- **EI innerHTML + kayttajadata** — XSS-riski, kayta `esc()` tai `textContent`
- **EI while(true)** — kayta safety limit -muuttujaa
- **EI console.log** — kayta `log.info()`, `log.ok()`, `log.error()`, `log.warn()`
- **EI CSS.escape()** querySelector:issa kun HTML kayttaa `esc()` — ne eivat tasmaa
- **currentUser guard** async funktioissa jotka tekevat DB-kutsuja

### CSS

- **EI transition: all** — kayta spesifisia propertyta (drag & drop -yhteensopivuus)
- **Input font-size min 16px** — estaa iOS auto-zoom
- **Touch targets min 44x44px**
- Kayta CSS custom propertyta (`var(--gold)` jne.)

### Supabase

- Kaikki insert/update/delete: `Prefer: return=minimal`
- Kaikki update/delete: `.eq('user_id', currentUser.id)`
- Token refresh automaattinen 401-vastauksella
- Tyhja kentta → `null` (ei tyhja string)

### Re-render

Kun `renderProgPage()` tai muu renderointifunktio kutsutaan:
1. Tallenna avoimet kortit: `getOpenCardIds()`
2. Tallenna muokatut inputit: `saveUnsavedSetInputs()`
3. Renderoi
4. Palauta tilat: `restoreOpenCards()`, `restoreSetChecks()`

### Drag & Drop

- Document-tason listenerit KERRAN moduulitasolla
- `requestAnimationFrame` liikkeen aikana
- `_dragJustEnded` flag + setTimeout estaa click-konfliktin
- Body `overflow: hidden` dragin aikana
- Ei `transition: all` draggable-elementeissa

## Testaus

Kirjautumissivun ohittaminen testauksessa:
1. Muuta `authOverlay` style → `display:none`
2. **Palauta ennen deployta!**

Konsolilokit:
```javascript
log.info('viesti')   // informatiivinen
log.ok('viesti')     // onnistuminen
log.error('viesti')  // virhe
log.warn('viesti')   // varoitus
```

## Deploy

### Manuaalinen

```bash
# Tarkista muutokset
git status
git diff

# Deploy
/deploy "Commit-viesti tähän"
```

### Automaattinen

GitHub Actions ajaa deployn automaattisesti kun `main`-branchiin pusketaan. Workflow: `.github/workflows/deploy.yml`.

### Tarkistuslista ennen deployta

- [ ] `authOverlay` ei ole piilotettu (display:none)
- [ ] Ei `// TESTING` -kommentteja
- [ ] Ei `console.log` -kutsuja
- [ ] `/pipeline` ajettu — ei kriittisia loydoksia

## PWA

Sovellus on Progressive Web App:
- **manifest.json** — nimi, ikonit, vari, display mode
- **sw.js** — Service Worker (cache-first strategia)
- **Ikonit**: icon-192.png, icon-512.png (maskable)
- Asennettavissa kotinaytolle iOS:ssa ja Androidissa

## Apple Watch

Companion-appi: `TrainingWatch/` (SwiftUI)
- Kayttaa samaa Supabase-backendia
- Sarja-tason seuranta ranteesta
- Tarkista yhteensopivuus: `/watch-sync`

## Tiedostorakenne

```
Training/
├── index.html              # Koko sovellus
├── manifest.json           # PWA manifest
├── sw.js                   # Service Worker
├── icon-192.png            # PWA ikoni
├── icon-512.png            # PWA ikoni
├── CLAUDE.md               # Claude Code -ohjeet
├── README.md               # Projektin kuvaus
├── docs/                   # Dokumentaatio
│   ├── architecture.md
│   ├── database.md
│   ├── ui.md
│   ├── agents.md
│   └── development.md
├── .claude/
│   └── commands/           # 25 agenttikomentoa
│       ├── deploy.md
│       ├── pipeline.md
│       ├── test.md
│       └── ...
└── .github/
    └── workflows/
        └── deploy.yml      # GitHub Actions
```
