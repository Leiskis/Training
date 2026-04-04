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
