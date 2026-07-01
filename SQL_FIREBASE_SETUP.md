# SEMED CREI - SQL para Firebase

Firebase SQL Connect usa Cloud SQL para PostgreSQL. Estes arquivos preparam a estrutura SQL do sistema:

- `sql/schema.sql`: tabelas, relacionamentos e indices.
- `sql/seed.sql`: dados iniciais de perfis, unidade administrativa, usuario admin, CID10 e permissoes.

## Ordem de execucao

1. Crie/ative o Firebase SQL Connect no projeto `crei-ff3b9`.
2. Vincule uma instancia Cloud SQL PostgreSQL ao servico SQL Connect.
3. Execute `sql/schema.sql`.
4. Execute `sql/seed.sql`.

## Compatibilidade com o app atual

O app atual ainda usa Firestore pelo arquivo `firebase-bridge.js`.

Para uma migracao gradual para SQL Connect, a tabela `app_snapshots` foi criada para armazenar o mesmo payload unico usado hoje:

```sql
select payload from app_snapshots where id = 'default';
```

Depois, o app pode ser migrado para usar as tabelas normalizadas (`students`, `teachers`, `assignments`, `requests`, `pei`).
