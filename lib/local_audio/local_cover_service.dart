import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:collection/collection.dart';

import '../compute_isolate.dart';
import '../constants.dart';
import '../persistence_utils.dart';

class LocalCoverService {
  final _propertiesChangedController = StreamController<bool>.broadcast();
  Stream<bool> get propertiesChanged => _propertiesChangedController.stream;

  var _store = <String, Uint8List?>{};
  int get storeLength => _store.length;

  Future<Uint8List?> getCover({
    required String albumId,
    required String path,
  }) async {
    final file = File(path);
    if (file.existsSync() && albumId.isNotEmpty == true) {
      final metadata = readMetadata(file, getImage: true);
      final cover = _put(
        albumId: albumId,
        data: metadata.pictures
            .firstWhereOrNull((e) => e.bytes.isNotEmpty)
            ?.bytes,
      );
      if (cover != null) {
        _propertiesChangedController.add(true);
      }
      return cover;
    }
    return null;
  }

  Uint8List? _put({required String albumId, Uint8List? data}) {
    return _store.containsKey(albumId)
        ? _store.update(albumId, (value) => data)
        : _store.putIfAbsent(albumId, () => data);
  }

  Uint8List? get(String? albumId) => albumId == null ? null : _store[albumId];

  Future<void> write() async => writeUint8ListMap(_store, kCoverStore);

  // This does not make much sense except for small libs, where the store is filled
  // fast anyways. Let's keep it for eventual use...
  Future<void> read() async =>
      _store = await computeIsolate(() => readUint8ListMap(kCoverStore)) ?? [];

  Future<void> dispose() async => _propertiesChangedController.close();
}
