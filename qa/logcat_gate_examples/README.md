# Logcat gate examples

Vaani uses permanent and debug-gated log markers to make device behavior
auditable. The public portfolio does not include raw private logs.

Useful marker classes:

- `GEMMA4_META`: local model provider, timing and token metrics.
- `TOOL_DEFERRED_CLOUD_UNAVAILABLE`: cloud-only tool deferred instead of faked.
- `MODEL_DL_*`: model download, verification and commit diagnostics.
- `qa.reminder.feedback_emitted|`: runtime side-effect marker for reminder tool tests.

The principle is simple: every device gate needs a machine-readable marker, and
every permanent marker must be documented so release scans do not remove it by
accident.

