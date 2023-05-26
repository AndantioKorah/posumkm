class HttpResponseModel{
  int? code;
  String? message;
  dynamic data;

  HttpResponseModel({
    this.code,
    this.data,
    this.message,
  }); 
}