import 'package:share_plus/share_plus.dart';

typedef ShareFunction = Future<void> Function(String text);

class ShareService {
  ShareService._(this._share);

  /// Create a [ShareService] that uses `share_plus` package.
  factory ShareService.withSharePlus() => ShareService._(Share.share);

  /// Create a [ShareService] with a custom share function.
  factory ShareService.custom(ShareFunction share) => ShareService._(share);

  final ShareFunction _share;

  Future<void> share(String text) async {
    await _share(text);
  }
}
