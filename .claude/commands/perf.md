# Perf — Suorituskykyanalyysi

Analysoi `index.html`:n suorituskykyä ja koko.

## Tarkistukset

### Tiedostokoko
- `index.html` kokonaiskoko (tavua)
- JS-koodin osuus (script-tagien sisältö)
- CSS-koodin osuus (style-tagien sisältö)
- HTML-rakenteen osuus
- Rivimäärä kokonaisuudessaan

### DOM-rakenne
- Elementtien arvioitu kokonaismäärä
- Syvimmän nesting-tason syvyys
- Piilotetut elementit jotka voisivat olla turhia

### JavaScript
- Funktioiden kokonaismäärä
- Suurimmat funktiot (yli 50 riviä) — listaa ne
- Duplikoitu logiikka joka voitaisiin yhdistää
- Raskaat operaatiot jotka ajetaan turhaan (esim. DOM-haku silmukassa)
- `querySelectorAll` joka palauttaa suuren joukon elementtejä

### Supabase-kutsut
- Kutsut jotka hakevat kaiken datan ilman filtteröintiä
- Peräkkäiset kutsut jotka voisi yhdistää
- Kutsut joissa puuttuu `.limit()` tai muu rajaus

### CSS
- Käyttämättömät CSS-luokat tai ID-selektorit
- Duplikoituneet tyylit
- Raskaat selektorit (syvät ketjut, universaali *)

## Raportti
| # | Alue | Löydös | Vaikutus | Ehdotus |
Vaikutus: 🔴 suuri, 🟠 kohtalainen, 🟡 pieni

Lopuksi yhteenveto koosta ja top 3 optimointiehdotusta.
