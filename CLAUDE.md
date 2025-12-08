# Claude Code Configuration for C+J 2025 Miami Workshop

## Project Overview

**Workshop**: AI Agents: License to Do Journalism
**Event**: Computation + Journalism Symposium 2025
**Date**: December 11-12, 2025
**Location**: University of Miami, Newman Alumni Center
**Duration**: 1.5 hours
**Capacity**: ~25 participants
**Instructor**: Rui Barros (PÚBLICO)

## Mission

This repository contains workshop materials for teaching journalists how to build practical AI agents for newsroom workflows. The materials are designed using Quarto to generate both presentation slides and hands-on exercises.

## Critical Constraints

### Audience Profile
- **Mixed technical levels**: From programmers to non-coders
- **IMPORTANT**: Some participants may have minimal/no programming experience
- Must emphasize **concepts over code syntax**
- Provide **ready-to-use examples** that don't require coding
- Focus on **understanding patterns and applications**
- Include **visual aids and diagrams** for agent architectures

### Workshop Requirements
- Duration: Exactly 1.5 hours (90 minutes)
- Format: Balance between theory (concepts) and hands-on (practical application)
- Equipment: Participants have laptops; instructor can connect to screens
- Materials must be uploaded to Google Drive before symposium
- Participant list will be shared 1-2 days before event

## Content Strategy

### Core Learning Objectives
1. Understand 6 proven AI agent architectures applicable to journalism
2. Recognize when to use agents vs. simple prompting
3. Build/adapt practical "AI recipes" for common newsroom tasks
4. Design ethical AI workflows with human oversight
5. Integrate agents into existing newsroom processes

### Six Agent Patterns (from workshop abstract)
1. **Augmented LLM**: Source verification and credibility checking
2. **Prompt Chaining**: Multi-step document analysis pipeline
3. **Routing**: Story classification and assignment
4. **Parallelization (Sectioning)**: Multi-source research
5. **Parallelization (Voting)**: Claim verification
6. **Orchestrator-Workers**: Complex investigation coordination

### Key Concepts from Preparation Reading
- Chain of Verification for fact-checking
- End-to-end autonomous processing for document analysis
- Multi-agent coordination for collaborative workflows
- Hallucination mitigation (critical for journalism)
- "10 Questions to Ask Before You Consider an AI Agent"

## Technical Stack

### Primary Tools
- **Quarto**: For slides and documentation generation
- **Python**: For code examples (with clear explanations)
- **JavaScript/Node**: Alternative examples when appropriate
- **Claude API**: Primary LLM for agent examples
- **GitHub**: Repository hosting and version control

### Repository Structure
```
/
├── CLAUDE.md              # This file
├── README.md              # Public-facing description
├── _quarto.yml            # Quarto configuration
├── slides/                # Presentation materials
│   ├── index.qmd          # Main slides
│   ├── intro.qmd          # Introduction section
│   └── patterns/          # One file per pattern
├── exercises/             # Hands-on exercises
│   ├── exercise-1.qmd     # Document analysis
│   ├── exercise-2.qmd     # Fact-checking
│   └── ...
├── examples/              # Ready-to-use code
│   ├── python/            # Python implementations
│   ├── javascript/        # JS implementations
│   └── notebooks/         # Jupyter notebooks
├── resources/             # Supporting materials
│   ├── diagrams/          # Architecture diagrams
│   ├── datasets/          # Sample data for exercises
│   └── references.md      # Additional reading
└── docs/                  # Generated output (Quarto)
```

## Development Guidelines

### Content Creation Principles
1. **Accessibility First**: Every concept must be explainable without code
2. **Visual Communication**: Use diagrams, flowcharts, and architecture illustrations
3. **Practical Application**: Each pattern includes real journalism use cases
4. **Ethical Framing**: Always include oversight, transparency, and bias considerations
5. **Progressive Disclosure**: Start simple, add complexity gradually

### Code Example Standards
- **Every code example must have**:
  - Plain English explanation of what it does
  - Visual diagram showing the flow
  - Commented code with clear step markers
  - Non-technical alternative (conceptual walkthrough)
  - Example output/results

- **Provide three levels of engagement**:
  1. **Conceptual**: Understand the pattern without code
  2. **Guided**: Follow along with pre-built example
  3. **Adaptive**: Customize for your newsroom (optional)

### Quarto-Specific Guidelines
- Use `revealjs` format for slides
- Include speaker notes with timing guidance
- Use Quarto's tabset panels for code vs. concept views
- Leverage callout blocks for ethical considerations
- Use mermaid diagrams for architecture visualization

