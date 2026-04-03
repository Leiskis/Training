# Deploy — Julkaise muutokset

Julkaise muutokset GitHubiin. Commit-viesti: $ARGUMENTS

## Vaiheet

1. Tarkista muuttuneet tiedostot: `git status`
2. Tarkista että `index.html` ei sisällä:
   - Kirjautumissivu piilotettuna testauksen takia (`authOverlay` style="display:none")
   - `// TESTING` kommentteja joissa on kommentoitu pois tärkeää koodia
   - `console.log` debug-kutsuja
3. Jos ongelmat löytyy, korjaa ne ennen deployta
4. `git add index.html CLAUDE.md .claude/`
5. `git commit -m "$ARGUMENTS"`
6. `git push origin main`
7. Ilmoita että deploy on valmis ja GitHub Actions hoitaa loput
