# Security — Turvallisuustarkistus

Tarkista `index.html`:n turvallisuus projektisääntöjen mukaisesti.

## Projektin konteksti (älä raportoi näitä ongelmina)
- **Anon key frontendissä on OK** — RLS suojaa tietokannan, anon key on tarkoitettu julkiseksi
- **localStorage-tokenit ovat normaali SPA-käytäntö** — ei backendiä, joten HTTP-only cookie ei ole vaihtoehto
- **Älä raportoi arkkitehtuurivalintoja ongelmina** — keskity koodibugeihin

## Tarkistukset

### XSS-haavoittuvuudet (pääfokus)
- `innerHTML` johon syötetään käyttäjädataa (liikenimet, ohjelmanimi, muistiinpanot, error.message, mikä tahansa DB:stä tai käyttäjältä tuleva data)
- Template literal backtick-stringit jotka sisältävät käyttäjädataa ja syötetään DOM:iin innerHTML:llä
- HUOM: innerHTML + kovakoodattu teksti tai `t()` käännös EI ole XSS-riski — raportoi vain kun data tulee käyttäjältä tai DB:stä

### Supabase RLS
- Jokainen `delete` ja `update` sisältää `.eq('user_id', currentUser.id)` -filtterin
- Tarkista JOKAINEN .update() ja .delete() kutsu yksitellen

### Syötteiden validointi
- Numeeristen kenttien validointi ennen DB:hen tallennusta (parseInt/parseFloat)
- Puuttuvat `currentUser`-guardit async funktioissa jotka tekevät DB-kutsuja

### Inline-koodi
- Ei `onclick`, `onchange`, `onsubmit` tai muita inline-handlereita HTML:ssä
- Ei `eval()`, `Function()` tai `setTimeout(string)`

## Raportti
| # | Kategoria | Ongelma | Rivi (tarkka) | Vakavuus |
Vakavuus: 🔴 kriittinen, 🟠 korkea, 🟡 matala

**Anna aina tarkka rivinumero** — lue rivi Read-työkalulla ennen raportointia.
Lopuksi kokonaisarvio: turvallinen / korjattavaa.
