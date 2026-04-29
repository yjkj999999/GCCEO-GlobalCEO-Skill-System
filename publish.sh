#!/bin/bash
# GCCEO Publish Script
# Publishes GCCEO to GitHub and ClawHub

set -e

echo "=========================================="
echo "  GCCEO v4.0.0 Publish Script"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check GitHub auth
if ! gh auth status &>/dev/null; then
    echo -e "${RED}Error: Not logged into GitHub.${NC}"
    echo "Please run: gh auth login"
    echo "Or visit https://github.com/login/device with your device code"
    exit 1
fi

GH_USER=$(gh api user -q .login 2>/dev/null || echo "")
if [ -z "$GH_USER" ]; then
    echo -e "${RED}Error: Could not get GitHub username.${NC}"
    exit 1
fi

echo -e "${GREEN}GitHub user: $GH_USER${NC}"
echo ""

# GitHub Repo Settings
REPO_NAME="GCCEO-GlobalCEO-Skill-System"
REPO_DESC="Global CEO Mastery System | 全球CEO帝王学技能体系 - 111 skills across 10 domains for Chinese entrepreneurs"

echo -e "${BLUE}Step 1: Creating GitHub repository...${NC}"

# Check if repo exists
if gh repo view "$GH_USER/$REPO_NAME" &>/dev/null; then
    echo -e "${YELLOW}Repository already exists. Updating...${NC}"
else
    gh repo create "$REPO_NAME" \
        --public \
        --description "$REPO_DESC" \
        --source=. \
        --remote=origin \
        --push
    echo -e "${GREEN}Repository created: https://github.com/$GH_USER/$REPO_NAME${NC}"
fi

# Ensure remote is set
if ! git remote get-url origin &>/dev/null; then
    git remote add origin "git@github.com:$GH_USER/$REPO_NAME.git"
fi

echo ""
echo -e "${BLUE}Step 2: Pushing code to GitHub...${NC}"
git push -u origin main || git push -u origin master

echo -e "${GREEN}Code pushed successfully!${NC}"
echo ""

# Create GitHub Release
echo -e "${BLUE}Step 3: Creating GitHub Release v4.0.0...${NC}"
gh release create v4.0.0 \
    --title "GCCEO v4.0.0 - Global CEO Mastery System" \
    --notes "## GCCEO v4.0.0 Release

**Global CEO Mastery System | 全球CEO帝王学技能体系**

### What's Included
- **91 Core Skills** across 10 competency domains
- **10 Investment Banking & PE Skills** (Morgan Stanley, KKR, Blackstone methodology)
- **10 Enterprise Globalization Skills** (HKU ICB Mingde GEM inspired)

### Key Features
- AI & Big Data (10 skills)
- Cybersecurity (8 skills)
- Technology Literacy (8 skills)
- Creative Thinking (9 skills)
- Resilience & Agility (10 skills)
- Curiosity & Lifelong Learning (9 skills)
- Leadership & Social Influence (10 skills)
- Talent Management (9 skills)
- Analytical Thinking (9 skills)
- Environmental Stewardship (9 skills)

### Special Modules
- Hong Kong 'Three Hard Pillars' Framework
- Mingde Global Expansion 4-Stage Journey
- AI Superpowers Integration
- Multi-Agent Orchestration for CEOs

### Creator
**Wang Dong Jie** | CFO | 资深复合型战略财务专家
📧 Wdj_@163.com | 📱 13952453499

---
*Beyond Excellence, Achieving Greatness*" \
    --latest 2>/dev/null || echo "Release may already exist"

echo -e "${GREEN}GitHub Release created!${NC}"
echo ""

# ClawHub Publish
echo -e "${BLUE}Step 4: ClawHub / SkillHub Publish Guide${NC}"
echo ""
echo "To publish to ClawHub / SkillHub:"
echo "  1. Visit https://clawhub.ai/publish"
echo "  2. Upload or link your GitHub repository"
echo "  3. Tag with: ceo, leadership, strategy, investment, ai, global-business"
echo "  4. Set visibility: Public"
echo ""
echo "Or use OpenClaw CLI (when available):"
echo "  openclaw skill publish ./SKILL.md"
echo ""

echo -e "${GREEN}=========================================="
echo "  Publish Complete!"
echo "=========================================="
echo ""
echo "GitHub Repo: https://github.com/$GH_USER/$REPO_NAME"
echo "GitHub Release: https://github.com/$GH_USER/$REPO_NAME/releases/tag/v4.0.0"
echo "ClawHub: https://clawhub.ai/GCCEO (manual registration required)"
echo "SkillHub: https://skillhub.ai/GCCEO (manual registration required)"
echo -e "${NC}"
