# Kayttoliittyma

## Teemat

Sovellus tukee dark ja light -teemaa. Teema tallennetaan `localStorage`:en.

### Dark Mode (oletus)

| Muuttuja | Arvo | Kayttö |
|----------|------|--------|
| `--bg` | `#0e0e0e` | Taustaväri |
| `--surface` | `#181818` | Korttien tausta |
| `--surface2` | `#222222` | Inputit, sekundaariset pinnat |
| `--border` | `#252525` | Reunaviivat |
| `--gold` | `#c8a84b` | Aksenttiväri (napit, aktiivinen tab) |
| `--gold-dim` | `rgba(200,168,75,0.15)` | Korostettu tausta |
| `--text` | `#f2efe8` | Teksti |
| `--muted` | `#999` | Toissijainen teksti |
| `--radius` | `14px` | Korttien border-radius |
| `--blue` | `#4a9eca` | Fysioterapia-aksentti |

### Light Mode

Vaalea teema kaantaa paletin: vaaleat taustat, tummat tekstit, lamminsavyinen tausta (`#ede8d8`).

## Typografia

| Fontti | Kayttö |
|--------|--------|
| **Bebas Neue** | Otsikot, osioiden nimet, kategoriaotsikot |
| **DM Sans** | Kaikki muu teksti, napit, inputit |

## Komponentit

### Tab Bar
- Vaakasuora scrollattava rivi
- Aktiivinen tab: gold-tausta, valkoinen teksti
- Dynaamiset prog-tabit nayttavat emoji + nimen

### Kortit (Cards)
- Avattava/suljettava `.card-header` + `.card-body`
- Tumma tausta, pyoristetyt kulmat (`--radius`)
- `toggleCard()` animoi avautumisen

### Set-rivi (Prog)
- Grid: `#numero | checkbox | toistot | paino`
- Pyorea custom checkbox (vihrea checkmark)
- Tehty-sarja himmennetty (`opacity: 0.5`)

### Bottom Sheet
- Liukuu ylös backdrop-efektilla
- Kalenteri-merkinnöt, fiilis, rasitustaso
- Ajastin (start/stop/reset)

### Exercise Picker
- Full-screen bottom sheet
- Kategoriasuodatus + hakukentta
- `createElement`-pohjainen renderöinti (ei innerHTML)

### Progress Bar
- Näkyy vain ohjelmasivuilla (prog1/2/3)
- Gold-palkkl joka taytyy sarjojen edetessa

### Graafit (Analytiikka)
- Canvas-pohjaiset viivagraafit (`drawLineChart`)
- Kolme moodia: Paino / Volyymi / Intensiteetti
- Lihasryhmavolyymi palkkikaaviona

## Effort & Mood

### Rasitustaso (effort_feeling)

| Arvo | Label | Väri |
|------|-------|------|
| easy | 😌 Helppo | `#3dba6e` |
| good | 💪 Hyva | `#4a9eca` |
| hard | 😤 Raskas | `#e8864a` |
| exhausting | 🥵 Uuvuttava | `#e05555` |

### Fiilis (post_workout_mood)

| Arvo | Label | Väri |
|------|-------|------|
| great | 🌟 Mahtava | `#c8a84b` |
| energized | ⚡ Energinen | `#3dba6e` |
| neutral | 😐 Neutraali | `#888` |
| tired | 😴 Vasynyt | `#e8864a` |
| stressed | 😰 Stressaantunut | `#e05555` |

## Mobiili-huomiot

- **Touch targets**: Min 44x44px kaikille interaktiivisille elementeille
- **Input font-size**: Min 16px (estaa iOS auto-zoom)
- **Safe area insets**: Bottom sheet ja tab bar huomioivat notch/home indicator
- **-webkit-tap-highlight-color**: transparent kaikkialla
- **overflow: hidden**: Body scroll lock dragin ja modaalien aikana
- **transition**: Ei `transition: all` — aina spesifiset propertyt (drag & drop -yhteensopivuus)

## i18n

Kaksikielinen UI: suomi (FI) ja englanti (EN).

- `t('key')` — kaannosfunktio, palauttaa aina stringin
- `currentLang` — `'fi'` tai `'en'`
- `applyTranslations()` — paivittaa staattiset tekstit
- Toggle-nappi headerissa
- Kieli tallennetaan `localStorage`:en
