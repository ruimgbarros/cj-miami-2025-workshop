# EXERCISE 2: SCIENCE FACT-CHECK ROUTER
# Three-stage pipeline: Extract claims → Classify by field → Expert fact-check

source("./code/r/utils/helpers.R")

cat("=== EXERCISE 2: TikTok Science Fact-Checking Pipeline ===\n\n")

# ==============================================================================
# FICTIONAL TIKTOK TRANSCRIPTS
# ==============================================================================

tiktok_videos <- list(
  list(
    id = 1,
    transcript = "Okay so I've been drinking apple cider vinegar every single morning for like 30 days and my blood sugar is completely normal now. I had pre-diabetes and my doctor was gonna put me on medication but I said no. This stuff literally cures diabetes, you just need two tablespoons in warm water before breakfast. Big pharma doesn't want you to know this because they can't make money off vinegar."
  ),
  list(
    id = 2,
    transcript = "PSA for everyone who got the COVID vaccine - you need to detox your body NOW. The mRNA literally changes your DNA permanently, that's why so many people are getting sick. I've been taking zeolite clay and activated charcoal to pull the spike proteins out of my system. Check the link in my bio for the detox protocol."
  ),
  list(
    id = 3,
    transcript = "Did you know MSG is literally poison? It's in almost all processed food and restaurants use it to make you addicted. It causes brain damage, cancer, and obesity. I stopped eating anything with MSG three months ago and lost 15 pounds without even trying. Always check your labels!"
  ),
  list(
    id = 4,
    transcript = "Everyone freaking out about climate change needs to see this data. NASA's own satellites show the ice caps are actually GROWING, not melting. Antarctica had record ice levels in 2023. The media won't show you this because climate change is a trillion dollar industry. They need you scared to keep making money."
  ),
  list(
    id = 5,
    transcript = "You know what they don't tell you about CO2? It's literally plant food. More CO2 means more plants, which means more oxygen and more food for everyone. We're actually in a CO2 drought compared to prehistoric times when plants were HUGE. Calling it a pollutant is insane, we literally exhale it."
  ),
  list(
    id = 6,
    transcript = "So I was at the museum yesterday and they had this whole exhibit about dinosaurs being millions of years old. But here's the thing - they found soft tissue in dinosaur bones. Soft tissue can't survive more than a few thousand years, it's basic biology. This proves dinosaurs and humans lived at the same time, they're just hiding it from us."
  ),
  list(
    id = 7,
    transcript = "Let me explain why GMO foods are dangerous. When you eat GMO corn, you're eating corn that has animal genes spliced into it. Those genes don't break down in your stomach - they literally integrate into YOUR DNA. That's why we're seeing all these new diseases and allergies that didn't exist before GMOs were introduced in the 90s."
  ),
  list(
    id = 8,
    transcript = "Everyone needs to see this. I measured the electromagnetic radiation coming from my neighbor's 5G tower and it's literally off the charts. This frequency is the same one used in military crowd control weapons. It can literally penetrate your skull and affect your brain waves. I've had constant headaches since they installed it and my phone keeps disconnecting, coincidence? I don't think so."
  ),
  list(
    id = 9,
    transcript = "Okay I'm just gonna say it - the Earth is not a spinning ball flying through space. If it was spinning 1000 mph, water would fly off. But water ALWAYS finds its level, that's basic physics. I poured water on a basketball and it all fell off. Same thing would happen with oceans on a ball Earth. Use your common sense, people!"
  )
)

# ==============================================================================
# STAGE 1: CLAIM EXTRACTION
# ==============================================================================

