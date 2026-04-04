# Spec — Feature-spesifikaation pipeline

Aja täysi speksausprosessi uudelle ominaisuudelle: $ARGUMENTS

## Tärkeät säännöt
- **Lue koodi ennen arviota** — tarkista todelliset riippuvuudet index.html:stä
- **Anna tarkat viittaukset** — funktionimi, rivinumero, taulunimi
- **Älä kirjoita koodia** — tämä on suunnitteluvaihe

## Vaiheet

### 1. Feature-spesifikaatio
Luo feature-spec:
- **Käyttäjätarinat** (1–3 kpl): "Käyttäjänä haluan X, jotta Y"
- **Hyväksymiskriteerit**: konkreettinen checklista milloin feature on valmis
- **Rajaukset**: mitä feature EI sisällä

### 2. Scope-arvio
Analysoi koodista muutoksen laajuus:

**Muokattavat funktiot:**
| Funktio | Rivi | Muutoksen luonne |

**Uudet funktiot:**
| Funktio | Kuvaus |

**Supabase-muutokset:**
- Uudet taulut tai sarakkeet?
- RLS-säännöt?

**UI-muutokset:**
- HTML-elementit, CSS-tyylit, käännösavaimet (fi + en)?

**Koko:** S (<50 riviä) / M (50–200) / L (200+) / XL (arkkitehtuurimuutos)

### 3. UX-suunnitelma
Kuvaa käyttökokemus mobiili-ensin:
- **Käyttövirta**: vaihe vaiheelta miten käyttäjä käyttää featurea
- **Touch-targetit**: napit vähintään 44×44px
- **Tyhjä tila**: mitä näytetään kun dataa ei ole
- **Palaute**: miten käyttäjä tietää että toiminto onnistui/epäonnistui
- **Sijainti**: mihin välilehteen/näkymään feature tulee

### 4. Riskit ja riippuvuudet
| Riski | Todennäköisyys | Vaikutus | Mitigaatio |

- Voiko muutos rikkoa olemassa olevaa toimintoa?
- Tarvitaanko datamigraatiota?
- Onko riippuvuuksia muihin featureihin?

## Lopputulos — Speksidokumentti

Kokoa kaikki yhteen selkeäksi dokumentiksi:

```
## [Feature-nimi]

### Käyttäjätarinat
...

### Hyväksymiskriteerit
- [ ] ...

### Scope
- Koko: X
- Muutettavat funktiot: X kpl
- Uudet funktiot: X kpl
- DB-muutokset: kyllä/ei

### UX-virta
1. ...

### Riskit
...

### Rajaukset
...
```

Kysy lopuksi: "Hyväksytkö speksin? Aja `/fix` tai aloita toteutus manuaalisesti."
