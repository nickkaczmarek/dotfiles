# Future Dotfiles Improvements

This document tracks potential improvements and enhancements for the dotfiles repository. These are ideas to revisit when time permits.

---

## Quick Wins (Low effort, high value)

### 1. ~~Fix .gitignore~~ ✅ COMPLETED
**Priority:** High  
**Effort:** Low (5 min)  
**Status:** ✅ Done (2025-11-10)

Updated `.gitignore` with:
- ✅ `.nvimlog` (Neovim debug log)
- ✅ `.DS_Store` and macOS temp files
- ✅ `*.swp`, `*.swo`, `*.swn` (vim swap files)
- ✅ `config/nvim/plugin/packer_compiled.lua` (generated)
- ✅ `brew/backup-brewfiles/Brewfile.20*` (dated backups)

---

### 2. Automate Brewfile Backup Script
**Priority:** Medium  
**Effort:** Low (15 min)

Create `scripts/utils/backup-brewfile` that:
- Generates dated backup: `brew bundle dump --file=brew/backup-brewfiles/Brewfile.$(date +%Y-%m-%d)`
- Optionally shows diff with tracked version
- Lists what's new/changed

**Usage:**
```bash
backup-brewfile          # Generate backup
backup-brewfile --diff   # Show what's different
```

---

### 3. Add Dotfiles Update Script
**Priority:** High  
**Effort:** Medium (30 min)

Create `scripts/utils/dotfiles-update` that runs:
1. `git pull` (with stash if needed)
2. `mise install` (install new tools)
3. `brew bundle` (install new packages)
4. Re-run symlinks if manifest changed
5. Report what was updated

**Usage:**
```bash
dotfiles-update
```

---

## Automation & Scripts

### 4. Pre-commit Git Hooks
**Priority:** Medium  
**Effort:** Medium (30 min)

Add to `.git/hooks/pre-commit`:
- Validate Brewfile syntax
- Check for duplicate MAS entries
- Warn if Brewfile has large diff

---

### 5. Enhanced shell-doctor
**Priority:** Medium  
**Effort:** Medium (45 min)

Additional checks:
- Outdated Homebrew (`brew outdated`)
- Stale mise versions (`mise outdated`)
- Missing shell completions
- Git configuration issues (user.name, user.email)
- Broken PATH entries

---

### 6. Git Utilities
**Priority:** Low  
**Effort:** Low-Medium (20-40 min)

Add scripts to `scripts/git/`:
- `git-cleanup-branches` - Delete merged branches
- `post-checkout` hook - Auto-run `mise install`

Add aliases to `config/git/gitconfig`:
- More interactive rebase shortcuts
- Better log formatting aliases

---

## Configuration Improvements

### 7. Split Brewfile by Category
**Priority:** Low  
**Effort:** Medium (1 hour)

**Structure:**
```
brew/
├── Brewfile           # Core tools (current)
├── Brewfile.work      # Work-specific (Zillow, Tuist, Sentry)
├── Brewfile.optional  # Nice-to-haves
└── backup-brewfiles/
```

Update installer to support: `brew bundle --file=brew/Brewfile.work`

**Benefits:**
- Cleaner core Brewfile
- Easy to skip work tools on personal machine
- Optional tools don't clutter main file

---

### 8. Track VS Code Settings
**Priority:** Low  
**Effort:** Low (15 min)

Currently VS Code extensions are in backup Brewfile, but settings aren't tracked.

**Action:**
- Add `config/vscode/settings.json`
- Symlink to `~/Library/Application Support/Code/User/settings.json`
- Add to manifest.sh

---

### 9. Expand mise Tool Management
**Priority:** Low  
**Effort:** Low (10 min)

Currently managing: neovim, node, ruby, usage

Consider adding to `.mise.toml`:
- `python` - if you use Python
- `terraform` - if you do infrastructure
- `go` - if you develop in Go

---

### 10. Machine-Specific Config Templates
**Priority:** Low  
**Effort:** High (2+ hours)

