import 'dart:convert';

class JsonHelpers {
  Object jsonBody(Map<String, dynamic> sendBody) {
    Map<String, dynamic> body = <String, dynamic>{};
    body.addAll(sendBody);
    return jsonEncode(body);
  }

  Object formDataBody(Map<String, dynamic> sendBody) {
    Map<String, dynamic> body = <String, dynamic>{};
    body.addAll(sendBody);
    return body;
  }
}
