class ResultStringOrError {
  String? result;
  String? errorDescription;

  ResultStringOrError(this.result, this.errorDescription);

  setResult(String result) {
    this.result = result;
  }

  setException(String errorDescription) {
    this.errorDescription = errorDescription;
  }
}

class ResultBoolOrError {
  bool? result;
  String? errorDescription;

  ResultBoolOrError(this.result, this.errorDescription);

  setResult(bool? result) {
    this.result = result;
  }

  setException(String errorDescription) {
    this.errorDescription = errorDescription;
  }
}