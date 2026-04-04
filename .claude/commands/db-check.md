# DB-check — Supabase-skeeman tarkistus

Tarkista että `index.html`:n koodi on synkronissa Supabase-tietokannan kanssa.

## Taulut
Tunnetut taulut: `sessions`, `exercise_library`, `workout_programs`, `workout_day_exercises`, `workout_history`, `workout_history_exercises`, `exercise_checks`

## Tarkistukset

### 1. Taulunimet
- Etsi kaikki taulunimet joihin koodissa viitataan (REST-kutsut, from()-kutsut)
- Varmista että jokainen taulunimi on tunnettujen taulujen listassa
- Listaa tuntemattomat taulunimet

### 2. Sarakkeet
- Kerää kaikki sarakkeiden nimet joita käytetään koodissa (select, insert, update, eq, order jne.)
- Ryhmittele tauluittain
- Tarkista yhtenäisyys: käytetäänkö samaa saraketta eri nimillä eri paikoissa

### 3. Operaatiot
- Jokainen `insert` käyttää `Prefer: return=minimal`
- Jokainen `update` käyttää `Prefer: return=minimal`
- Jokainen `delete` käyttää `Prefer: return=minimal`
- Jokainen `delete` ja `update` sisältää `.eq('user_id', currentUser.id)`
- Jokainen `select` sisältää `user_id` filtteröinnin (RLS-tuki)

### 4. Tietovirtaongelmat
- Insert joka ei käsittele virhettä
- Select joka ei tarkista tyhjää vastausta
- Puuttuvat foreign key -viittaukset (esim. workout_history_exercises viittaa workout_history:n ID:hen)

## Raportti
| # | Taulu | Ongelma | Rivi | Vakavuus |
Vakavuus: 🔴 kriittinen (data häviää/korruptoituu), 🟠 korkea (turvallisuus), 🟡 matala
