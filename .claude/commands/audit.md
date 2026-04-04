# Audit — Tarkista bugit

Tarkista `index.html` kokonaan. Etsi seuraavat ongelmat:

## Tärkeät säännöt
- **Anna tarkat rivinumerot** — lue jokainen raportoitava rivi Read-työkalulla. Älä arvaa.
- **Ei vääriä hälytyksiä** — jos et ole varma onko kyseessä bugi, tarkista konteksti.
- **Vain oma vastuualue** — älä raportoi XSS:ää (security hoitaa), käännöksiä (i18n hoitaa) tai Supabase-skeemaa (db-check hoitaa).

## JavaScript
- Duplicate funktiot (sama nimi kahdesti)
- `window.event` tai globaali `event` muuttuja — ei toimi iOS Safarissa
- `while(true)` silmukat — käytä safety limit muuttujaa
- `querySelector` joka voi palauttaa null ilman tarkistusta (`?.` tai if-guard puuttuu)
- Puuttuvat `currentUser`-guardit async funktioissa jotka tekevät DB-kutsuja
- `console.log` jäänyt koodiin (pitää käyttää `log.info/ok/error/warn`)
- Dead code: funktiot joita ei kutsuta mistään

## HTML
- inline `onclick`-attribuutit — pitää käyttää `addEventListener`
- Puuttuvat `inputmode`-attribuutit number-kentissä (iOS zoom-bugi)

## UI
- Progress bar näkyy väärissä välilehdissä (myprograms, calendar, history)
- Sort order -konfliktit reorder-toiminnoissa

## Raportti
Listaa kaikki löydöt taulukkona:
| # | Vakavuus | Ongelma | Rivi (tarkka) |
Aloita kriittisistä (🔴), sitten korkeat (🟠), matalat (🟡).
