# What it does: Converts Appium/logcat evidence into a strict voice-command verdict.
# Why this design: A voice test should pass only when runtime side effects are verified.
# What it proves: QA gates can validate behavior, not just UI text.

from dataclasses import dataclass


@dataclass(frozen=True)
class VoiceHarnessSignals:
    transcript_seen: bool
    tool_invoked: bool
    db_new_rows_count: int
    feedback_marker_seen: bool
    duration_ms: int


def classify_voice_turn(signals: VoiceHarnessSignals, latency_ceiling_ms: int) -> str:
    if not signals.transcript_seen:
        return "FAIL_TRANSCRIPT_MISSING"

    if not signals.tool_invoked:
        return "FAIL_TOOL_NOT_INVOKED"

    if signals.db_new_rows_count < 1:
        return "FAIL_DB_SIDE_EFFECT_MISSING"

    if not signals.feedback_marker_seen:
        return "FAIL_RUNTIME_FEEDBACK_MISSING"

    if signals.duration_ms > latency_ceiling_ms:
        return "FAIL_LATENCY_CEILING"

    return "PASS"


def example() -> str:
    return classify_voice_turn(
        VoiceHarnessSignals(
            transcript_seen=True,
            tool_invoked=True,
            db_new_rows_count=1,
            feedback_marker_seen=True,
            duration_ms=2797,
        ),
        latency_ceiling_ms=3200,
    )


if __name__ == "__main__":
    print(example())

