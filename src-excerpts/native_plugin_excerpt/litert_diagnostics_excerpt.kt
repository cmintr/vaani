// What it does: Emits a compact native inference diagnostic line at the platform boundary.
// Why this design: Device-only bugs need provider, timing and routing data in logcat.
// What it proves: Native/mobile inference paths can be made observable without exposing user text.

data class GenerationMetrics(
    val model: String,
    val provider: String,
    val tokens: Int,
    val firstTokenMs: Long,
    val totalMs: Long,
) {
    val tokensPerSecond: Double
        get() = if (totalMs <= 0L) 0.0 else tokens * 1000.0 / totalMs
}

fun emitGenerationMeta(metrics: GenerationMetrics) {
    val line = buildString {
        append("GEMMA4_META ")
        append("model=").append(metrics.model).append(' ')
        append("provider=").append(metrics.provider).append(' ')
        append("tokens=").append(metrics.tokens).append(' ')
        append("first_ms=").append(metrics.firstTokenMs).append(' ')
        append("total_ms=").append(metrics.totalMs).append(' ')
        append("tps=").append(String.format("%.1f", metrics.tokensPerSecond))
    }

    android.util.Log.i("VaaniPortfolio", line)
}

