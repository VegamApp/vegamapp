// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_data.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeData on _HomeDataBase, Store {
  Computed<Map<String, dynamic>>? _$dataComputed;

  @override
  Map<String, dynamic> get data =>
      (_$dataComputed ??= Computed<Map<String, dynamic>>(() => super.data,
              name: '_HomeDataBase.data'))
          .value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(() => super.isLoading,
              name: '_HomeDataBase.isLoading'))
          .value;
  Computed<bool>? _$hasExceptionsComputed;

  @override
  bool get hasExceptions =>
      (_$hasExceptionsComputed ??= Computed<bool>(() => super.hasExceptions,
              name: '_HomeDataBase.hasExceptions'))
          .value;
  Computed<String?>? _$errorMsgComputed;

  @override
  String? get errorMsg =>
      (_$errorMsgComputed ??= Computed<String?>(() => super.errorMsg,
              name: '_HomeDataBase.errorMsg'))
          .value;
  Computed<double>? _$homeCarouselAspectRatioComputed;

  @override
  double get homeCarouselAspectRatio => (_$homeCarouselAspectRatioComputed ??=
          Computed<double>(() => super.homeCarouselAspectRatio,
              name: '_HomeDataBase.homeCarouselAspectRatio'))
      .value;

  late final _$_dataAtom = Atom(name: '_HomeDataBase._data', context: context);

  @override
  Map<String, dynamic> get _data {
    _$_dataAtom.reportRead();
    return super._data;
  }

  @override
  set _data(Map<String, dynamic> value) {
    _$_dataAtom.reportWrite(value, super._data, () {
      super._data = value;
    });
  }

  late final _$_isLoadingAtom =
      Atom(name: '_HomeDataBase._isLoading', context: context);

  @override
  bool get _isLoading {
    _$_isLoadingAtom.reportRead();
    return super._isLoading;
  }

  @override
  set _isLoading(bool value) {
    _$_isLoadingAtom.reportWrite(value, super._isLoading, () {
      super._isLoading = value;
    });
  }

  late final _$_homeCarouselAspectRatioAtom =
      Atom(name: '_HomeDataBase._homeCarouselAspectRatio', context: context);

  @override
  double get _homeCarouselAspectRatio {
    _$_homeCarouselAspectRatioAtom.reportRead();
    return super._homeCarouselAspectRatio;
  }

  @override
  set _homeCarouselAspectRatio(double value) {
    _$_homeCarouselAspectRatioAtom
        .reportWrite(value, super._homeCarouselAspectRatio, () {
      super._homeCarouselAspectRatio = value;
    });
  }

  late final _$_errorMsgAtom =
      Atom(name: '_HomeDataBase._errorMsg', context: context);

  @override
  String? get _errorMsg {
    _$_errorMsgAtom.reportRead();
    return super._errorMsg;
  }

  @override
  set _errorMsg(String? value) {
    _$_errorMsgAtom.reportWrite(value, super._errorMsg, () {
      super._errorMsg = value;
    });
  }

  late final _$_hasExceptionsAtom =
      Atom(name: '_HomeDataBase._hasExceptions', context: context);

  @override
  bool get _hasExceptions {
    _$_hasExceptionsAtom.reportRead();
    return super._hasExceptions;
  }

  @override
  set _hasExceptions(bool value) {
    _$_hasExceptionsAtom.reportWrite(value, super._hasExceptions, () {
      super._hasExceptions = value;
    });
  }

  late final _$getHomeDataAsyncAction =
      AsyncAction('_HomeDataBase.getHomeData', context: context);

  @override
  Future getHomeData(BuildContext context) {
    return _$getHomeDataAsyncAction.run(() => super.getHomeData(context));
  }

  late final _$_HomeDataBaseActionController =
      ActionController(name: '_HomeDataBase', context: context);

  @override
  dynamic putAspectRatio(double aspectRatio) {
    final _$actionInfo = _$_HomeDataBaseActionController.startAction(
        name: '_HomeDataBase.putAspectRatio');
    try {
      return super.putAspectRatio(aspectRatio);
    } finally {
      _$_HomeDataBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$_HomeDataBaseActionController.startAction(
        name: '_HomeDataBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_HomeDataBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
data: ${data},
isLoading: ${isLoading},
hasExceptions: ${hasExceptions},
errorMsg: ${errorMsg},
homeCarouselAspectRatio: ${homeCarouselAspectRatio}
    ''';
  }
}
