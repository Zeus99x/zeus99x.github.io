# Hosting My Resume on GitHub Pages

This README explains how to host a resume using Pelican and GitHub Pages, inspired by Andrew Etter’s _Modern Technical Writing_. It’s for Marvin McLaren, a beginner with Markdown and basic command-line skills.

## Purpose

This guide shows Marvin how to host a resume online simply and efficiently.

## Prerequisites

- Python 3.7+
- Git
- GitHub account
- Text editor

## Instructions

1. **Install Pelican:** Etter emphasizes lightweight tools—run `pip install pelican markdown`.
2. **Set Up Project:** Use `pelican-quickstart` for modularity (Etter’s principle).
3. **Write Resume:** Create `content/resume.md` in Markdown—simple and readable (Etter’s simplicity).
4. **Generate Site:** Run `pelican content -o output -s publishconf.py` for efficiency.
5. **Host on GitHub:** Push to `zeus99x.github.io` and enable GitHub Pages.

## Resources

- [Markdown Tutorial](https://www.markdowntutorial.com/)
- [Pelican Docs](https://docs.getpelican.com/)
- [GitHub Pages Guide](https://pages.github.com/)
- [Git Basics](https://git-scm.com/doc)

## FAQ

- **Why Markdown?** It’s simpler than HTML, as Etter suggests.
- **Changes not showing?** Regenerate and push updates to GitHub.

## Credits

- Saman HM (me!)
- Theme: Pelican default
