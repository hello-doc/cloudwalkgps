enum StatusTypeEnum {
  idle,
  loading,
  loadingMore,
  searching,
  empty,
  error,
  success,
  validating,
  generic,
  finished;

  bool get isIdle => this == StatusTypeEnum.idle;
  bool get isLoading => this == StatusTypeEnum.loading;
  bool get isLoadingMore => this == StatusTypeEnum.loadingMore;
  bool get isSearching => this == StatusTypeEnum.searching;
  bool get isEmpty => this == StatusTypeEnum.empty;
  bool get isError => this == StatusTypeEnum.error;
  bool get isSuccess => this == StatusTypeEnum.success;
  bool get isValidating => this == StatusTypeEnum.validating;
  bool get isGeneric => this == StatusTypeEnum.generic;
  bool get isFinished => this == StatusTypeEnum.finished;
  bool get isLoadingOrLoadingMore => isLoading || isLoadingMore;
  bool get isLoadingOrFinished => isLoadingOrLoadingMore || isFinished;
}
