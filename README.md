# Vaani

Pre-release local-first Android AI companion - architecture, measured
benchmarks, and representative code excerpts. Portfolio extract, not full
source.

## What this repo is

This repository is a curated evidence room for Vaani, a private pre-release
Android project. It contains:

- High-level architecture notes.
- Measured benchmark summaries from device evidence.
- Representative code excerpts with explanation.
- Sanitized QA and logcat-gate examples.

It is not the full product source, does not include model binaries, and does
not include private coordination history, local paths, customer data, personal
memory content, API-key handling, or unreleased product surfaces.

## Device and model snapshot

| Area | Value |
|---|---|
| Device | Samsung SM-S938B / SM8750 |
| Local LLM | Gemma 4 E4B LiteRT-LM container |
| Model file | `gemma-4-E4B-it.litertlm`, 3,659,530,240 bytes / 3.41 GiB |
| Memory | sqlite-vec, EmbeddingGemma 300M 768D, FTS5/BM25, RRF (`k=60`) |
| Voice QA | Appium/logcat harness with tool invocation + DB side-effect gate |

## Measured highlights

- Local decode: p50 14.8 tok/s.
- First-token latency: p50 290ms.
- Voice-command harness V2: p50/p95 2797/2934ms baseline.
- Later voice regression gates: 2874-3254ms, tool invocation and DB side
  effect verified.
- NPU candidate rejected: 35-43s NPU decode latency versus 1668ms average /
  1682ms p95 CPU whisper.cpp baseline.
- Engineering controls: 80 BUG files, 167 ENH specs, 121 active ENH folders,
  6 canonical LLDs and 470+ verification/evidence artifacts in the private
  development repo.

See [BENCHMARKS.md](BENCHMARKS.md) for the full measured-number sheet.

## Code excerpts

Each excerpt is deliberately small and starts with three lines:

```text
What it does:
Why this design:
What it proves:
```

Start here:

- [Hybrid memory retrieval](src-excerpts/memory_retrieval/hybrid_search_excerpt.rs)
- [Cloud-tool deferral gate](src-excerpts/tool_routing/cloud_tool_gate_excerpt.dart)
- [Model assembly and atomic commit](src-excerpts/model_download_state_machine/model_assembler_excerpt.dart)
- [Voice harness result gate](src-excerpts/voice_harness_parser/voice_harness_result_gate_excerpt.py)
- [Native diagnostics boundary](src-excerpts/native_plugin_excerpt/litert_diagnostics_excerpt.kt)

## Demo script

See [DEMO_SCRIPT.md](DEMO_SCRIPT.md) for a 60-second offline demo flow.

## Scope statement

Vaani is pre-release. Cloud-only tools are gated/deferred instead of silently
executed offline. This portfolio shows measured local capability and engineering
process, not a finished commercial product.
