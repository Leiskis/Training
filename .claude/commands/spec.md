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

### 4. Interaktioanalyysi (KRIITTINEN)

Käy läpi jokainen UI-interaktio ja tunnista sudenkuopat:

**Popup/Overlay-elementit:**
- Mihin DOM-elementtiin popup liitetään? Jos se liitetään elementtiin joka renderöidään uudelleen (innerHTML), popup katoaa.
- Ratkaisu: liitä popupit `document.body`:iin, ei parent-elementtiin.

**Click-propagaatio:**
- Tarvitseeko jokin nappi `e.stopPropagation()`? Jos popup on kortin sisällä, kortin click-handler voi sulkea popupin.
- Listaa kaikki napit jotka tarvitsevat stopPropagation.

**Re-render lifecycle:**
- Mitkä funktiot kutsuvat `renderXxx()` joka korvaa innerHTML:n? Tämä tuhoaa event listenerit.
- Tarkista: luodaanko uudet event listenerit renderöinnin jälkeen?
- Onko ketjutusriski: funktio A kutsuu renderXxx → se kutsuu loadData → data vanhentuu?

**Muuttujan lifecycle:**
- Onko `const` jota yritetään uudelleenmäärittää?
- Onko closure joka kaappaa muuttujan arvon luontihetkellä (stale closure)?
- Null vs tyhjä string vs undefined: miten DB-sarake ja UI-logiikka käsittelevät näitä?

**Drag & Drop (jos feature sisältää raahattavia elementtejä):**
- Document-tason listenerit (touchmove/touchend/mousemove/mouseup) KERRAN moduulitasolla — ei renderöintifunktion sisällä
- Drop vs Click: tarvitaan `_dragJustEnded` flag + setTimeout estämään click dropin jälkeen
- CSS: `transition: none` + `will-change: transform` dragging-luokassa. EI `transition: all` — käytä spesifisiä propertyjä
- Drop-hetkellä: `transition: none` → transform nollaus → force reflow → transition palautus
- requestAnimationFrame moveDrag:ssa (ei suoria DOM-päivityksiä joka touch-eventillä)
- Body scroll lock: `overflow: hidden` dragin aikana + visibilitychange handler turvaverkoksi
- Drop-indikaattori: vain LÄHIN kohde (closest distance), ei kaikkia ohitettuja
- `_dragSaving` flag estää uuden dragin tallennuksen aikana

### 5. Riskit ja riippuvuudet
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

### Interaktiosudenkuopat
- [ ] Popup liitetään body:iin (ei parent-elementtiin)
- [ ] stopPropagation lisätty X nappiin
- [ ] Re-render ei tuhoa Y
- [ ] const/let tarkistettu Z muuttujalle
- [ ] Drag: document-listenerit moduulitasolla (ei renderissä)
- [ ] Drag: transition:none dragging-luokassa
- [ ] Drag: rAF moveDrag:ssa
- [ ] Drag: _dragJustEnded estää click
- [ ] Drag: body overflow lock + visibilitychange

### UX-virta
1. ...

### Riskit
...

### Rajaukset
...
```

Kysy lopuksi: "Hyväksytkö speksin? Aja `/fix` tai aloita toteutus manuaalisesti."
