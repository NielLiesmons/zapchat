// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recentHistoryItemsHash() =>
    r'3656ed732ad42f07c8ef7f53d1d937163d8fdc01';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [recentHistoryItems].
@ProviderFor(recentHistoryItems)
const recentHistoryItemsProvider = RecentHistoryItemsFamily();

/// See also [recentHistoryItems].
class RecentHistoryItemsFamily extends Family<List<HistoryItem>> {
  /// See also [recentHistoryItems].
  const RecentHistoryItemsFamily();

  /// See also [recentHistoryItems].
  RecentHistoryItemsProvider call(
    BuildContext context,
    String currentModelId,
  ) {
    return RecentHistoryItemsProvider(
      context,
      currentModelId,
    );
  }

  @override
  RecentHistoryItemsProvider getProviderOverride(
    covariant RecentHistoryItemsProvider provider,
  ) {
    return call(
      provider.context,
      provider.currentModelId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recentHistoryItemsProvider';
}

/// See also [recentHistoryItems].
class RecentHistoryItemsProvider
    extends AutoDisposeProvider<List<HistoryItem>> {
  /// See also [recentHistoryItems].
  RecentHistoryItemsProvider(
    BuildContext context,
    String currentModelId,
  ) : this._internal(
          (ref) => recentHistoryItems(
            ref as RecentHistoryItemsRef,
            context,
            currentModelId,
          ),
          from: recentHistoryItemsProvider,
          name: r'recentHistoryItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recentHistoryItemsHash,
          dependencies: RecentHistoryItemsFamily._dependencies,
          allTransitiveDependencies:
              RecentHistoryItemsFamily._allTransitiveDependencies,
          context: context,
          currentModelId: currentModelId,
        );

  RecentHistoryItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.context,
    required this.currentModelId,
  }) : super.internal();

  final BuildContext context;
  final String currentModelId;

  @override
  Override overrideWith(
    List<HistoryItem> Function(RecentHistoryItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecentHistoryItemsProvider._internal(
        (ref) => create(ref as RecentHistoryItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        context: context,
        currentModelId: currentModelId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<HistoryItem>> createElement() {
    return _RecentHistoryItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentHistoryItemsProvider &&
        other.context == context &&
        other.currentModelId == currentModelId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, context.hashCode);
    hash = _SystemHash.combine(hash, currentModelId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecentHistoryItemsRef on AutoDisposeProviderRef<List<HistoryItem>> {
  /// The parameter `context` of this provider.
  BuildContext get context;

  /// The parameter `currentModelId` of this provider.
  String get currentModelId;
}

class _RecentHistoryItemsProviderElement
    extends AutoDisposeProviderElement<List<HistoryItem>>
    with RecentHistoryItemsRef {
  _RecentHistoryItemsProviderElement(super.provider);

  @override
  BuildContext get context => (origin as RecentHistoryItemsProvider).context;
  @override
  String get currentModelId =>
      (origin as RecentHistoryItemsProvider).currentModelId;
}

String _$historyHash() => r'7bdf6554bbc24193d6a0e95ef4c52505abab220d';

/// See also [History].
@ProviderFor(History)
final historyProvider =
    AutoDisposeAsyncNotifierProvider<History, List<HistoryEntry>>.internal(
  History.new,
  name: r'historyProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$historyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$History = AutoDisposeAsyncNotifier<List<HistoryEntry>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
