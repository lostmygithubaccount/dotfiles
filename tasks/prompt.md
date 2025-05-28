# Zsh prompt enhancement

## Problem
Current Zsh prompt is basic and lacks visual appeal:
- macOS: `cody@dkdcascend <cwd> %` (no colors)
- Devcontainer: `<container-id>#` (even worse)

## Requirements
✅ **Clarified requirements:**

### Core features
- Fish-style collapsing directory structure (show most useful info)
- Works on both macOS and Linux containers
- Fast performance, simple/speedy
- Readable colors with violet/purple neon scheme preference

### Prompt elements
- `user@host`
- Collapsed directory path
- Git information (branch, dirty status)
- 🤖 emoji indicator when in container
- No virtual env display needed

## Todo
- [x] Clarify requirements with user
- [x] Research current Zsh setup
- [x] Design prompt layout and color scheme
- [x] Implement prompt configuration
- [x] Test on both environments

## Implementation
✅ **Completed!** Added to `.zshrc`:
- Fish-style directory collapsing function
- Container detection (🤖 emoji when in container)
- Violet/purple color scheme with good contrast
- Git branch info with dirty/staged indicators
- Fast, native Zsh implementation

## Design notes
- Use native Zsh prompt expansion for speed
- Detect container environment via common env vars
- Git info should be minimal but useful
- Color scheme: violet/purple with good contrast
