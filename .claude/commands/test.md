# Test — Testaa toiminnallisuus

Testaa `index.html`:n toiminnallisuus staattisella analyysillä.

## Tärkeät säännöt
- **Ole kriittinen** — älä merkitse ✅ OK jos et ole lukenut ja varmistanut koodia. "Näyttää oikealta" ei riitä.
- **Tarkista rivinumerot** — lue jokainen raportoitava kohta Read-työkalulla ennen raportointia.
- **Raportoi ongelmat, älä pelkkiä onnistumisia** — ⚠️ ja ❌ ovat arvokkaampaa tietoa kuin ✅.

## Tarkistukset

### Event handlerit
- Kaikki `addEventListener`-kutsut viittaavat olemassa oleviin elementti-ID:ihin
- Delegoidut handlerit (`initTabDelegation`, `initSheetDelegation`, `initPickerDelegation`) on kutsuttu `DOMContentLoaded`:ssa
- Event listenerit eivät ole duplikaatteja (sama elementti + sama event + sama handler)
- `querySelector` tulokset tarkistetaan ennen `.addEventListener()` kutsua (`?.` tai if-guard)

### Supabase-yhteys
- Supabase URL ja anon key ovat oikeassa muodossa
- `Prefer: return=minimal` on kaikissa insert/update/delete-kutsuissa
- 401-käsittely (token refresh) on paikallaan

### Navigointi
- `showTab(id)` — jokainen tab-ID vastaa olemassa olevaa DOM-elementtiä
- Progress bar näkyy vain ohjelmasivuilla (prog1/prog2/prog3)

### Datavirta
- `logWorkoutWithSnapshot()` tallentaa sekä `workout_history` että `workout_history_exercises`
- `renderProgPage(slot)` hakee oikean ohjelman ja renderöi liikkeet
- `buildPickerList()` rakentaa elementit `createElement`:llä (ei innerHTML)
- Async `.then()` -ketjuissa on `.catch()` virheenkäsittely

### Käännökset
- `t('key')` palauttaa aina stringin (ei undefined)
- `currentLang` on 'fi' tai 'en'

## Raportti
Listaa löydöt:
| # | Tila | Tarkistus | Huomio |
Käytä: ✅ OK, ⚠️ varoitus, ❌ virhe

**Älä raportoi pelkkiä ✅-rivejä** — keskity ongelmiin. Listaa ✅ vain lyhyenä yhteenvetona lopussa.
