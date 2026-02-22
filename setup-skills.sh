#!/bin/bash
# Reinstall global agent skills (managed by skills.sh)
# These are shared across Claude Code, Codex, Cursor, etc.
# Run after initial machine setup: ./setup-skills.sh
set -e

echo "==> Installing global agent skills..."

SKILLS=(
  "anthropics/skills --skill frontend-design"
  "resend/email-best-practices"
  "resend/react-email"
  "resend/resend-skills --skill send-email"
  "softaworks/agent-toolkit --skill commit-work"
  "vercel-labs/skills --skill find-skills"
)

for spec in "${SKILLS[@]}"; do
  name="${spec##* }"
  echo "    Installing $spec"
  npx skills add $spec -g -y 2>/dev/null || echo "    (already installed or failed)"
done

echo ""
echo "==> Skills installed. Verify with: npx skills ls -g"
