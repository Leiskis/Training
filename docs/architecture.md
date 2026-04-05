# Arkkitehtuuri

## Yleiskuva

Sovellus on single-file web app (`index.html`, ~7700 riviä) joka sisältää kaiken HTML:n, CSS:n ja JavaScriptin. Backend on Supabase REST API johon kommunikoidaan custom-clientilla ilman SDK:ta.

```
index.html
├── <style>         CSS (~2700 riviä)
├── <body>          HTML-rakenne (~1200 riviä)
└── <script>        JavaScript (~3800 riviä)
    ├── Supabase REST client
    ├── Auth (login/register/logout)
    ├── Tab-navigointi
    ├── Treeniohjelmat (prog1/prog2/prog3)
    ├── Kalenteri & bottom sheet
    ├── Historia & analytiikka
    ├── Exercise picker
    ├── Drag & drop
    └── i18n (FI/EN)
```

## Navigointi

`showTab(id)` hallitsee valilehtinavigointia. Tabit:

| Tab ID | Kuvaus |
|--------|--------|
| `warmup` | Alkulammittelyliikkeet |
| `prog1` | Treeniohjelma 1 |
| `prog2` | Treeniohjelma 2 |
| `prog3` | Treeniohjelma 3 |
| `physio` | Fysioterapialiikkeet |
| `myprograms` | Omien ohjelmien hallinta |
| `calendar` | Kalenterinakymä |
| `history` | Historia + analytiikka |

Tab-bar on dynaaminen — `updateProgTabs()` nayttaa vain aktiiviset ohjelmat (emoji + nimi).

## Avainkomponentit

### Supabase REST Client

Custom client (`supa`) tiedoston alussa. Tukee:
- `.from('table').select/insert/update/delete` -ketjutuksen
- `Prefer: return=minimal` automaattisesti kaikissa muokkauksissa
- 401-vastauksella automaattinen token refresh + retry

### Treeniohjelmat

```
renderProgPage(slot)
├── Hakee ohjelman ID:n (progPageIdMap)
├── Hakee liikkeet (workout_day_exercises + exercise_library)
├── Renderoi sarja-rivit (set-checkbox per sarja)
├── Kiinnittaa event handlerit (checkbox, input, add/remove set)
├── Kutsuu restoreSetChecks() — palauttaa tilan cloudista
└── Kutsuu initDragHandles() — drag & drop liikkeille
```

### Kalenteri & Bottom Sheet

```
loadAndRenderCalendar()
├── Hakee sessions + workout_history
├── renderCalendar() — kuukausigrid
├── renderSessionsList() — paivan merkinnät
├── renderInsights() — effort/mood-jakaumat
└── updateStats() — tilastokortit

openSheet(dateStr)
├── Avaa bottom sheetin
├── Tyypin valinta (ohjelma/muu)
├── Fiilis + rasitustaso
├── Muistiinpano + ajastin
└── Tallennus → sessions + workout_history
```

### Historia & Analytiikka

Historia-valilehdessa on kaksi alinakymaa (`switchHistTab`):

**Historia-lista** (`renderHistoryList`):
- Listaa treenisessiot aikajärjestyksessä
- Klikkaamalla avautuu detail-nakyma sarja-tiedoilla

**Analytiikka** (`loadAndRenderAnalytics`):
- Painokehitys per liike (viivagraafi)
- Volyymi per liike (sets x reps x weight)
- Intensiteetti (% max painosta)
- Lihasryhmavolyymi (palkkikaavio)

### Exercise Picker

```
openExercisePicker(programId)
├── buildPickerCategories() — kategorianapit
├── buildPickerList() — createElement per liike (ei innerHTML)
├── Haku: debouncePickerSearch()
└── Valinta lisaa liikkeen ohjelmaan
```

### Drag & Drop

Touch-pohjainen geneerinen toteutus:
- `initDragHandles(listEl, handleSelector, cardSelector, saveCallback)`
- Document-tason listenerit rekisteroity KERRAN moduulitasolla
- requestAnimationFrame liikkeen aikana
- `_dragJustEnded` flag estaa click-eventin dropin jalkeen
- `_dragSaving` flag estaa paallekkaiset tallennukset
- Body scroll lock dragin aikana

### Sarjatason seuranta

Kaksi eri mallia:
- **Ohjelmasivut** (prog1/2/3): `.set-checkbox` → `set_checks` taulu (sarja-taso)
- **Warmup/physio**: `.ex-checkbox` → `exercise_checks` taulu (liiketaso)

`updateProgress()` kayttaa set-checkboxeja prioriteetissa, fallback ex-checkboxeihin.

### Cached Data

| Muuttuja | Ladataan | Funktio |
|----------|----------|---------|
| `userPrograms` | Kirjautumisessa | `loadUserPrograms()` |
| `exerciseLibrary` | Tarvittaessa (lazy) | `loadExerciseLibrary()` |
| `cachedSessions` | Kalenterin avautuessa | `loadAndRenderCalendar()` |
| `cachedHistory` | Historian avautuessa | `loadAndRenderHistory()` |
| `cachedAnalyticsData` | Analytiikan avautuessa | `loadAndRenderAnalytics()` |

## Treenin tallennusvirta

```
Kayttaja painaa "Tallenna" bottom sheetissa
└── closeSheet()
    ├── 1. Tallenna sessions-tauluun
    ├── 2. Lataa uudelleen → hae session ID
    └── 3. logWorkoutWithSnapshot(programId, ...)
        ├── Tallenna workout_history
        ├── Tallenna workout_history_exercises (liikkeet + painot)
        └── Tallenna workout_history_sets (sarja-tason snapshot)
```

## Re-render Lifecycle

Kun `renderProgPage()` kutsutaan:
1. `getOpenCardIds()` — tallenna avatut kortit
2. `saveUnsavedSetInputs()` — tallenna muokatut kentat
3. Renderoi uusi HTML (`innerHTML`)
4. Kiinnita event handlerit
5. `restoreSetChecks()` — palauta checkbox-tilat cloudista
6. `restoreOpenCards()` — avaa tallennetut kortit