Some configs differ between work/personal machines.

**Approach:**
- Create templates with placeholders: `config/git/gitconfig.template`
- Use `envsubst` or similar to generate actual config
- Example: Different git configs per machine

**Skip if:** Current approach works fine (includeIf already handles this)

---

## Documentation

### 11. Document Brewfile Workflow
**Priority:** Medium  
**Effort:** Low (15 min)

Add to README:
- How to generate backup: `brew bundle dump --file=...`
- How to compare with current system
- When to add to tracked vs backup
- How to clean up packages not in Brewfile

---

### 12. Document 1Password Setup
**Priority:** Medium  
**Effort:** Low (10 min)

Add to README:
- How to install 1Password CLI
- How to create/configure Anthropic API key item
- How the `claude` wrapper works
- Other secrets that should be in 1Password

---

### 13. Add Contribution/Testing Guide
**Priority:** Low  
**Effort:** Low (15 min)

Even for personal use, document:
- How to test changes locally before committing
- What to check before pushing
- Common troubleshooting steps

---

## Advanced Ideas (Low priority)

### 14. Installation Tests
**Priority:** Low  
**Effort:** High (3+ hours)

Use Docker to test bootstrap/install on fresh macOS container.

**Benefits:**
- Catch installation issues
- Verify fresh machine setup works
- Test bootstrap script

**Reality:** Probably overkill for personal dotfiles

---

### 15. Dotfiles CLI Command
**Priority:** Low  
**Effort:** High (2+ hours)

Create unified command: `dotfiles <subcommand>`

**Subcommands:**
```bash
dotfiles update     # Pull and install updates
dotfiles backup     # Backup current Brewfile
dotfiles doctor     # Run shell-doctor
dotfiles edit vim   # Open vim config in $EDITOR
```

**Benefits:** Consistent interface

**Reality:** Current scripts work fine, this is mostly aesthetic

---

### 16. Security Audit
**Priority:** Medium  
**Effort:** Medium (45 min)

- Scan for accidentally committed API keys/tokens
- Add pre-commit hook with `git-secrets` or similar
- Document expected secrets (1Password)

---

### 17. Shell Utility Functions
**Priority:** Low  
**Effort:** Low-Medium (varies)

Add to `scripts/shell/`:
- `project-setup` - Scaffold new projects with templates
- `docker-cleanup` - Clean docker containers/images (since you have colima)
- `git-recent-branches` - Show recently checked out branches

---

### 18. Commit Backup Brewfile Strategy
**Priority:** Low  
**Effort:** Low (5 min)

**Decision needed:**
- Option A: Gitignore all dated backups (keep repo clean)
- Option B: Commit one "reference" backup (shows system state)
- Option C: Commit all dated backups (full history)

**Recommendation:** Option A (gitignore them, they're just for diffing)

---

### 19. Git Cleanup
**Priority:** Low  
**Effort:** Low (5 min)

Your `.git/lost-found/` has 104 orphaned objects.

**Action:**
```bash
git gc --aggressive --prune=now
```

**Note:** This is cosmetic, doesn't affect functionality

---

### 20. macOS Defaults Script
**Priority:** Low  
**Effort:** High (varies)

You have `.macos` config. Consider:
- Documenting what each setting does
- Organizing by category (Dock, Finder, etc.)
- Testing on fresh machine to ensure it works

---

## Implementation Priority

### Do First (High Value, Low Effort):
1. ~~Fix .gitignore~~ ✅ DONE
2. Add dotfiles-update script
3. Document Brewfile workflow
4. Document 1Password setup

### Do When Convenient:
5. Automate Brewfile backup script
6. Enhanced shell-doctor
7. Pre-commit hooks
8. Split Brewfile by category

### Do When You Have Time:
9. Everything else

---

## Notes

- This is a living document - add/remove ideas as needed
- Don't feel obligated to implement everything
- Current setup already works great!
- Only implement what adds real value to your workflow

---

**Last Updated:** 2025-11-10

