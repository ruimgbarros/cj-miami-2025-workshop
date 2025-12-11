# Workshop Guide: AI Agents for Data Journalism

## Overview

Two hands-on exercises demonstrating how AI agents can enhance data journalism workflows.

---

## 🎯 Exercise 1: Unemployment Narrative Tooltips

### The Problem
Data visualizations often show numbers without context. Traditional approach uses template strings:

**❌ OLD WAY (Template):**
```
"Black unemployment: Baseline 7.2%, Peak 48.4% (April 2020), Current 8.9%."
```
- Robotic and data-heavy
- Reads like a database query
- Requires users to interpret meaning

**✅ NEW WAY (AI-Generated):**
```
"Black workers faced unemployment rates nearly double that of white workers
throughout the pandemic, with the gap actually growing wider during recovery."
```
- Conversational and human
- Contextualizes with meaning
- Tells the story behind the numbers

### Demo Flow

1. **Show the data** (`exercise/1/data/unemployment_2019_2024.csv`)
   - 21,600 rows of unemployment data (2019-2024)
   - Clear marginalization patterns: Black 48.4%, White 26.9% at COVID peak

2. **Show the OLD WAY in frontend**
   - Click "📊 OLD WAY: Template" button
   - Select demographics (e.g., Black workers)
   - Read the robotic template output

3. **Show the NEW WAY in frontend**
   - Click "🤖 NEW WAY: AI-Generated" button
   - Same demographics
   - Read the human narrative

4. **Explain the 3-stage chain** (`exercise/1/narrative_chain.R`)
   - Stage 1: Extract data context
   - Stage 2: Compare to overall population
   - Stage 3: Generate human tooltip

### Key Teaching Points
- AI can translate data into accessible narratives
- Prompt chaining allows building complex outputs step-by-step
- Human tone is achieved through careful prompting, not just using AI

---

## 🎯 Exercise 2: Science Fact-Check Router

### The Problem
Fact-checking TikTok science misinformation at scale requires domain expertise.

**Challenge**: One generic fact-checker can't evaluate claims across medicine, climate, biology, and physics with equal expertise.

**Solution**: Route claims to specialized expert agents.

### Demo Flow

1. **Show a TikTok transcript** (in `exercise/2/example.R`)
   ```
   "PSA for everyone who got the COVID vaccine - you need to detox your body NOW.
   The mRNA literally changes your DNA permanently..."
   ```

2. **Stage 1: Claim Extraction**
   - AI extracts: "mRNA vaccines change DNA permanently"

3. **Stage 2: Classification**
   - AI routes to: MEDICINE category

4. **Stage 3: Expert Fact-Check**
   - Medicine expert evaluates with scientific evidence
   - Verdict: FALSE
   - Reasoning: mRNA cannot alter DNA (stays in cytoplasm)
   - Evidence: CDC/FDA safety monitoring

### Run the Demo
```bash
export OPENROUTER_API_KEY="your-key"
Rscript exercise/2/example.R
```

Processes 3 videos by default (change loop for all 9).

### Key Teaching Points
- Routing enables specialization at scale
- Professional prompts cite real sources (CDC, NASA, IPCC)
- No silly personas - focus on evidence
- Multi-stage pipelines handle complex workflows

---

## 📊 Comparison Table

| Aspect | OLD WAY | NEW WAY (AI) |
|--------|---------|--------------|
| **Tone** | Robotic, data-heavy | Conversational, human |
| **Context** | Raw numbers | Meaningful interpretation |
| **Accessibility** | Requires data literacy | Accessible to all |
| **Scalability** | Manual templates | Adapts to any demographic |
| **Time** | Fast (instant) | Slower (API calls) |
| **Cost** | Free | API costs |

---

## 🚀 Running the Workshop

### Before the Workshop

1. **Set up environment**
   ```bash
   export OPENROUTER_API_KEY="your-key"
   ```

