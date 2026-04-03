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
- Taulut: `sessions`, `exercise_library`, `workout_programs`, `workout_day_exercises`, `workout_history`, `workout_history_exercises`, `exercise_checks`
- RLS käytössä kaikissa tauluissa

## Tärkeät periaatteet
- **EI inline onclick** — kaikki event handlerit `addEventListener`:llä
- **EI innerHTML + user data** — XSS-riski
- **EI while(true)** — käytä safety limit muuttujaa
- Kaikki DB-operaatiot: insert/update/delete käyttää `Prefer: return=minimal`
- Token refresh automaattinen 401-vastauksella

## Arkkitehtuuri
- `showTab(id)` — navigointi välilehtien välillä
- `initTabDelegation()` — nav-napit
- `initSheetDelegation()` — kalenteri bottom sheet
- `initPickerDelegation()` — liikepikeri (no-op, käyttää buildPickerList)
- `buildPickerList()` — rakentaa pickerin createElement:llä
- `renderProgPage(slot)` — renderöi ohjelmasivun (prog1/2/3) tietokannasta
- `loadAndRenderProgramExercises(programId)` — omat ohjelmat detail view
- `logWorkoutWithSnapshot()` — tallentaa treenin + snapshot historiaan

## Kieli
- UI: suomi (FI) / englanti (EN) toggle
- `t('key')` — käännösfunktio
- `currentLang` — 'fi' tai 'en'

## Testauksessa
- Kirjautumissivu: palauta ennen julkaisua muuttamalla `authOverlay` style takaisin
- Console lokit: `log.info()`, `log.ok()`, `log.error()`, `log.warn()`
