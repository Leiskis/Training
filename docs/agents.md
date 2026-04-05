# Claude Code -agentit

Projektissa on 25 Claude Code -agenttikomentoa (`.claude/commands/`). Ne ajetaan `/komento`-syntaksilla.

## DevOps & Deploy

| Komento | Kuvaus |
|---------|--------|
| `/deploy` | Julkaisee muutokset GitHubiin (tarkistaa authOverlay, console.log, TESTING-kommentit) |
| `/pipeline` | Ajaa kaikki tarkistukset rinnakkain (audit + security + i18n + db-check + perf) ja kokoaa yhteenvetoraportin |

## Laadunvarmistus

| Komento | Kuvaus |
|---------|--------|
| `/audit` | JS/HTML-bugien etsinta (duplikaattifunktiot, querySelector null, dead code) |
| `/security` | Turvallisuustarkistus (XSS, RLS, syotteiden validointi) |
| `/test` | Staattinen analyysi (event handlerit, drag & drop, re-render lifecycle, muuttujat) |
| `/fix` | Korjaa loydetyt bugit vakavuusjarjestyksessa |
| `/review` | Kattava katselmus ennen deployta |
| `/perf` | Suorituskykyanalyysi (koko, DOM, funktiot, Supabase-kutsut) |
| `/i18n` | Kaannosten kattavuus ja oikeellisuus |
| `/db-check` | Supabase-skeeman synkronointi koodin kanssa |

## Tuotesuunnittelu

| Komento | Kuvaus |
|---------|--------|
| `/feature` | Luo feature-spesifikaatio (kayttajatarinat, hyvaksymiskriteerit, tekniset reunaehdot) |
| `/spec` | Taysi speksauspipeline (feature + scope + UX + interaktioanalyysi + riskit) |
| `/scope` | Arvioi muutoksen laajuus ja riskit (S/M/L/XL) |
| `/backlog` | Skannat projektin nykytilan ja kokoa priorisoitu backlog (MoSCoW) |
| `/ideate` | 7 asiantuntijan paneeli arvioimaan feature-ideaa rinnakkain |
| `/po` | Product Owner: backlog, roadmap, sprintit, RICE-priorisointi |

## Design & UX

| Komento | Kuvaus |
|---------|--------|
| `/designer` | Senior Product Designer — feature-arviointi pistein 1-10 |
| `/ux-designer` | UX/UI Designer — visuaalinen analyysi, layout, komponentit |
| `/ux-review` | Kaytettavyystarkistus mobiili-ensin (touch targets, saavutettavuus) |

## Domain-asiantuntijat

| Komento | Kuvaus |
|---------|--------|
| `/personal-trainer` | Ohjelma-analyysi, lihasryhmabalanssi, periodisaatio, progressio |
| `/sports-psychologist` | Motivaatio- ja palautumisanalyysi fiilis/rasitus-datasta |
| `/nutritionist` | Ravitsemussuositukset harjoitusdatan perusteella |
| `/data-analyst` | Harjoitusdatan trendit, korrelaatiot, ennusteet |
| `/business` | Subscription-liiketoiminta, monetisaatio, App Store -strategia |

## Infra

| Komento | Kuvaus |
|---------|--------|
| `/watch-sync` | Apple Watch -appin yhteensopivuustarkistus web-appin kanssa |

## Tyovirta

Tyypillinen kehityssykli:

```
/ideate [idea]          → Asiantuntijapaneeli arvioi
/spec [feature]         → Taysi spesifikaatio
/scope [muutos]         → Laajuusarvio
... toteutus ...
/test                   → Staattinen analyysi
/pipeline               → Taysi tarkistusputki
/fix                    → Korjaa loydetyt bugit
/review                 → Viimeinen katselmus
/deploy [viesti]        → Julkaise
```
