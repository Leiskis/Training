# Test — Testaa toiminnallisuus

Testaa `index.html`:n toiminnallisuus staattisella analyysillä.

## Tärkeät säännöt
- **Ole kriittinen** — älä merkitse ✅ OK jos et ole lukenut ja varmistanut koodia. "Näyttää oikealta" ei riitä.
- **Tarkista rivinumerot** — lue jokainen raportoitava kohta Read-työkalulla ennen raportointia.
- **Raportoi ongelmat, älä pelkkiä onnistumisia** — ⚠️ ja ❌ ovat arvokkaampaa tietoa kuin ✅.
- **Simuloi runtime** — käy koodi läpi ikään kuin ajaisit sitä päässäsi. Pelkkä syntaksin lukeminen ei riitä.

## Tarkistukset

### Event handlerit
- Kaikki `addEventListener`-kutsut viittaavat olemassa oleviin elementti-ID:ihin
- Delegoidut handlerit (`initTabDelegation`, `initSheetDelegation`, `initPickerDelegation`) on kutsuttu `DOMContentLoaded`:ssa
- Event listenerit eivät ole duplikaatteja (sama elementti + sama event + sama handler)
- `querySelector` tulokset tarkistetaan ennen `.addEventListener()` kutsua (`?.` tai if-guard)

### DOM Re-render Lifecycle (KRIITTINEN)
- Kun `innerHTML` korvataan, vanhat event listenerit katoavat — tarkista että uudet luodaan
- Jos popup/overlay liitetään elementtiin joka renderöidään uudelleen, popup katoaa → liitä `document.body`:iin
- Funktiot jotka kutsuvat `renderXxx()` sisällään: tarkista ettei kutsuja ketjuteta niin että edellinen renderöinti ylikirjoittaa seuraavan
- Click handlerit popupissa: `e.stopPropagation()` JOKAISESSA napissa, muuten parent-handler sulkee popupin

### Drag & Drop (KRIITTINEN)
Tässä projektissa on touch-pohjainen drag & drop. Tarkista nämä yleiset sudenkuopat:

**Listener-rekisteröinti:**
- Document-tason listenerit (touchmove, touchend, mousemove, mouseup) PITÄÄ rekisteröidä KERRAN moduulitasolla
- Jos ne rekisteröidään renderöintifunktion sisällä, ne kasautuvat joka renderöinnillä → memory leak + moninkertainen laukeaminen
- innerHTML-korvauksessa luodut element-tason listenerit (esim. drag-handle touchstart) ovat OK — ne katoavat vanhojen elementtien mukana

**Drop vs Click -konflikti:**
- touchend/mouseup laukaisee sekä endDrag:n että click-eventin → tarvitaan `_dragJustEnded` flag + setTimeout(300ms)
- Card-click handlerin pitää tarkistaa flag ennen openDetail-kutsua

**CSS-animaatiot dragin aikana:**
- `transition: all` on VAARALLINEN — se animoi myös transform:ia dragin aikana → tökkivä liike
- Dragging-luokan PITÄÄ sisältää `transition: none` ja `will-change: transform`
- Drop-hetkellä: aseta `transition: none` ENNEN transform-nollausta, force reflow (`offsetHeight`), sitten palauta transition
- CSS transition: käytä spesifisiä propertyjä (`border-color 0.15s, opacity 0.15s, margin 0.2s`) eikä `all`

**Drop-indikaattori:**
- Näytä VAIN lähimmässä kohteessa (closest distance), ei kaikissa ohitetuissa
- Käytä `::before`/`::after` pseudo-elementtejä indikaattorina
- Margin-transition tekee siirtymästä sulavan

**requestAnimationFrame:**
- _moveDrag PITÄÄ käyttää rAF:ia — muuten joka touch-event tekee suoran DOM-päivityksen → jankkaus
- Muista `cancelAnimationFrame` edelliselle ennen uutta

**Body scroll lock:**
- `document.body.style.overflow = 'hidden'` dragin aikana
- PITÄÄ palauttaa endDrag:ssa — myös jos endDrag ei normaalisti laukea (visibilitychange handler)

**Saving race condition:**
- `_dragSaving` flag estää uuden dragin aloituksen kun edellinen tallentuu DB:hen

### Muuttujien Lifecycle (KRIITTINEN)
- `const` vs `let`: jos muuttuja uudelleenmäärätään (`x = {}`) jossakin funktiossa, sen PITÄÄ olla `let`
- **Duplikaatti-deklaraatiot**: jos funktioon lisätään `const x = ...`, tarkista AINA etteikö samassa funktiossa ole jo `const x` aiemmin. Tämä on SyntaxError joka kaataa KOKO sovelluksen — mikään JS ei suoritu. Erityisen yleistä pitkissä funktioissa (renderProgPage, renderProgramList) joihin lisätään koodia loppuun.
- Closure stale values: jos handler luodaan renderöintifunktiossa ja käyttää ulkopuolista muuttujaa (esim. `activeCount`), arvo jäädytetään luontihetkeen → laske uudelleen handlerissa
- Falsy-arvot: `null`, `''`, `0`, `false`, `undefined` käyttäytyvät eri tavoin `||` vs `!= null` kanssa. Tarkista erityisesti DB-sarakkeet jotka voivat olla null TAI tyhjä string

