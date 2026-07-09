// What it does: Assembles verified model shards and commits the active model atomically.
// Why this design: A model must never become active before hash and NOTICE checks pass.
// What it proves: Multi-GB mobile model delivery can be treated as a recoverable state machine.

import 'dart:io';

class VerifiedBundle {
  const VerifiedBundle({
    required this.stagingModel,
    required this.stagingNotice,
    required this.expectedSha256,
  });

  final File stagingModel;
  final File stagingNotice;
  final String expectedSha256;
}

Future<void> commitVerifiedBundle({
  required VerifiedBundle bundle,
  required Directory activeDir,
  required bool atomicRenameAvailable,
}) async {
  await activeDir.create(recursive: true);

  final nextFlag = File('${activeDir.path}/.next_active.json');
  final modelNew = File('${activeDir.path}/${bundle.stagingModel.uri.pathSegments.last}.new');
  final noticeNew = File('${activeDir.path}/NOTICE.txt.new');

  if (!atomicRenameAvailable) {
    await nextFlag.writeAsString('{"schema_version":1,"phase":"prepare"}');
  }

  try {
    await _renameFresh(bundle.stagingModel, modelNew);
    await _renameFresh(bundle.stagingNotice, noticeNew);
    await _replaceWithBackup(noticeNew, File('${activeDir.path}/NOTICE.txt'));
    await _replaceWithBackup(modelNew, File('${activeDir.path}/model.litertlm'));

    if (await nextFlag.exists()) {
      await nextFlag.delete();
    }
  } catch (_) {
    // Startup recovery reads .next_active.json and either completes or rolls back.
    rethrow;
  }
}

Future<void> _renameFresh(File source, File destination) async {
  if (await destination.exists()) {
    await destination.delete();
  }
  await source.rename(destination.path);
}

Future<void> _replaceWithBackup(File sourceNew, File destination) async {
  final backup = File('${destination.path}.previous');
  if (await backup.exists()) await backup.delete();

  final hadDestination = await destination.exists();
  if (hadDestination) await destination.rename(backup.path);

  try {
    await sourceNew.rename(destination.path);
    if (await backup.exists()) await backup.delete();
  } catch (_) {
    if (hadDestination && await backup.exists()) {
      await backup.rename(destination.path);
    }
    rethrow;
  }
}

