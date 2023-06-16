class HttpResponseModel{
  int? code;
  bool? status;
  String? message;
  dynamic data;

  HttpResponseModel({
    this.code,
    this.data,
    this.status,
    this.message,
  }); 
}