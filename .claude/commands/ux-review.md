# UX Review — Käytettävyystarkistus

Arvioi `index.html`:n käyttökokemus mobiili-ensin -näkökulmasta.

## Tärkeät säännöt
- **Tämä on treenisovellus** — käytetään pääasiassa kuntosalilla puhelimella, usein yhdellä kädellä
- **Lue koodi** — tarkista todelliset arvot, älä arvaa
- **Anna tarkat rivinumerot** löydöksiin

## Tarkistukset

### 1. Touch-targetit
- Kaikki napit ja interaktiiviset elementit vähintään 44×44px
- Riittävä väli nappien välillä (ei vahinkopainalluksia)
- Erityisesti: checkbox, reorder-napit, delete-napit, picker-listat

### 2. Teksti ja luettavuus
- Fonttikoko vähintään 16px input-kentissä (iOS zoom-esto)
- Riittävä kontrasti (teksti vs tausta, molemmat teemat: dark + light)
- Tekstit eivät leikkaudu pienellä näytöllä (320px leveys)

### 3. Navigointi ja flow
- Käyttäjä tietää aina missä on (aktiivinen tab selkeästi merkitty)
- Takaisin-navigointi toimii loogisesti (bottom sheet, picker, detail-näkymät)
- Modaalit ja sheetit sulkeutuvat backdropia klikkaamalla

### 4. Palaute ja lataus
- Napit näyttävät lataustilanteen (disabled + teksti muuttuu)
- Virheilmoitukset ovat ymmärrettäviä (ei teknistä jargonia)
- Onnistumispalaute on selkeä (toast, animaatio, teksti)
- Tyhjät tilat: mitä näytetään kun dataa ei ole?

### 5. Saavutettavuus
- Semanttiset HTML-elementit (button, label, input, heading-hierarkia)
- aria-labelit interaktiivisille elementeille joissa ei ole tekstiä
- Värit eivät ole ainoa tapa välittää informaatiota

### 6. Mobiilierityiset
- Safe area insetit (notch, home indicator)
- Scroll-käyttäytyminen (ei jumitu, smooth scroll toimii)
- Näppäimistö ei peitä input-kenttää
- Landscape-tuki vai lukittu portrait?

## Raportti

| # | Alue | Löydös | Vakavuus | Rivi |
|---|------|--------|----------|------|

Vakavuus:
- 🔴 Estää käytön — käyttäjä ei pysty suorittamaan tehtävää
- 🟠 Heikentää kokemusta — ärsyttävä tai hidas käyttää
- 🟡 Hienosäätö — parantaisi kokemusta mutta ei kriittinen

Lopuksi top 3 tärkeintä parannusehdotusta.
