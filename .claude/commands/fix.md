# Fix — Korjaa bugit

Korjaa `index.html`:stä löydetyt bugit järjestyksessä.

## Säännöt
- Aloita kriittisistä (🔴), etene vakavuusjärjestyksessä
- Älä riko olemassa olevaa toiminnallisuutta
- Jokaisen korjauksen jälkeen tarkista että muut toiminnot toimivat edelleen
- Käytä `addEventListener` — ei inline `onclick`
- Käytä `log.info/ok/error/warn` — ei `console.log`

## Korjaustapa

### inline onclick → addEventListener
Siirrä onclick-logiikka `initXxxDelegation()`-funktioon tai suoraan DOMContentLoaded-kutsuttuun koodiin.

### XSS innerHTML + käyttäjädata
Käytä `textContent` tai `document.createElement` + `textContent` sen sijaan että syötät käyttäjädataa suoraan innerHTML:ään.

### window.event → parametri
Muuta funktiot ottamaan `event`-parametrin eksplisiittisesti tai käytä `addEventListener`:ää joka passaa eventin automaattisesti.

### Puuttuva currentUser guard
Lisää funktion alkuun: `if (!currentUser) { log.warn('funktionNimi: no user'); return; }`

### Sort order konfliktit
Hae ensin olemassa olevat sort_order arvot DB:stä ja käytä max+1 uusille.

## Lopuksi
Kun kaikki on korjattu, aja `/audit` uudelleen ja varmista että lista on tyhjä.
