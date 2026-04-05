# Watch Sync — Apple Watch -appin yhteensopivuustarkistus

Tarkista että Apple Watch -appi (TrainingWatch) on synkronissa web-appin kanssa.

## Tärkeät säännöt
- **Lue molemmat**: web-appin `index.html` JA Watch-appin Swift-tiedostot `TrainingWatch/` tai `Desktop/TrainingWatch/`
- **Vertaa tauluja**: mitkä Supabase-taulut web-appi käyttää vs. mitkä Watch tuntee
- **Vertaa ominaisuuksia**: mitä web-appissa voi tehdä vs. mitä Watchissa

## Tarkistukset

### 1. Tietokantataulut
Web-appi käyttää näitä tauluja — tarkista onko Watch-appi ajan tasalla:
- `workout_programs` (id, name, emoji, is_active, sort_order)
- `workout_day_exercises` (exercise_id, sets, reps, target_weight, sort_order)
- `exercise_library` (name, muscle_group, instructions)
- `set_checks` (tab_id, exercise_name, set_number, done, performed_reps, performed_weight, checked_at_seconds)
- `exercise_checks` (vanha liike-taso — warmup/physio)
- `sessions`, `workout_history`, `workout_history_exercises`, `workout_history_sets`

### 2. Ominaisuudet
Tarkista onko Watch ajan tasalla näissä:
- [ ] Sarja-tason checkkaus (set_checks taulu, ei exercise_checks)
- [ ] Sarjojen lisäys/poisto
- [ ] Eri painot per sarja (performed_weight per set)
- [ ] Timer + checked_at_seconds per sarja
- [ ] Ohjelman emoji (workout_programs.emoji)
- [ ] Dynaaminen ohjelmalistaus (is_active filtteröinti)

### 3. Swift-mallit
Vertaa Swift Codable -malleja Supabase-tauluihin:
- Onko kaikki sarakkeet mukana?
- Ovatko tyypit oikein (String vs Int vs Double vs Bool)?
- Onko nullable-kentät Optional?

### 4. REST API -kutsut
- Käyttääkö Watch samoja endpointeja kuin web?
- Onko auth-token käsittely yhteensopiva?
- Onko RLS-filtteröinti (user_id) mukana?

## Raportti
| # | Alue | Web-appi | Watch-appi | Tila |
|---|------|----------|------------|------|
Tila: ✅ Synkassa / ⚠️ Puuttuu Watchista / ❌ Ristiriita

Lopuksi listaa konkreettiset muutokset Watch-appiin.
