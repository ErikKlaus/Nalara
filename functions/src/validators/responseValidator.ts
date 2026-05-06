export type ConfidenceLevel = 'rendah' | 'sedang' | 'tinggi';
export type TimingValue = 'hari ini' | 'besok' | 'minggu ini' | 'bulan ini';

export interface PreventionAction {
  action: string;
  timing: TimingValue;
}

export interface Scenario {
  id: string;
  title: string;
  narrative: string;
  likelihood: ConfidenceLevel;
  main_cause: string;
  early_indicators: string[];
  prevention_actions: PreventionAction[];
}

export interface AnalysisResponse {
  scenarios: Scenario[];
  overall_confidence: ConfidenceLevel;
  confidence_reason: string | null;
  clarification_needed: string | null;
}

const CONFIDENCE_VALUES = new Set<ConfidenceLevel>(['rendah', 'sedang', 'tinggi']);
const TIMING_VALUES = new Set<TimingValue>(['hari ini', 'besok', 'minggu ini', 'bulan ini']);
const SCENARIO_IDS = new Set(['s1', 's2', 's3']);

function isNonEmptyString(value: unknown): value is string {
  return typeof value === 'string' && value.trim().length > 0;
}

function asStringOrNull(value: unknown): string | null {
  if (value === null) {
    return null;
  }

  if (value === undefined) {
    return null;
  }

  if (typeof value === 'string') {
    return value.trim().length > 0 ? value : null;
  }

  throw new Error('Field must be string or null');
}

function wordCount(value: string): number {
  return value.trim().split(/\s+/).filter(Boolean).length;
}

function extractJson(raw: string): string {
  const start = raw.indexOf('{');
  const end = raw.lastIndexOf('}');
  if (start >= 0 && end > start) {
    return raw.slice(start, end + 1);
  }
  return raw;
}

export function parseAndValidateResponse(raw: string): AnalysisResponse {
  let parsed: unknown;
  try {
    parsed = JSON.parse(raw);
  } catch {
    parsed = JSON.parse(extractJson(raw));
  }

  if (!parsed || typeof parsed !== 'object') {
    throw new Error('Response is not a JSON object');
  }

  const data = parsed as Record<string, unknown>;
  const scenarios = data.scenarios as unknown;
  if (!Array.isArray(scenarios) || scenarios.length !== 3) {
    throw new Error('Invalid scenarios count');
  }

  const overall = data.overall_confidence as unknown;
  if (!isNonEmptyString(overall) || !CONFIDENCE_VALUES.has(overall as ConfidenceLevel)) {
    throw new Error('Invalid overall_confidence');
  }

  const confidenceReason = asStringOrNull(data.confidence_reason as unknown);
  const clarificationNeeded = asStringOrNull(data.clarification_needed as unknown);

  if (overall === 'rendah' && !confidenceReason) {
    throw new Error('confidence_reason required for low confidence');
  }

  if (overall !== 'rendah' && confidenceReason) {
    throw new Error('confidence_reason must be null for non-low confidence');
  }

  const normalizedScenarios: Scenario[] = scenarios.map((scenario, index) => {
    if (!scenario || typeof scenario !== 'object') {
      throw new Error(`Scenario ${index + 1} is invalid`);
    }

    const s = scenario as Record<string, unknown>;

    const id = s.id as unknown;
    if (!isNonEmptyString(id)) {
      throw new Error(`Scenario ${index + 1} missing id`);
    }

    if (!SCENARIO_IDS.has(id.trim())) {
      throw new Error(`Scenario ${index + 1} has invalid id`);
    }

    const title = s.title as unknown;
    if (!isNonEmptyString(title)) {
      throw new Error(`Scenario ${index + 1} missing title`);
    }

    if (wordCount(title) < 2) {
      throw new Error(`Scenario ${index + 1} title too short`);
    }

    const narrative = s.narrative as unknown;
    if (!isNonEmptyString(narrative)) {
      throw new Error(`Scenario ${index + 1} missing narrative`);
    }

    if (wordCount(narrative) < 6) {
      throw new Error(`Scenario ${index + 1} narrative too short`);
    }

    const likelihood = s.likelihood as unknown;
    if (!isNonEmptyString(likelihood) || !CONFIDENCE_VALUES.has(likelihood as ConfidenceLevel)) {
      throw new Error(`Scenario ${index + 1} has invalid likelihood`);
    }

    const mainCause = s.main_cause as unknown;
    if (!isNonEmptyString(mainCause)) {
      throw new Error(`Scenario ${index + 1} missing main_cause`);
    }

    if (wordCount(mainCause) < 3) {
      throw new Error(`Scenario ${index + 1} main_cause too short`);
    }

    const indicators = s.early_indicators as unknown;
    if (!Array.isArray(indicators) || indicators.length !== 3 || indicators.some((item) => !isNonEmptyString(item))) {
      throw new Error(`Scenario ${index + 1} invalid early_indicators`);
    }

    const preventionActions = s.prevention_actions as unknown;
    if (!Array.isArray(preventionActions) || preventionActions.length === 0) {
      throw new Error(`Scenario ${index + 1} missing prevention_actions`);
    }

    const normalizedActions: PreventionAction[] = preventionActions.map((action, actionIndex) => {
      if (!action || typeof action !== 'object') {
        throw new Error(`Scenario ${index + 1} action ${actionIndex + 1} invalid`);
      }

      const a = action as Record<string, unknown>;
      const actionText = a.action as unknown;
      if (!isNonEmptyString(actionText)) {
        throw new Error(`Scenario ${index + 1} action ${actionIndex + 1} missing action`);
      }

      const timing = a.timing as unknown;
      if (!isNonEmptyString(timing) || !TIMING_VALUES.has(timing as TimingValue)) {
        throw new Error(`Scenario ${index + 1} action ${actionIndex + 1} invalid timing`);
      }

      return {
        action: actionText,
        timing: timing as TimingValue,
      };
    });

    return {
      id: id.trim(),
      title: title.trim(),
      narrative: narrative.trim(),
      likelihood: likelihood as ConfidenceLevel,
      main_cause: (mainCause as string).trim(),
      early_indicators: indicators.map((item) => (item as string).trim()),
      prevention_actions: normalizedActions,
    };
  });

  return {
    scenarios: normalizedScenarios,
    overall_confidence: overall as ConfidenceLevel,
    confidence_reason: confidenceReason,
    clarification_needed: clarificationNeeded,
  };
}
