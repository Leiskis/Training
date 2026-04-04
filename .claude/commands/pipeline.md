# Pipeline — Täysi tarkistusputki

Aja kaikki tarkistukset ja tuota yhteenvetoraportti.

## Tärkeät säännöt agentille

- **Anna tarkat rivinumerot** — jokainen löydös vaatii oikean rivinumeron, ei arviota. Lue rivi aina ennen raportointia.
- **Ei vääriä hälytyksiä** — raportoi vain oikeita ongelmia. Jos et ole varma, tarkista lähdekoodi.
- **Ei duplikaatteja vaiheiden välillä** — jokainen vaihe tarkistaa oman alueensa. Älä toista toisen vaiheen löydöksiä.
- **Tunne projektin konteksti** — lue CLAUDE.md ennen tarkistuksia. Esim. anon key frontendissä on OK (RLS suojaa), localStorage-tokenit ovat normaali SPA-käytäntö.

## Vaiheet

Aja vaiheet 1–5 rinnakkaisina agentteina (Agent tool, subagent_type=Explore). Jokainen agentti saa oman tarkistusalueensa. Agentit eivät saa raportoida toistensa alueen löydöksiä.

### 1. Audit (JS/HTML-ongelmat)
Vastuualue: duplicate-funktiot, window.event, while(true), querySelector null-riskit, puuttuvat currentUser-guardit, console.log, inline onclick, dead code.
EI raportoi: XSS (security hoitaa), Supabase-ongelmat (db-check hoitaa), käännökset (i18n hoitaa).

### 2. Security (turvallisuus)
Vastuualue: innerHTML+käyttäjädata XSS, syötteiden validointi, eval/Function, delete/update ilman user_id.
EI raportoi: anon key frontendissä (OK per CLAUDE.md), localStorage-tokenit (normaali SPA), querySelector null-riskit (audit hoitaa).

### 3. I18n (käännökset)
Vastuualue: puuttuvat käännösavaimet, kovakoodatut tekstit (currentLang ternary), dead keys, alert-viestit.

### 4. DB-check (Supabase)
Vastuualue: taulunimet, sarakkeet, puuttuva virheenkäsittely DB-kutsuissa, .then() ilman .catch().
EI raportoi: user_id-puutteet (security hoitaa).

### 5. Perf (suorituskyky)
Vastuualue: tiedostokoko, suuret funktiot, Supabase-kutsut silmukassa, puuttuva .limit(), duplikoitu logiikka, CSS-optimointi.

## Vaihe 6: Deduplikointi ja validointi

Kun kaikki agentit ovat valmiita:
1. **Poista duplikaatit** — sama ongelma vain kerran, sijoita ensisijaiseen kategoriaan
2. **Validoi rivinumerot** — tarkista jokainen raportoitu rivi lukemalla se (Read tool). Poista löydökset joiden rivinumero ei täsmää.
3. **Poista väärät hälytykset** — jos löydös ei ole oikea ongelma projektin kontekstissa, poista se

## Lopuksi — Yhteenvetoraportti

Kokoa validoidut tulokset yhteen taulukkoon:

| Vaihe | Tila | 🔴 Kriittinen | 🟠 Korkea | 🟡 Matala | ✅ OK |
|-------|------|---------------|-----------|-----------|-------|

Sitten listaa KAIKKI löydökset yhdessä taulukossa, vakavuusjärjestyksessä:
| # | Vaihe | Vakavuus | Ongelma | Rivi (validoitu) |

Kokonaisarvio:
- ✅ **Valmis deploylle** — ei kriittisiä tai korkeita löydöksiä
- ⚠️ **Korjattavaa** — kriittisiä tai korkeita löydöksiä, listaa ne

Jos löytyy korjattavaa, ehdota: "Aja `/fix` korjataksesi löydökset, sitten `/pipeline` uudelleen."
