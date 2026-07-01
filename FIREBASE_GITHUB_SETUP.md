# SEMED CREI - Firebase e GitHub Pages

## Firebase

1. No Firebase Console, abra o projeto `crei-5d162`.
2. Ative Authentication > Sign-in method > Anonymous.
3. Ative Firestore Database.
4. Publique as regras iniciais de `firestore.rules` ou crie regras adequadas para producao antes de usar dados reais.

Para teste inicial, o sistema salva tudo no documento:

`appSnapshots/default`

## GitHub Pages

1. Envie esta pasta para um repositorio GitHub.
2. No GitHub, abra Settings > Pages.
3. Em Build and deployment, selecione GitHub Actions.
4. Faça push na branch `main`.
5. O workflow `.github/workflows/github-pages.yml` publicara o site.

O app e estatico e usa o Firebase diretamente no navegador.
