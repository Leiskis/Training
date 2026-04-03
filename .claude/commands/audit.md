# Audit — Tarkista bugit

Tarkista `index.html` kokonaan. Etsi seuraavat ongelmat:

## JavaScript
- Duplicate funktiot (sama nimi kahdesti)
- `window.event` tai globaali `event` muuttuja — ei toimi iOS Safarissa
- `while(true)` silmukat — käytä safety limit muuttujaa
- `querySelector` joka voi palauttaa null ilman tarkistusta
- Puuttuvat `currentUser`-guardit async funktioissa jotka tekevät DB-kutsuja
- `console.log` jäänyt koodiin (pitää käyttää `log.info/ok/error/warn`)

## HTML / XSS
- `innerHTML` johon syötetään käyttäjän dataa suoraan (ohjelmanimi, liikename, note)
- inline `onclick`-attribuutit — pitää käyttää `addEventListener`
- Puuttuvat `inputmode`-attribuutit number-kentissä (iOS zoom-bugi)

## Supabase
- `insert()` joka ketjuttaa `.select()` — ei toimi custom clientissa
- `delete()` tai `update()` ilman `.eq('user_id', currentUser.id)` — turvallisuusriski
- Virheenkäsittely puuttuu DB-kutsuista

## UI
- Progress bar näkyy väärissä välilehdissä (myprograms, calendar, history)
- Sort order -konfliktit reorder-toiminnoissa

## Raportti
Listaa kaikki löydöt taulukkona:
| # | Vakavuus | Ongelma | Rivi |
Aloita kriittisistä (🔴), sitten korkeat (🟠), matalat (🟡).
