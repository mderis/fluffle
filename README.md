# Fluffle

Production-ready Flutter starter template for iOS and Android, built on
Flutter 3.47 / Dart 3.13 with the standalone `material_ui` package.

> v2 is being rebuilt. The previous version lives at tag `legacy-final`.
> Full documentation will be published as a documentation website.

## Quick start

```sh
make setup            # env files from env/example.json, deps, codegen
make run              # dev flavor
make run FLAVOR=prod
make help             # all tasks
```

Fill `env/dev.json`, `env/staging.json` and `env/prod.json` with your values
(see `env/example.json`). They are gitignored.

See `docs/decisions.md` for the architecture decisions.
