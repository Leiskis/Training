# Ideate — Feature-ideoinnin asiantuntijapaneeli

Kokoa 5 asiantuntijaa yhteen arvioimaan ja kehittämään feature-ideaa: $ARGUMENTS

## Tärkeät säännöt
- **Aja kaikki 5 asiantuntijaa rinnakkaisina agentteina** (Agent tool, subagent_type=Explore)
- **Jokainen agentti lukee koodin** — ei arvailla, tarkistetaan index.html ja CLAUDE.md
- **Ei duplikaatteja** — jokainen agentti vastaa omasta näkökulmastaan
- **Lyhyt ja konkreettinen** — max 200 sanaa per agentti

## Vaihe 1: Asiantuntija-arviot (rinnakkain)

### Agentti 1: Product Designer
Arvioi feature pistein 1–10 (käyttäjäarvo, mobiilisopivuus, toteutettavuus, yhtenäisyys). Anna UX-suunnitelma: missä sijaitsee, miten navigoidaan, interaktiot. Päätös: toteuta / muokkaa / myöhemmin / hylkää.

### Agentti 2: Personal Trainer
Arvioi featuren hyöty treenin tuloksellisuuden kannalta. Tukeeko progressiivista ylikuormitusta? Parantaako palautumista? Auttaako lihasryhmäbalanssin seurannassa? Anna 2–3 konkreettista huomiota valmentajan näkökulmasta.

### Agentti 3: Urheilupsykologi
Arvioi featuren vaikutus motivaatioon ja sitoutumiseen. Lisääkö se sisäistä motivaatiota vai tuoko ulkoista painetta? Onko ylikuormituksen/burnoutin riski? Tukeeko pitkäjänteistä harjoittelua? Anna 2–3 psykologista huomiota.

### Agentti 4: Data-analyytikko
Arvioi millaista dataa feature tuottaa tai tarvitsee. Mitä tauluja/sarakkeita tarvitaan? Voiko dataa hyödyntää analytiikassa? Onko datamalli tehokas? Anna 2–3 data-näkökulmaa.

### Agentti 5: Ravitsemusasiantuntija
Arvioi liittyykö feature ravitsemukseen tai palautumiseen. Jos ei suoraan, ehdota miten ravitsemusnäkökulman voisi yhdistää. Jos ei relevantti, sano se lyhyesti ja ehdota sen sijaan mikä ravitsemus-feature olisi arvokas.

## Vaihe 2: Synteesi

Kun kaikki agentit ovat vastanneet, kokoa yhteenveto:

### Asiantuntijaraati

| Asiantuntija | Suositus | Ydinhuomio |
|---|---|---|
| Designer | ✅/⚡/⏳/❌ | ... |
| Valmentaja | 👍/👎/🤔 | ... |
| Psykologi | 👍/👎/🤔 | ... |
| Data-analyytikko | 👍/👎/🤔 | ... |
| Ravitsemus | 👍/👎/🤔 | ... |

### Konsensus
- **Yhteinen suositus**: toteuta / muokkaa / myöhemmin / hylkää
- **Tärkeimmät parannukset**: 2–3 ehdotusta jotka nousivat useammalta asiantuntijalta
- **Riskit**: mitkä varoitukset toistuivat

### Lopullinen feature-ehdotus
Jos konsensus on "toteuta" tai "muokkaa", kirjoita lopullinen feature-kuvaus joka huomioi kaikkien asiantuntijoiden palautteet:
- Mitä toteutetaan (MVP)
- Mitä jätetään pois ensimmäisestä versiosta
- Arvioitu koko: S / M / L / XL

Kysy lopuksi: "Hyväksytkö? Aja `/spec [feature]` speksataksesi tai `/designer [feature]` tarkempaan arvioon."
