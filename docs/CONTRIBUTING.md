# Contributing

## Text style

- Use a hyphen `-` for breaks in English sentences. Do not use em dashes (`—`) or en dashes (`–`).
- Keep UI strings free of "Powered by" attribution lines and tool watermarks.
- Teach standard Japanese before Kyoto dialect (see level order in LEARNING_PATH.md).

## Adding lessons

Edit JSON under `curriculum/`:

- `hiragana.json`, `katakana.json`, `kanji-starter.json`, `vocab-core.json`, `kyoto-dialect.json`
- Level metadata in `manifest.json`

Test locally:

```bash
./bin/kyoto-learn
```

## Installer changes

- `install/preflight.sh` - prompts and profiles
- `install/packages.sh` - pacman and AUR lists
- `install/desktop-ui.sh` - i3 / polybar deploy
- `config/` - templates copied to the user home

Run on a test VM before merging.
