# Backlog — Priorisoi kehitystyöt

Skannaa projektin nykytila ja kokoa priorisoitu backlog.

## Lähteet

### 1. Koodin TODO:t ja FIXME:t
- Etsi kaikki `// TODO`, `// FIXME`, `// HACK`, `// XXX` kommentit `index.html`:stä
- Listaa jokainen kontekstinsa kanssa (funktio, rivinumero)

### 2. Pipeline-löydökset
- Aja nopea skannaus: tunnetut bugit, XSS-riskit, puuttuvat validoinnit, dead code
- Älä aja täyttä pipelinea — keskity vain avoimiin ongelmiin

### 3. Git-historia
- Tarkista viimeisimmät commitit — onko keskeneräisiä töitä tai väliaikaisia ratkaisuja?

### 4. Käännöspuutteet
- Pikaskannaus: kovakoodatut tekstit jotka eivät käytä t()-funktiota

## Priorisointi (MoSCoW)

Kokoa löydökset taulukkoon:

| # | Prioriteetti | Tyyppi | Kuvaus | Sijainti |
|---|-------------|--------|--------|----------|

Prioriteetit:
- **Must** — kriittinen bugi tai turvallisuusriski, estää käytön
- **Should** — tärkeä parannus, vaikuttaa käyttökokemukseen
- **Could** — kiva lisä, ei kiireellinen
- **Won't** — ei nyt, ehkä myöhemmin

## Yhteenveto
- Must: X kpl
- Should: X kpl
- Could: X kpl
- Ehdota seuraavat 3 työkohdetta aloitettavaksi
