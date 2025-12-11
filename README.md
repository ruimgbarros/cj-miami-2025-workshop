# AI Agents: License to Do Journalism

Materials for the workshop at Computation + Journalism Symposium 2025

## Overview

This workshop demonstrates practical patterns for integrating AI agents into data journalism workflows.

## Quick Start

Visit the workshop site: [https://ruimgbarros.github.io/cj-miami-2025-workshop/](https://ruimgbarros.github.io/cj-miami-2025-workshop/)

## Repository Structure

```
├── docs/              # Quarto-generated workshop site
├── exercise/          # Hands-on exercises
│   ├── 1/            # Unemployment visualization
│   └── 2/            # Science fact-checking router
├── code/              # Workshop presentation code
└── patterns/          # AI workflow pattern examples
```

## Requirements

- **R**: 4.0+ with packages: `httr`, `jsonlite`, `dplyr`
- **Node.js**: 18+ (for Exercise 1 frontend)
- **API KEY**: For Exercise 2

## Exercises

### Exercise 1: Unemployment Visualization

Build an interactive chart showing unemployment trends with AI-generated tooltips.

```bash
cd exercise/1/frontend
npm install
npm run dev
```

### Exercise 2: Science Fact-Checker

Route TikTok transcripts to domain experts for fact-checking.

```bash
cd exercise/2
Rscript example.R
```

## Building the Site

```bash
quarto render
```

## Author

Rui Barros - Data Journalist at Público
