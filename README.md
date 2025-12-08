# AI Agents: License to Do Journalism

Workshop materials for the Computation + Journalism Symposium 2025

**Instructor**: Rui Barros (PÚBLICO, Portugal)
**Date**: December 11-12, 2025
**Location**: University of Miami

## Workshop Description

Learn to build sophisticated AI agents that handle complex investigative research, cross-reference datasets automatically, and fact-check claims in real-time. This hands-on workshop introduces six proven agent architectures—Prompt Chaining, Routing, Parallelization, and Orchestrator-Workers—that solve real newsroom challenges.

Participants will build practical "AI recipes" to:
- Extract and verify statistics from documents
- Cross-reference claims across databases
- Route breaking news intelligently
- Orchestrate fact-checking workflows with human oversight

Each pattern includes working code, ethical considerations, and integration strategies for existing newsroom tools.

**No advanced programming required**—just curiosity about how AI can augment journalistic judgment and rigor.

## Repository Structure

```
/
├── slides/         # Presentation materials (Quarto reveal.js)
├── exercises/      # Hands-on exercises
├── examples/       # Ready-to-use code implementations
├── resources/      # Supporting materials (diagrams, datasets)
└── docs/           # Generated workshop materials
```

## Six Agent Patterns Covered

1. **Augmented LLM**: Source verification and credibility checking
2. **Prompt Chaining**: Multi-step document analysis pipeline
3. **Routing**: Story classification and assignment
4. **Parallelization (Sectioning)**: Multi-source research
5. **Parallelization (Voting)**: Claim verification
6. **Orchestrator-Workers**: Complex investigation coordination

## Setup Instructions

### Prerequisites
- Quarto installed ([download here](https://quarto.org/docs/get-started/))
- Python 3.9+ or Node.js 18+ (for code examples)
- API key for Claude (optional, for running examples)

### Local Development
```bash
# Clone repository
git clone https://github.com/ruimgbarros/cj-miami-2025-workshop.git
cd cj-miami-2025-workshop

# Preview slides
quarto preview slides/index.qmd

# Render all materials
quarto render
```

## For Participants

All workshop materials will be available in this repository including:
- Presentation slides (HTML + PDF)
- Code examples with explanations
- Exercise templates
- Additional resources and references

Materials are designed to be accessible to participants with varying technical backgrounds.

## License

- **Materials**: Creative Commons Attribution 4.0 International (CC BY 4.0)
- **Code**: MIT License

## Contact

**Rui Barros**
Data Journalist, PÚBLICO
Email: rui.barros@publico.pt
Website: https://ruibarros.me

## Acknowledgments

Workshop developed for the Computation + Journalism Symposium 2025, organized by the University of Miami.

Based on agent patterns from Anthropic's "Building Effective Agents" and practical implementations at PÚBLICO.
