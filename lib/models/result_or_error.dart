class ResultOrError {
  String? result;
  String? errorDescription;

  ResultOrError(this.result, this.errorDescription);

  setResult(String result) {
    this.result = result;
  }

  setException(String errorDescription) {
    this.errorDescription = errorDescription;
  }
}