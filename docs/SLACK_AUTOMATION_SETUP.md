# Slack automation (MCP-Arch)

Same pattern as RamenAnime. Full setup: see [RamenAnime docs/SLACK_AUTOMATION_SETUP.md](https://github.com/RamenAnime/RamenAnime/blob/main/docs/SLACK_AUTOMATION_SETUP.md).

1. Create a Slack incoming webhook.
2. Add GitHub secret `SLACK_WEBHOOK_URL` on this repo (or org-wide).
3. Workflows: `ci.yml`, `slack-ci-notify.yml`, `slack-health-review.yml`, `slack-enhancement-continue.yml`.

Stopping point: comment `/approve-continue` on the auto-created health issue.
