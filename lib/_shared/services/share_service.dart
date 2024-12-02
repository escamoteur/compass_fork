/// TODO
class ShareService {
  ShareService._(this._share);

  /// Create a [ShareService] that uses `share_plus` package.
  factory ShareService.withSharePlus() => ShareService._(Share.share);

  /// Create a [ShareService] with a custom share function.
  factory ShareService.custom(ShareFunction share) => ShareService._(share);

  final ShareFunction _share;
  final _log = Logger('BookingShareUseCase');
}
