# Exercise 1: Unemployment Narrative Tooltips

## Overview

Demonstrates **prompt chaining** to generate human, conversational tooltip text for data visualizations.

## Files

- `generate_data.R` - Creates fictional unemployment dataset (2019-2024)
- `generate_tooltips.R` - **Pre-generates tooltips for frontend** (run this!)
- `narrative_chain.R` - Interactive demo of 3-stage prompt chain
- `narrative_template.R` - Template-based generation for comparison (OLD WAY)
- `frontend/` - Svelte + D3 interactive visualization

## Quick Start

### 1. Generate Data (No API Key Needed)

```bash
Rscript exercise/1/generate_data.R
```

This creates `data/unemployment_2019_2024.csv` with 21,600 rows showing marginalization patterns.

### 2. Generate Tooltips (Requires API Key)

```bash
export OPENROUTER_API_KEY="your-key-here"
Rscript exercise/1/generate_tooltips.R
```

This generates AI tooltips for ~12 key demographic combinations and saves them to `frontend/src/tooltips.json`.

**Expected output:**
```
[1/12] Generating: Overall population
  ✓ Unemployment surged across all demographics...

[2/12] Generating: Black workers
  ✓ Black workers faced unemployment rates nearly double...

...

✓ Saved 12 tooltips to: exercise/1/frontend/src/tooltips.json
```

**Time**: ~2-3 minutes (includes API delays to avoid rate limits)

### 3. Run Frontend

```bash
cd exercise/1/frontend
npm install
npm run dev
```

Open http://localhost:5173

## Features

### OLD vs NEW Comparison

Toggle between two approaches:

**📊 OLD WAY (Template):**
> "Black unemployment: Baseline 7.2%, Peak 48.4% (April 2020), Current 8.9%."

**🤖 NEW WAY (AI-Generated):**
> "Black workers faced unemployment rates nearly double that of white workers throughout the pandemic, with the gap actually growing wider during recovery."

### Interactive Filters

- **Race**: All, White, Black, Hispanic, Asian, Other
- **Age**: All, 18-24, 25-34, 35-44, 45-54, 55-64
- **Gender**: All, Male, Female, Non-binary

Chart updates in real-time with matching tooltip.

## How It Works

### 3-Stage Prompt Chain

**Stage 1: Data Context**
- Input: Demographic filters + unemployment data
- Output: Key statistic in context
- Example: "Black unemployment peaked at 48.4% in April 2020"

**Stage 2: Comparison**
- Input: Stage 1 output + overall population data
- Output: How this group compares
- Example: "While white unemployment returned to 3.5%, Black unemployment remained at 6.2%"

**Stage 3: Human Tooltip**
- Input: Stages 1-2
- Output: 1-2 conversational sentences
- Example: "Black workers faced nearly double the unemployment..."

## Pre-Generated Tooltips

`generate_tooltips.R` creates tooltips for these combinations:

- Overall population
- Each race individually (Black, Hispanic, White, Asian)
- Key age groups (18-24, 25-34, 55-64)
- Gender groups (Male, Female)
- Important combinations (Young Black workers, Hispanic women)

If a user selects a combination not pre-generated, the frontend shows a generic fallback message.

## Testing Without API

If you don't have an OpenRouter API key, the frontend will:
1. Load unemployment data (works without API)
2. Show generic fallback tooltips (not AI-generated)
3. Still demonstrate the OLD vs NEW toggle with template text

To get real AI-generated tooltips, you need to run `generate_tooltips.R` with an API key.

## Troubleshooting

**"tooltips.json not found"**
- Run `Rscript exercise/1/generate_tooltips.R` first
- Make sure OPENROUTER_API_KEY is set

**"No data available for selected filters"**
- Check that `data/unemployment_2019_2024.csv` exists
- Run `generate_data.R` if missing

**Frontend shows "Loading..." forever**
- Check browser console for errors
- Verify `npm run dev` started successfully
- Try `npm install` again

## Next Steps

1. Modify prompts in `generate_tooltips.R` to change narrative style
2. Add more demographic combinations to the scenarios list
3. Integrate with real unemployment data from BLS API
4. Build a caching system for faster tooltip loading
