# Voice harness summary

The private project uses an Appium/logcat harness for voice-command validation.

## Measured result

| Metric | Value |
|---|---|
| Gate | ENH-298a V2 reminder-command harness |
| Baseline p50/p95 | 2797/2934ms |
| Later regression gates | 2874-3254ms |
| Required pass signal | Tool invocation + DB side effect |

## Why this matters

The harness avoids a weak "text appeared" pass condition. A voice command only
passes when the runtime path produces the expected tool signal and persisted
side effect.