extract_claims <- function(transcript) {
  prompt <- sprintf(
    "
Extract ONLY the verifiable scientific or factual claims from this TikTok transcript.

INCLUDE:
- General statements about how things work (e.g., \"MSG causes brain damage\")
- Causal claims (e.g., \"Vaccines change your DNA\")
- Statistical or data claims (e.g., \"Ice caps are growing\")
- Scientific mechanisms (e.g., \"GMO genes integrate into human DNA\")

EXCLUDE:
- Personal anecdotes (\"I drank this for 30 days\")
- Personal experiences (\"I lost 15 pounds\")
- Personal medical history (\"I had pre-diabetes\")
- Conspiracy theories without factual claims (\"Big pharma doesn't want you to know\")

Return ONLY the verifiable claims as a numbered list, one claim per line.

Transcript: %s
",
    transcript
  )

  response <- query_ai(key, prompt)
  return(response)
}

# ==============================================================================
# STAGE 2: CLASSIFICATION
# ==============================================================================

classify_claim <- function(claim) {
  prompt <- sprintf(
    "
You are routing scientific claims to specialized fact-checking experts.

Classify this claim into EXACTLY ONE category based on the primary scientific field needed to evaluate it:

MEDICINE - Health, disease, treatments, vaccines, drugs, nutrition, medical procedures, human physiology
CLIMATE - Climate change, global warming, ice caps, emissions, temperature trends, weather patterns
BIOLOGY - Evolution, genetics, GMOs, DNA, organisms, cells, biological processes, ecology
PHYSICS - Energy, radiation, electromagnetic fields, mechanics, physical laws, Earth's rotation/gravity

Claim: %s

Respond with ONLY ONE WORD - the category name in ALL CAPS:
MEDICINE
CLIMATE
BIOLOGY
PHYSICS

Do not include any explanation or punctuation. Just the category name.
",
    claim
  )

  response <- query_ai(key, prompt)
  # Clean up response to get just the category
  category <- trimws(gsub("[^A-Z]", "", response))
  return(category)
}

# ==============================================================================
# STAGE 3: EXPERT FACT-CHECKING
# ==============================================================================

expert_prompts <- list(
  MEDICINE = "
You are a medical fact-checker for a major news organization.
Evaluate this health claim against current medical and scientific consensus.

Claim: %s

Provide a fact-check in this EXACT format:

VERDICT: [TRUE / FALSE / MISLEADING / UNSUBSTANTIATED]

EXPLANATION: [2-3 clear sentences explaining the scientific consensus. Use active voice. Be direct.]

EVIDENCE: [Cite specific sources: peer-reviewed studies, CDC/FDA/WHO guidelines, or established medical principles. Include publication dates when relevant.]

CONTEXT: [1 sentence on why this matters or what the public should know.]

Write for a general audience. Be authoritative but accessible. Correct the misinformation directly.
",

  CLIMATE = "
You are a climate science fact-checker for a major news organization.
Evaluate this climate claim against current scientific data and consensus.

Claim: %s

Provide a fact-check in this EXACT format:

VERDICT: [TRUE / FALSE / MISLEADING / UNSUBSTANTIATED]

EXPLANATION: [2-3 clear sentences explaining what climate science actually shows. Use active voice. Be direct.]

EVIDENCE: [Cite specific sources: NOAA, NASA, IPCC reports, or peer-reviewed research. Include data years when relevant.]

CONTEXT: [1 sentence addressing the common misunderstanding behind this claim.]

Write for a general audience. Address cherry-picked data or misinterpretations directly.
",

  BIOLOGY = "
You are a biology fact-checker for a major news organization.
Evaluate this biological claim against current scientific understanding.

Claim: %s

Provide a fact-check in this EXACT format:

VERDICT: [TRUE / FALSE / MISLEADING / UNSUBSTANTIATED]

EXPLANATION: [2-3 clear sentences explaining how the biological process actually works. Use active voice. Be direct.]

EVIDENCE: [Cite specific sources: peer-reviewed studies, established biological mechanisms, or expert consensus. Include relevant details.]

CONTEXT: [1 sentence on the actual science behind what the claim misrepresents.]

Write for a general audience. Explain the real biology clearly and correct misconceptions.
",

  PHYSICS = "
You are a physics fact-checker for a major news organization.
Evaluate this physics claim against established physical laws and measurements.

Claim: %s

Provide a fact-check in this EXACT format:

VERDICT: [TRUE / FALSE / MISLEADING / UNSUBSTANTIATED]

EXPLANATION: [2-3 clear sentences explaining the actual physics. Use active voice. Show the math if relevant.]

EVIDENCE: [Cite specific laws, measurements, or peer-reviewed research. Include calculations or measurements that disprove false claims.]

CONTEXT: [1 sentence on why this misconception persists or what the correct understanding is.]

Write for a general audience. Use concrete examples and numbers to counter misinformation.
"
)

fact_check_claim <- function(claim, category) {
  if (!category %in% names(expert_prompts)) {
    return("ERROR: Unknown category")
  }

  prompt <- sprintf(expert_prompts[[category]], claim)
  response <- query_ai(key, prompt)
  return(response)
}

# ==============================================================================
# MAIN PIPELINE
# ==============================================================================

process_tiktok_video <- function(video) {
  cat(strrep("=", 80), "\n")
  cat(sprintf("=== TikTok Video #%d ===\n", video$id))
  cat(strrep("=", 80), "\n")
  cat("\nTranscript:\n")
  cat(strwrap(video$transcript, width = 75), sep = "\n")
  cat("\n\n")

  # Stage 1: Extract claims
  cat("STAGE 1: Extracting claims...\n")
  claims_text <- extract_claims(video$transcript)
  cat("\nExtracted Claims:\n")
  cat(claims_text, "\n\n")

  # Parse claims (simple splitting by lines that start with numbers)
  claim_lines <- strsplit(claims_text, "\n")[[1]]
  claim_lines <- claim_lines[grepl("^[0-9]", claim_lines)]

  if (length(claim_lines) == 0) {
    cat("No claims extracted. Skipping...\n\n")
    return(NULL)
  }

  # Process each claim
  for (i in seq_along(claim_lines)) {
    claim <- gsub("^[0-9]+\\.\\s*", "", claim_lines[i])

    cat(strrep("-", 80), "\n")
    cat(sprintf("Claim %d: %s\n", i, claim))
    cat(strrep("-", 80), "\n\n")

    # Stage 2: Classify
    cat("STAGE 2: Classifying claim...\n")
    category <- classify_claim(claim)
    cat(sprintf("Category: %s\n\n", category))

    # Stage 3: Fact-check
    cat("STAGE 3: Fact-checking...\n")
    verdict <- fact_check_claim(claim, category)
    cat(verdict, "\n\n")
  }

  cat("\n")
}

# ==============================================================================
# RUN DEMO
# ==============================================================================

cat("Processing ", length(tiktok_videos), " TikTok videos...\n\n")


for (i in 1:min(2, length(tiktok_videos))) {
  process_tiktok_video(tiktok_videos[[i]])
  Sys.sleep(1) # Brief pause between videos
}

cat("\n")
cat(strrep("=", 80), "\n")
cat("DEMO COMPLETE\n")
cat(sprintf(
  "Processed %d of %d videos\n",
  min(3, length(tiktok_videos)),
  length(tiktok_videos)
))
cat(strrep("=", 80), "\n")
