export function buildPromptEn(category: string, jsonSchema: string, userInput: string): string {
  return `
You are a risk management expert and strategic analyst.
Your task is to analyze the decision below and produce a realistic failure simulation (pre-mortem).

CATEGORY: "${category}"
DECISION: "${userInput}"

INSTRUCTIONS:
1. Create EXACTLY 3 distinct failure scenarios that are plausible for this decision.
2. For each scenario, fill the schema fields and ensure:
   - id: "s1", "s2", "s3"
   - title max 10 words
   - narrative max 100 words
   - main_cause max 50 words
   - early_indicators exactly 3 items
   - prevention_actions at least 1 item with action and timing
   - use enum values exactly as defined in the schema
3. overall_confidence must follow the enum values in the schema.
4. confidence_reason must be filled when overall_confidence indicates low confidence, otherwise null.
5. clarification_needed must be a short question if input is unclear; otherwise null.
6. Use English.

JSON SCHEMA (MUST FOLLOW EXACTLY):
${jsonSchema}

RETURN ONLY VALID JSON THAT MATCHES THE SCHEMA, WITH NO EXTRA TEXT.
`;
}