## Workshop Timeline (90 minutes)

### Suggested Structure
- **00:00-00:10** (10 min): Introduction & Context
  - What are AI agents vs. simple prompting?
  - When to use agents in journalism
  - Workshop roadmap

- **00:10-00:60** (50 min): Six Patterns (~8 min each)
  - Pattern explanation (concept)
  - Architecture diagram
  - Journalism use case
  - Quick demo/walkthrough
  - Q&A touchpoint

- **00:60-00:80** (20 min): Hands-on Exercise
  - Participants work with pre-built examples
  - Choose their complexity level
  - Instructors circulate to help

- **00:80-00:90** (10 min): Wrap-up & Resources
  - Ethical considerations review
  - When NOT to use agents
  - Resource list
  - Follow-up materials

## Quality Standards

### Before Committing
- [ ] All slides render correctly in Quarto
- [ ] Code examples run without errors
- [ ] Diagrams display properly
- [ ] Speaker notes include timing
- [ ] Accessibility: Alt text for images
- [ ] No broken links

### Before Workshop
- [ ] Full dry run within 90 minutes
- [ ] Backup materials prepared (PDF versions)
- [ ] All dependencies documented
- [ ] Participant setup instructions tested
- [ ] Materials uploaded to Google Drive
- [ ] Laptop tested with venue screens

## Ethical Guidelines

### Mandatory Disclosures in Materials
- AI limitations and hallucination risks
- Human oversight requirements
- Transparency in automated decisions
- Bias considerations
- Data privacy implications
- Attribution and sourcing standards

### When NOT to Use Agents
- Final editorial decisions
- Sensitive source communication
- Legal determinations
- Replacing human judgment on ethics
- Publishing without verification

## Testing & Validation

### Content Testing
- Technical accuracy verified by peer review
- Code examples tested on clean environment
- Timing validated through dry runs
- Accessibility checked with screen reader
- Non-technical review by journalist colleague

### Participant Testing (if possible)
- Beta test with 2-3 people of varying technical levels
- Gather feedback on clarity and pacing
- Adjust complexity based on feedback

## Resources & References

### Source Materials
- Anthropic's "Building Effective Agents" documentation
- "Mastering AI Agents" eBook (read 2025-10-23)
- "Mastering Multi-Agent Systems" eBook (read 2025-10-23)
- "Mastering RAG" eBook (read 2025-10-23)
- PÚBLICO's internal AI agent implementations

### Participant Resources (to provide)
- GitHub repository with all code
- Quarto-generated slides (PDF + HTML)
- Exercise templates
- Additional reading list
- Contact information for follow-up

## File Management

### Important Files in Original Project
Located at: `~/Tardis/01 Projects/C+J-2025-Miami-Workshop/`
- `workshop-abstract.md`: Original submission
- `agent-patterns-for-journalism.md`: Six patterns outline
- `bio.md`: Speaker bio
- `reading-prep-notes.md`: Preparation insights
- `tasks.md`: Workshop checklist

### Link to Original Project
This repository is a subset of the main project. For logistics, travel, and administrative details, refer to the original Obsidian vault project.

## Version Control

### Commit Message Standards
- Use conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`
- Reference pattern numbers: `feat(pattern-3): add routing example`
- Include context: `docs(exercises): simplify exercise 1 for non-coders`

### Branching Strategy
- `main`: Stable, workshop-ready materials
- `dev`: Work in progress
- `slides/*`: Individual slide development
- `exercises/*`: Exercise development

## Quick Commands

### Development
```bash
# Preview slides locally
quarto preview slides/index.qmd

# Render all materials
quarto render

# Check for broken links
quarto check

# Create PDF handouts
quarto render slides/index.qmd --to pdf
```

### Pre-Workshop
```bash
# Generate all outputs
quarto render

# Create distribution package
./scripts/package-for-distribution.sh

# Validate all examples
./scripts/test-all-examples.sh
```

## Contact & Support

- **Workshop Instructor**: Rui Barros
- **Email**: rui.barros@publico.pt
- **Conference Organizer**: Alberto Cairo
- **Conference**: https://cplusj2025.com/

## License

Materials licensed under Creative Commons Attribution 4.0 International (CC BY 4.0)
Code examples licensed under MIT License

---

**Last Updated**: 2025-12-08
**Workshop Date**: 2025-12-11
**Status**: Materials Development Phase
