// What it does: Classifies tools and defers cloud-only tools when no cloud key exists.
// Why this design: The app should be honest offline; it must not fake cloud capability.
// What it proves: Tool routing fails closed instead of silently activating cloud paths.

enum ToolClass { localOnly, cloudOnly, hybrid }

class ToolClassRegistry {
  static const Map<String, ToolClass> _registry = {
    'set_reminder': ToolClass.localOnly,
    'save_note': ToolClass.localOnly,
    'list_notes': ToolClass.localOnly,
    'search_memory': ToolClass.localOnly,
    'create_calendar_event': ToolClass.localOnly,
    'web_search': ToolClass.cloudOnly,
    'cloud_image_gen': ToolClass.cloudOnly,
    'cloud_translate': ToolClass.cloudOnly,
  };

  static ToolClass classify(String toolName) {
    final normalized = toolName.trim().toLowerCase();
    return _registry[normalized] ?? ToolClass.localOnly;
  }
}

sealed class GateDecision {
  const GateDecision();
}

class ExecuteLocal extends GateDecision {
  const ExecuteLocal();
}

class DeferCloudTool extends GateDecision {
  const DeferCloudTool(this.toolName, this.reason);

  final String toolName;
  final String reason;
}

GateDecision evaluateToolGate({
  required String toolName,
  required bool cloudKeyAvailable,
  bool enableCloudToolDeferral = true,
}) {
  if (!enableCloudToolDeferral) return const ExecuteLocal();

  final toolClass = ToolClassRegistry.classify(toolName);
  if (toolClass != ToolClass.cloudOnly) return const ExecuteLocal();

  if (!cloudKeyAvailable) {
    return DeferCloudTool(toolName, 'cloud_unavailable_no_key');
  }

  return const ExecuteLocal();
}

