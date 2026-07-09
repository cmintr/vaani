# Benchmarks

Only measured values are listed here. Anything not measured stays out of the
CV and public claims.

## Device

| Item | Value |
|---|---|
| Device | Samsung SM-S938B |
| SoC | SM8750 |
| App state | Pre-release Android build |

## Local LLM

| Metric | Value |
|---|---|
| Model | Gemma 4 E4B LiteRT-LM |
| Model file | `gemma-4-E4B-it.litertlm` |
| File size | 3,659,530,240 bytes / 3.41 GiB |
| Decode throughput | p50 14.8 tok/s |
| First-token latency | p50 290ms |
| Drafter/MTP status | Rejected; standard decode retained |

## Voice-command harness

| Metric | Value |
|---|---|
| Harness | ENH-298a V2 reminder-command gate |
| Baseline p50/p95 | 2797/2934ms |
| Later regression gates | 2874-3254ms |
| Pass condition | Tool invoked + DB side effect verified |

## NPU candidate

| Metric | Value |
|---|---|
| Candidate | QNN/Whisper NPU decode path |
| CPU baseline | 1668ms average / 1682ms p95 via whisper.cpp |
| NPU candidate | 35-43s decode latency |
| Decision | Blocked from promotion; stable production route preserved |

## Memory

| Item | Value |
|---|---|
| Embedding model | EmbeddingGemma 300M |
| Embedding size | 768D |
| Vector store | sqlite-vec |
| Lexical search | FTS5/BM25 |
| Fusion | Reciprocal-rank fusion, `k=60` |

## Engineering controls

| Item | Count |
|---|---:|
| BUG files | 80 |
| ENH markdown specs | 167 |
| Active ENH feature folders | 121 |
| Canonical LLDs | 6 |
| Verification/evidence artifacts | 470+ |

## Not claimed

| Claim | Status |
|---|---|
| Exact quant level | Needs model provenance source before public claim |
| Exact audible voice-to-voice latency | Needs separate measurement |
| Current STT/TTS component split | Needs current-build revalidation |
| Battery percentage gain/loss | Needs battery-specific measurement |
