# Tietokanta

## Yleiskuva

Backend on Supabase (PostgreSQL). Kaikissa tauluissa on Row Level Security (RLS) paalla — kayttaja nakee vain oman datansa.

**Supabase URL**: `https://azgraotogacudqpuahrz.supabase.co`

## Taulut

### sessions

Kalenterimerkinnät. Yksi rivi per treenipaiva.

| Sarake | Tyyppi | Kuvaus |
|--------|--------|--------|
| id | uuid | PK |
| user_id | uuid | FK → auth.users |
| date | date | Treenipäivä |
| type | text | Ohjelman nimi tai "Muu" |
| effort_feeling | text | easy / good / hard / exhausting |
| post_workout_mood | text | great / energized / neutral / tired / stressed |
| note | text | Vapaa muistiinpano (null jos tyhja) |
| ts | timestamptz | Luontiaika |
| created_at | timestamptz | Luontiaika |

### exercise_library

Liikkeiden tietokanta (yhteinen kaikille kayttajille).

| Sarake | Tyyppi | Kuvaus |
|--------|--------|--------|
| id | uuid | PK |
| name | text | Liikkeen nimi (esim. "Penkkipunnerrus") |
| category | text | Jalat / Selka / Rinta / Hartiat / Kadet / Core / Fysio |
| muscle_group | text | Lihasryhma, voi olla yhdistelma: "Selka, Hauikset" |
| instructions | text | Suoritusohjeet |

### workout_programs

Kayttajan treeniohjelmat.

| Sarake | Tyyppi | Kuvaus |
|--------|--------|--------|
| id | uuid | PK |
| user_id | uuid | FK → auth.users |
| name | text | Ohjelman nimi |
| sort_order | int | Jarjestys tab-barissa |
| is_active | bool | Nakyyko ohjelma tabina |
| emoji | text | Ohjelman emoji-ikoni (null = oletusemoji) |

### workout_day_exercises

Ohjelman liikkeet (suunniteltu ohjelma).

| Sarake | Tyyppi | Kuvaus |
|--------|--------|--------|
| id | uuid | PK |
| user_id | uuid | FK → auth.users |
| program_id | uuid | FK → workout_programs |
| exercise_id | uuid | FK → exercise_library |
| sort_order | int | Jarjestys ohjelmassa |
| sets | int | Sarjojen maara (oletus 3) |
| reps | text | Toistomaara (esim. "10", "8-12") |
| target_weight | numeric | Tavoitepaino (kg) |

### workout_history

Treenisessioiden historia. Yksi rivi per tehty treeni.

| Sarake | Tyyppi | Kuvaus |
|--------|--------|--------|
| id | uuid | PK |
| user_id | uuid | FK → auth.users |
| program_name | text | Ohjelman nimi tallennushetkella |
| logged_date | date | Treenipäivä |
| effort_feeling | text | easy / good / hard / exhausting |
| post_workout_mood | text | great / energized / neutral / tired / stressed |
| note | text | Muistiinpano |
| duration_seconds | int | Treenin kesto sekunteina |
| session_id | uuid | FK → sessions (linkki kalenterimerkintaan) |

### workout_history_exercises

Liikkeiden toteutumat per treenisessio. Snapshot tallennushetkella.

| Sarake | Tyyppi | Kuvaus |
|--------|--------|--------|
| id | uuid | PK |
| history_id | uuid | FK → workout_history |
| exercise_name | text | Liikkeen nimi |
| muscle_group | text | Lihasryhma |
| planned_sets | int | Suunniteltu sarjamaara |
| planned_reps | text | Suunniteltu toistomaara |
| planned_weight | numeric | Suunniteltu paino |
| performed_sets | int | Toteutunut sarjamaara |
| performed_reps | text | Toteutunut toistomaara |
| performed_weight | numeric | Toteutunut paino |
| checked_at_seconds | int | Milloin merkattiin tehdyksi (timer-sekunnit) |

### workout_history_sets

Sarja-tason snapshot historiaan.

| Sarake | Tyyppi | Kuvaus |
|--------|--------|--------|
| id | uuid | PK |
| history_id | uuid | FK → workout_history |
| exercise_name | text | Liikkeen nimi |
| set_number | int | Sarjan numero (1-based) |
| planned_reps | text | Suunniteltu toistot |
| planned_weight | numeric | Suunniteltu paino |
| performed_reps | text | Toteutunut toistot |
| performed_weight | numeric | Toteutunut paino |

### exercise_checks

Liike-tason reaaliaikainen tila (warmup/physio).

| Sarake | Tyyppi | Kuvaus |
|--------|--------|--------|
| id | uuid | PK |
| user_id | uuid | FK → auth.users |
| tab_id | text | Valilehden ID (warmup / physio) |
| exercise_name | text | Liikkeen nimi |
| done | bool | Tehty? |
| checked_at_seconds | int | Timer-sekunnit |

### set_checks

Sarja-tason reaaliaikainen tila (prog1/2/3).

| Sarake | Tyyppi | Kuvaus |
|--------|--------|--------|
| id | uuid | PK |
| user_id | uuid | FK → auth.users |
| tab_id | text | Valilehden ID (prog1 / prog2 / prog3) |
| exercise_name | text | Liikkeen nimi |
| set_number | int | Sarjan numero |
| done | bool | Tehty? |
| performed_reps | text | Toteutunut toistot |
| performed_weight | numeric | Toteutunut paino |
| checked_at_seconds | int | Timer-sekunnit |

## Taulujen valiset suhteet

```
workout_programs
└── workout_day_exercises (program_id)
    └── exercise_library (exercise_id)

sessions ←──────────────────── workout_history (session_id)
                                ├── workout_history_exercises (history_id)
                                └── workout_history_sets (history_id)

set_checks     ← reaaliaikainen tila (prog-sivut)
exercise_checks ← reaaliaikainen tila (warmup/physio)
```

## Tärkeät periaatteet

- **Kaikki muokkaukset**: `Prefer: return=minimal` header
- **Kaikki update/delete**: `.eq('user_id', currentUser.id)` filter (RLS-tuki)
- **Token refresh**: Automaattinen 401-vastauksella
- **null vs ''**: Tyhja kentta tallennetaan `null`:na (ei tyhjana stringina)
- **sessions vs workout_history**: Eri taulut, mutta linkitetty `session_id`:lla. Historia yhdistaa molemmat.
