export const ANALYSIS_JSON_SCHEMA = `{
  "scenarios": [
    {
      "id": "s1",
      "title": "string (maks 10 kata)",
      "narrative": "string (maks 100 kata)",
      "likelihood": "rendah | sedang | tinggi",
      "main_cause": "string (maks 50 kata)",
      "early_indicators": ["string", "string", "string"],
      "prevention_actions": [
        {
          "action": "string (maks 30 kata)",
          "timing": "hari ini | besok | minggu ini | bulan ini"
        }
      ]
    }
  ],
  "overall_confidence": "rendah | sedang | tinggi",
  "confidence_reason": "string (maks 50 kata) | null",
  "clarification_needed": "string | null"
}`;
