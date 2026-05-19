#!/usr/bin/env bash
# Shared helpers for Kyoto Learn OS (sourced, not executed)

kyoto_root() {
  if [ -n "${KYOTO_LEARN_ROOT:-}" ] && [ -d "$KYOTO_LEARN_ROOT" ]; then
    echo "$KYOTO_LEARN_ROOT"
    return 0
  fi
  if [ -d /usr/share/kyoto-learn ]; then
    echo /usr/share/kyoto-learn
    return 0
  fi
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  echo "$script_dir"
}

kyoto_progress_file() {
  echo "${HOME}/.local/share/kyoto-learn/progress.json"
}

kyoto_init_progress() {
  local pf
  pf="$(kyoto_progress_file)"
  mkdir -p "$(dirname "$pf")"
  if [ ! -f "$pf" ]; then
    cat > "$pf" <<'JSON'
{
  "level": 0,
  "xp": 0,
  "hiragana_done": [],
  "katakana_done": [],
  "kanji_done": [],
  "vocab_done": [],
  "last_session": ""
}
JSON
  fi
}

kyoto_has_jq() {
  command -v jq >/dev/null 2>&1
}

kyoto_get_level() {
  kyoto_init_progress
  if kyoto_has_jq; then
    jq -r '.level // 0' "$(kyoto_progress_file)"
  else
    echo 0
  fi
}

kyoto_add_xp() {
  local amount="${1:-1}"
  kyoto_init_progress
  if ! kyoto_has_jq; then
    return 0
  fi
  local pf tmp
  pf="$(kyoto_progress_file)"
  tmp="$(mktemp)"
  jq --argjson n "$amount" '.xp = (.xp + $n) | .last_session = now | .last_session |= todate' "$pf" > "$tmp" && mv "$tmp" "$pf"
}

kyoto_bilingual_line() {
  local level en ja kyoto
  level="$(kyoto_get_level)"
  en="$1"
  ja="${2:-}"
  kyoto="${3:-}"
  printf "\033[1;36m[EN]\033[0m %s\n" "$en"
  if [ -n "$ja" ]; then
    printf "\033[1;35m[JA]\033[0m %s\n" "$ja"
  fi
  if [ -n "$kyoto" ] && [ "$level" -ge 7 ]; then
    printf "\033[1;33m[京都]\033[0m %s\n" "$kyoto"
  fi
}

kyoto_pause() {
  printf "\n\033[2mPress Enter to continue...\033[0m"
  read -r _
}
