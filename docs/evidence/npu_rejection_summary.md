# NPU rejection summary

The NPU path was measured and rejected rather than promoted on assumption.

| Path | Measured result |
|---|---|
| CPU whisper.cpp baseline | 1668ms average / 1682ms p95 |
| QNN/Whisper NPU candidate | 35-43s decode latency |
| Decision | Block promotion; preserve stable production route |

## Engineering significance

The result is intentionally included because it shows discipline: hardware
acceleration was tested against a measurable gate, failed the gate, and was held
instead of being shipped for architectural vanity.

