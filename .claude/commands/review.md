# Review — Tarkista ennen deployta

Tee kattava katselmus `index.html`:stä ennen julkaisua.

## Tarkistuslista

### Toiminnallisuus
- [ ] Kirjautuminen toimii (authOverlay näkyy, ei display:none)
- [ ] Tab-navigointi toimii kaikilla välilehdillä
- [ ] Kalenteri: päivän napauttaminen avaa bottom sheetin
- [ ] Bottom sheet: treeni-valinta, fiilis, tallenna toimivat
- [ ] Omat ohjelmat: luonti, poisto, liikkeiden lisäys toimivat
- [ ] Exercise picker: liikkeiden haku ja lisäys toimivat
- [ ] Historia: listat ja analytiikka latautuvat
- [ ] Progress bar näkyy vain ohjelmasivuilla

### Koodi
- [ ] Ei inline onclick-attribuutteja
- [ ] Ei console.log-kutsuja
- [ ] Ei while(true)-silmukoita
- [ ] Kaikilla async funktioilla currentUser-guard
- [ ] Backtick-merkit tasapainossa (template literals)
- [ ] Ei duplikaattifunktioita

### Mobile
- [ ] font-size: 16px tekstikentissä (iOS zoom-esto)
- [ ] Safe area insets bottom sheetin alareunassa
- [ ] Touch targets riittävän isoja (min 44px)

Raportoi tulos selkeästi: ✅ valmis deploylle tai ❌ korjattavaa.