### Supabase-yhteys
- Supabase URL ja anon key ovat oikeassa muodossa
- `Prefer: return=minimal` on kaikissa insert/update/delete-kutsuissa
- 401-käsittely (token refresh) on paikallaan
- `null` vs tyhjä string DB-päivityksissä: kumpi halutaan ja kumpi tallennetaan?

### Navigointi
- `showTab(id)` — jokainen tab-ID vastaa olemassa olevaa DOM-elementtiä
- Progress bar näkyy vain ohjelmasivuilla (prog1/prog2/prog3)
- Piilotettuihin elementteihin ei pääse ohjelmallisesti

### Datavirta
- `logWorkoutWithSnapshot()` tallentaa `workout_history` + `workout_history_exercises` + `workout_history_sets`
- `renderProgPage(slot)` hakee oikean ohjelman ja renderöi sarja-rivit (set-checkbox per sarja)
- `buildPickerList()` rakentaa elementit `createElement`:llä (ei innerHTML)
- Async `.then()` -ketjuissa on `.catch()` virheenkäsittely

### Sarjatason Seuranta (KRIITTINEN)
Sovelluksessa on sarja-tason checkkaus. Tarkista nämä:

**Taulut:**
- `set_checks` — reaaliaikainen sarja-tila (user_id, tab_id, exercise_name, set_number, done, performed_reps, performed_weight, checked_at_seconds)
- `workout_history_sets` — historian sarja-snapshot (history_id, exercise_name, set_number, planned/performed reps/weight)
- `exercise_checks` — vanha liike-tason tila (warmup/physio käyttää edelleen)

**Re-render kortin tila:**
- Kun `renderProgPage()` kutsutaan (esim. sarjan lisäys/poisto), KAIKKI kortit sulkeutuvat
- Ratkaisu: `getOpenCardIds()` tallentaa avatut kortit ennen re-renderiä, `restoreOpenCards()` palauttaa ne jälkeen
- Tarkista: kutsutaanko näitä JOKAISESSA paikassa joka kutsuu renderProgPage()?

**Sarjan lisäys/poisto:**
- "Lisää sarja" päivittää `workout_day_exercises.sets` ja kutsuu renderProgPage
- "Poista sarja" myös siivoaa orphan set_checks -rivit poistetuille set_numbereille
- `saveUnsavedSetInputs()` tallentaa muokatut kentät ennen re-renderiä

**Selector-mismatch riski:**
- `restoreSetChecks` hakee elementtejä `data-exercise-name` attribuutilla
- HTML:ssä attribuutti kirjoitetaan `esc()`:lla, queryssa pitää käyttää samaa escapointia
- ÄLÄ käytä `CSS.escape()` kun HTML käyttää `esc()` — ne eivät täsmää

**Hybridimalli:**
- Prog-sivuilla: `.set-checkbox` (sarja-taso, set_checks taulu)
- Warmup/physio: `.ex-checkbox` (liike-taso, exercise_checks taulu)
- `updateProgress()` käyttää set-checkboxeja prioriteetissa, fallback ex-checkboxeihin

**iOS font-size:**
- Kaikki input-kentät (myös `.prog-set-input`, `.hist-set-input`) PITÄÄ olla 16px+ (iOS zoom-esto)

### Cached Data & Taulujen Synkronointi (KRIITTINEN)
Sovelluksessa on useita cached-muuttujia jotka ladataan eri ajankohtina:
- `cachedSessions` — ladataan kalenterin avautuessa (`loadAndRenderCalendar`)
- `cachedHistory` — ladataan historian avautuessa (`loadAndRenderHistory`)
- `userPrograms` — ladataan kirjautumisessa (`loadUserPrograms`)
- `exerciseLibrary` — ladataan tarvittaessa (`loadExerciseLibrary`)

**Taulujen väliset riippuvuudet:**
- `sessions` (kalenteri) ja `workout_history` (historia) ovat ERI tauluja — merkintä voi olla vain toisessa
- Historia yhdistää molemmat: workout_history + orphan-sessions (joilla ei ole workout_history-riviä)
- Jos funktio käyttää toisen näkymän cachea (esim. historia käyttää cachedSessions:ia), tarkista: onko cache ladattu tässä vaiheessa?
- **Ratkaisu**: Jos cache on tyhjä, lataa se DB:stä ennen käyttöä (lazy load pattern)

**Nimen perusteella matching:**
- `userPrograms.find(p => p.name === sheetSelectedType)` — hauras jos ohjelma nimetty uudelleen
- Tarkista: käytetäänkö nimeä vai ID:tä matchaukseen? ID on turvallisempi.

### Käännökset
- `t('key')` palauttaa aina stringin (ei undefined)
- `currentLang` on 'fi' tai 'en'

## Raportti
Listaa löydöt:
| # | Tila | Tarkistus | Huomio |
Käytä: ✅ OK, ⚠️ varoitus, ❌ virhe

**Älä raportoi pelkkiä ✅-rivejä** — keskity ongelmiin. Listaa ✅ vain lyhyenä yhteenvetona lopussa.
