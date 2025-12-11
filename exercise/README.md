# Workshop Exercises

Two hands-on exercises demonstrating AI agent patterns for data journalism.

## Exercise 1: Prompt Chaining - Unemployment Narrative Tooltips

**Pattern**: Sequential AI calls that build on each other
**Goal**: Generate human, conversational tooltip text for unemployment data visualizations

### What You'll Build
- Fictional unemployment dataset (2019-2024) showing marginalization patterns
- 3-stage AI prompt chain that generates SHORT (1-2 sentence) tooltips
- Interactive Svelte visualization with **OLD vs NEW comparison**:
  - **OLD WAY**: Template-based text with data interpolation
  - **NEW WAY**: AI-generated human narratives

### Quick Start

```bash
# 1. Generate the data
Rscript exercise/1/generate_data.R

# 2. Generate tooltips for frontend (requires OPENROUTER_API_KEY)
export OPENROUTER_API_KEY="your-key-here"
Rscript exercise/1/generate_tooltips.R
# This creates tooltips.json for ~12 key demographic combinations

# 3. (Optional) Test narrative generation interactively
Rscript exercise/1/narrative_chain.R

# 4. Run the interactive visualization
cd exercise/1/frontend
npm install
npm run dev
# Open http://localhost:5173
```

### How It Works

**Stage 1: Data Context** - Identifies key statistics for selected demographic
**Stage 2: Comparison** - Compares to overall population
**Stage 3: Human Tooltip** - Converts analysis into 1-2 conversational sentences

**Comparison:**

**OLD WAY (Template):**
> "18-24 unemployment: Baseline 8.0%, Peak 56.8% (April 2020), Current 9.2%. Overall population current rate: 7.2%."

**NEW WAY (AI-Generated):**
> "Young workers aged 18-24 were hit hardest, with unemployment reaching 56.8% in April 2020."

The frontend includes a toggle to switch between both modes and see the difference!

---

## Exercise 2: Routing - Science Fact-Check

**Pattern**: Classification-based routing to specialized expert agents
**Goal**: Extract claims from TikTok videos and fact-check using field-specific experts

### What You'll Build
- 8-10 realistic fictional TikTok science misinformation transcripts
- Claim extraction pipeline
- Router that classifies claims by scientific field
- Four specialized fact-checking agents (Medicine, Climate, Biology, Physics)

### Quick Start

```bash
# Run the fact-checking pipeline (requires OPENROUTER_API_KEY)
export OPENROUTER_API_KEY="your-key-here"
Rscript exercise/2/example.R
```

### How It Works

**Stage 1: Claim Extraction** - Extract factual claims from video transcript
**Stage 2: Classification** - Route claim to scientific field (MEDICINE/CLIMATE/BIOLOGY/PHYSICS)
**Stage 3: Expert Fact-Check** - Specialized agent evaluates with evidence

**Example Output:**
```
Claim: "mRNA vaccines change DNA permanently"
Category: MEDICINE
Verdict: FALSE
Reasoning: mRNA vaccines cannot alter DNA. The mRNA never enters the cell
nucleus where DNA is stored. It remains in the cytoplasm and is quickly degraded.
Key Evidence: mRNA cannot integrate into DNA without reverse transcriptase
enzyme (which these vaccines don't contain). CDC and FDA extensive safety
monitoring confirms no DNA changes occur.
```

---

## Requirements

### Both Exercises
- R (4.0+) with packages: `httr`, `jsonlite`
- OpenRouter API key: https://openrouter.ai/

### Exercise 1 Only
- Node.js (18+) and npm
- Modern web browser

## Tips for Workshop

1. **Start with Exercise 2** (faster, pure R, no frontend complexity)
2. **Test with 3 videos first** (already set in code) before running all
3. **Pre-generate tooltips** for Exercise 1 to avoid API delays during demo
4. **Show the prompts** - the quality of output depends on prompt engineering!

## Data Journalism Insights

**Exercise 1** demonstrates how AI can make data visualizations more accessible by providing human-readable context that adapts to what the user is viewing.

**Exercise 2** shows how routing enables efficient fact-checking at scale by directing claims to the right domain expert instead of using a generic fact-checker.

Both patterns are production-ready for real newsrooms when combined with human oversight.