2. **Test Exercise 2** (faster, no frontend)
   ```bash
   Rscript exercise/2/example.R
   ```

3. **Pre-generate narratives for Exercise 1** (optional, avoids API delays)
   ```bash
   Rscript exercise/1/narrative_chain.R
   ```

4. **Build Exercise 1 frontend**
   ```bash
   cd exercise/1/frontend
   npm install
   npm run build  # or npm run dev for live demo
   ```

### During the Workshop

**Order**: Start with Exercise 2 (simpler), then Exercise 1 (more impressive).

**Exercise 2 Demo (~15 min)**
1. Show a TikTok transcript (2 min)
2. Run the pipeline live (5 min)
3. Explain the 3 stages (5 min)
4. Show the prompts (3 min)

**Exercise 1 Demo (~20 min)**
1. Show the unemployment data patterns (3 min)
2. Open the frontend visualization (2 min)
3. Toggle OLD vs NEW way (5 min)
4. Select different demographics and compare (5 min)
5. Explain the 3-stage chain (5 min)

### Common Questions

**Q: Why not just use templates?**
A: Templates work for simple cases, but AI can adapt tone, provide context, and handle edge cases humans haven't anticipated.

**Q: How do you ensure factual accuracy?**
A: Human oversight required! AI provides draft narratives/verdicts that journalists verify.

**Q: What about API costs?**
A: Pre-generate for known scenarios, use caching, or run batch processes overnight.

**Q: Can this work in production?**
A: Yes! Both patterns are production-ready with proper human review workflows.

---

## 📁 File Structure

```
exercise/
├── README.md                    # Quick start guide
├── WORKSHOP_GUIDE.md           # This file
│
├── 1/                          # Prompt Chaining
│   ├── generate_data.R         # Create unemployment dataset
│   ├── narrative_chain.R       # AI tooltip generator (NEW WAY)
│   ├── narrative_template.R    # Template generator (OLD WAY)
│   ├── data/
│   │   ├── unemployment_2019_2024.csv
│   │   └── unemploymentData.json
│   └── frontend/               # Svelte visualization
│       ├── src/
│       │   └── UnemploymentChart.svelte  # OLD vs NEW toggle
│       └── package.json
│
└── 2/                          # Routing
    ├── example.R               # Complete fact-check pipeline
    └── data/                   # (generated in script)
```

---

## 💡 Extension Ideas

After mastering these exercises, try:

1. **Exercise 1+**: Add more sophisticated narratives
   - Compare multiple demographics
   - Identify trends over time
   - Generate full article paragraphs

2. **Exercise 2+**: Expand the router
   - Add more fields (psychology, economics, etc.)
   - Multi-claim analysis
   - Confidence scoring

3. **Combine patterns**: Use routing + chaining together
   - Route data stories by topic
   - Chain analysis → narrative → headline

---

## ⚠️ Ethical Considerations

**Always**:
- ✅ Disclose AI usage in published work
- ✅ Fact-check AI outputs before publication
- ✅ Maintain human editorial oversight
- ✅ Be transparent about data sources
- ✅ Consider bias in training data

**Never**:
- ❌ Publish AI-generated content without verification
- ❌ Use AI to replace human judgment
- ❌ Assume AI outputs are factual
- ❌ Feed sensitive/private data to APIs without consent

---

## 🎓 Learning Outcomes

By the end of this workshop, participants will:

1. ✅ Understand prompt chaining for complex outputs
2. ✅ Know when to use routing vs. single agents
3. ✅ Write professional, evidence-based prompts
4. ✅ Recognize the difference between templates and AI narratives
5. ✅ Have production-ready code to adapt for their newsroom

---

## 📚 Resources

- **OpenRouter**: https://openrouter.ai/
- **Workshop Code**: `/exercise/` directory
- **Example Prompts**: See R files for production-ready templates
- **Data Patterns**: Unemployment data shows realistic marginalization effects

---

**Questions?** Check the main README or examine the code - everything is documented!
