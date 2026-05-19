# How to learn Japanese on this system

## First-language habits (not classroom habits)

**Do**

- Listen and repeat short chunks (2-5 words), not long lectures.
- Write kana by hand every day; muscle memory matters.
- Label your room in Japanese (tape on desk, door, kitchen).
- Mix English and Japanese on purpose: understand first, then shrink English.
- Use Kyoto dialect as flavor after standard forms feel easy.

**Avoid**

- Studying kanji before hiragana is fluent.
- Only using romaji (English letters) after week one.
- Long study sessions once a week instead of short daily practice.
- Translating word-by-word in English word order.

## Three writing types on one machine

1. **Read** in the terminal drills (`kyoto-learn`).
2. **Write** on paper while the screen shows the character.
3. **Type** romaji in drills to check memory (builds IME skill later).

Install Japanese input when ready:

```bash
sudo pacman -S fcitx5-mozc fcitx5-configtool noto-fonts-cjk
```

## Immersion on this OS

- Shell login shows bilingual motd (`kyoto-motd`).
- Press **Mod+Shift+J** in i3 to open lessons.
- Progress is stored in `~/.local/share/kyoto-learn/progress.json`.

## Kyoto dialect note

Kyoto speech is polite Kansai. Patterns like どす and まっす are taught in level 9. Standard Japanese comes first so textbooks and Rosetta Stone still make sense.
