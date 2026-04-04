# Scope — Arvioi muutoksen laajuus

Arvioi ehdotetun muutoksen laajuus ja riskit: $ARGUMENTS

## Tärkeät säännöt
- **Lue koodi ennen arviota** — älä arvaa, tarkista todelliset riippuvuudet
- **Anna tarkat viittaukset** — funktionimi, rivinumero, taulunimi

## Analyysi

### 1. Vaikutusalue
Listaa kaikki tiedoston osat joita muutos koskee:

**Funktiot joita pitää muokata:**
| Funktio | Rivi | Muutoksen luonne |
|---------|------|------------------|

**Uudet funktiot joita tarvitaan:**
| Funktio | Kuvaus |
|---------|--------|

**Supabase-muutokset:**
- Uudet taulut?
- Uudet sarakkeet olemassa oleviin tauluihin?
- RLS-sääntöjen päivitys?

**UI-muutokset:**
- Uudet HTML-elementit?
- Uudet CSS-tyylit?
- Uudet käännösavaimet?

### 2. Kokokategoria

Arvioi muutoksen koko:
- **S (pieni)** — 1–2 funktiota, ei DB-muutoksia, <50 riviä
- **M (keskisuuri)** — 3–5 funktiota, mahdollisesti uusi sarake, 50–200 riviä
- **L (suuri)** — uusi kokonainen toiminto, uusia tauluja, >200 riviä
- **XL (erittäin suuri)** — arkkitehtuurimuutos, useita tauluja, refaktorointia

### 3. Riskit
| Riski | Todennäköisyys | Vaikutus | Mitigaatio |
|-------|---------------|----------|------------|

### 4. Riippuvuudet
- Mihin olemassa oleviin ominaisuuksiin muutos vaikuttaa?
- Voiko muutos rikkoa jotain nykyistä toimintoa?
- Tarvitaanko migraatiota olemassa olevalle datalle?

## Yhteenveto
- **Koko**: S / M / L / XL
- **Arvioitu muutos**: ~X riviä koodia
- **DB-muutokset**: kyllä / ei
- **Riski**: matala / kohtalainen / korkea
- **Suositus**: toteuta / pilko pienemmiksi / harkitse uudelleen
