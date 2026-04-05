# Personal Training App

## Projekti
Single-file web app: `index.html`  
Hosted: https://leiskis.github.io/Training/  
Backend: Supabase (REST API, ei SDK)

## Stack
- Vanilla HTML/CSS/JS — ei frameworkeja
- Custom Supabase REST client (tiedostossa `index.html`)
- GitHub Pages deploy (automaattinen GitHub Actions)

## Supabase
- URL: `https://azgraotogacudqpuahrz.supabase.co`
- Taulut: `sessions`, `exercise_library`, `workout_programs`, `workout_day_exercises`, `workout_history`, `workout_history_exercises`, `exercise_checks`, `set_checks`, `workout_history_sets`
- RLS käytössä kaikissa tauluissa

## Tärkeät periaatteet
- **EI inline onclick** — kaikki event handlerit `addEventListener`:llä
- **EI innerHTML + user data** — XSS-riski, käytä `esc()`
- **EI while(true)** — käytä safety limit muuttujaa
- **EI `transition: all`** CSS:ssä — käytä spesifisiä propertyjä (drag & drop -yhteensopivuus)
- **EI `CSS.escape()`** querySelector:issa kun HTML käyttää `esc()` — ne eivät täsmää
- **Re-render säilytä korttien tila** — `getOpenCardIds()` + `restoreOpenCards()`
- **Input-arvot ennen re-renderiä** — `saveUnsavedSetInputs()` tallentaa muokatut kentät
- Kaikki DB-operaatiot: insert/update/delete käyttää `Prefer: return=minimal`
- Token refresh automaattinen 401-vastauksella
- Input font-size vähintään 16px (iOS zoom-esto)

## Arkkitehtuuri
- `showTab(id)` — navigointi välilehtien välillä
- `initTabDelegation()` — nav-napit (dynaaminen tab-bar aktiivisilla ohjelmilla)
- `initSheetDelegation()` — kalenteri bottom sheet
- `initPickerDelegation()` — liikepikeri (no-op, käyttää buildPickerList)
- `buildPickerList()` — rakentaa pickerin createElement:llä
- `renderProgPage(slot)` — renderöi ohjelmasivun sarja-riveillä (set-checkbox per sarja)
- `updateProgTabs()` — päivittää tab-barin aktiivisilla ohjelmilla (emoji + nimi)
- `loadAndRenderProgramExercises(programId)` — omat ohjelmat detail view
- `logWorkoutWithSnapshot()` — tallentaa treenin + snapshot historiaan (workout_history + workout_history_exercises + workout_history_sets)
- `restoreSetChecks()` — palauttaa sarja-checkboxit cloudista
- `initDragHandles()` — geneerinen drag & drop (ohjelmat + liikkeet)

## Sarjatason seuranta
- Prog-sivuilla: `.set-checkbox` per sarja → `set_checks` taulu
- Warmup/physio: `.ex-checkbox` per liike → `exercise_checks` taulu (vanha)
- `updateProgress()` käyttää set-checkboxeja prioriteetissa, fallback ex-checkboxeihin
- Historia: `workout_history_sets` näyttää sarja-rivit, fallback vanhaan liike-tasoon

## Kieli
- UI: suomi (FI) / englanti (EN) toggle
- `t('key')` — käännösfunktio
- `currentLang` — 'fi' tai 'en'

## Testauksessa
- Kirjautumissivu: palauta ennen julkaisua muuttamalla `authOverlay` style takaisin
- Console lokit: `log.info()`, `log.ok()`, `log.error()`, `log.warn()`
