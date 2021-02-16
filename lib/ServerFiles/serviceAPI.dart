import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:connectivity/connectivity.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'dart:convert' as convert;
import 'package:path/path.dart';
import 'package:http/http.Dart' as http;

Future<dynamic> CallApi(String httpType, dynamic params, String url) async {
  var connectivityResult = await (new Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    var jsonError = {
      "error": "No Internet Connection. Please check your Connection",
      "code": "401"
    };
    return jsonError;
  }

  var body = json.encode(params);
  var response;
  dynamic user = await GetSharedPreference(kDataLoginUser);
  try {
    if (httpType == "GET") {
      if (user == null) {
        response = await http.get(url);
      } else {
        response = await http
            .get(url, headers: {"Authorization": "Bearer ${user[kDataToken]}", "Accept": "application/json","Content-Type": "application/json",});
      }
    } else {
      if (user == null) {
        response = await http.post(url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: body);
      } else {
        response = await http.post(url,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${user[kDataToken]}",
              "Accept": "application/json",
            },
            body: body);
      }
    }
  } on HandshakeException catch (_) {
    var jsonError = {
      "message": "Server not responding. Please try again later",
      "code": "500"
    };
    return jsonError;
  } on TimeoutException catch (_) {
    // A timeout occurred.
    var jsonError = {
      "message": "Server not responding. Please try again later",
      "code": "500"
    };
    return jsonError;
  } on SocketException catch (_) {
    // Other exception
    var jsonError = {
      "error": "Something went wrong. Please try again later.",
      "code": "500"
    };
    return jsonError;
  }

  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    jsonResponse[kDataCode] = "200";
    return jsonResponse;
  } else if (response.statusCode == 401) {
    var jsonResponse = convert.jsonDecode(response.body);
    var jsonError = {
      "error": jsonResponse[kDataErrors],
      "code": response.statusCode.toString(),
      "message": jsonResponse[kDataMessage]
    };
    return jsonError;
  }else if (response.statusCode == 404) {
    var jsonResponse = convert.jsonDecode(response.body);
    var jsonError = {
      "error": jsonResponse[kDataErrors],
      "code": response.statusCode.toString(),
      "message": jsonResponse[kDataMessage]
    };
    return jsonError;
  } 
   else if (response.statusCode == 422) {
    var jsonResponse = convert.jsonDecode(response.body);
    var jsonError = {
      "error": jsonResponse[kDataErrors],
      "code": response.statusCode.toString(),
      "message": jsonResponse[kDataMessage]
    };
    return jsonError;
  } else if (response.statusCode == 500) {
    var jsonResponse = convert.jsonDecode(response.body);
    var jsonError = {
      "error": jsonResponse[kDataErrors],
      "code": response.statusCode.toString(),
      "message": jsonResponse[kDataMessage]
    };

    return jsonError;
  } else {
    print("Request failed with status: ${response.statusCode}.");
    var jsonError = {
      "error": "Something went wrong. Please try again later.",
      "code": "404"
    };
    return jsonError;
  }
}

void makePostRequest(String httpType, dynamic params, String url) async {
  // set up POST request arguments

  // Map<String, String> headers = {
  //   "Content-type": "application/x-www-form-urlencoded"
  // };
  //
  // Response response = await http.post(url, headers: headers, body: params);
  // // check the status code for the result
  // int statusCode = response.statusCode;
  // // this API passes back the id of the new item added to the body
  // String body = response.body;
  // print("Output is : $body");
  // {
  //   "title": "Hello",
  //   "body": "body text",
  //   "userId": 1,
  //   "id": 101
  // }
}



Future<dynamic> inviteRegistration(File image, String profession, String city,
     bool isTerm, String id) async {
  var response;



  try {
    dynamic user = await GetSharedPreference(kDataLoginUser);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${user[kDataToken].toString()}",
      "Content-Type": "multipart/form-data"
    };
    var multipartFile;
    if(image!=null && image.path.isNotEmpty){
      var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
      // get file length
      var length = await image.length();
      multipartFile = new http.MultipartFile('document', stream, length,
          filename: basename(image.path));
    }
    // string to uri
    var uri = Uri.parse(baseUrl + '/events/$id/register');

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    request.headers.addAll(headers);
    request.fields['profession'] = profession;
    // request.fields['organization_name'] = organ;
    request.fields['city'] = city;
    request.fields['terms_and_conditions'] = isTerm ? "1" : "0";

    // multipart that takes file.. here this "image_file" is a key of the API request

    if(image!=null && image.path.isNotEmpty) {
      // add file to multipart
      request.files.add(multipartFile);
    }

    // send request to upload image
    await request.send().then((responsee) async {
      responsee.stream.transform(utf8.decoder).listen((value) {
        response = value;
      });
    }).catchError((e) {
      print(e);
    });
  } on TimeoutException catch (_) {
    // A timeout occurred.
    var jsonError = {
      kDataResult: "Server not responding. Please try again later",
      kDataCode: "500"
    };
    return jsonError;
  } on SocketException catch (_) {
    // Other exception
    var jsonError = {
      kDataResult: "Something went wrong. Please try again later.",
      kDataCode: "500"
    };
    return jsonError;
  }
  var jsonResponse;
  try {
    jsonResponse = convert.jsonDecode(response);
    return jsonResponse;
  } on Exception catch (_) {
    var jsonError = {
      kDataResult: "Something went wrong. Please try again later.",
      kDataCode: "500"
    };
    return jsonError;
  }
  
}

Future<dynamic> help(File image, String message) async {
  var response;

  try {
    dynamic user = await GetSharedPreference(kDataLoginUser);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${user[kDataToken].toString()}",
      "Content-Type": "multipart/form-data"
    };

    var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    // get file length
    var length = await image.length();

    // string to uri
    var uri = Uri.parse(baseUrl + '/help');

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    request.headers.addAll(headers);
    request.fields['message'] = message;

    // multipart that takes file.. here this "image_file" is a key of the API request
    var multipartFile = new http.MultipartFile('file_name', stream, length,
        filename: basename(image.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send request to upload image
    await request.send().then((responsee) async {
      responsee.stream.transform(utf8.decoder).listen((value) {
        response = value;
      });
    }).catchError((e) {
      print(e);
    });
  } on TimeoutException catch (_) {
    // A timeout occurred.
    var jsonError = {
      kDataResult: "Server not responding. Please try again later",
      kDataCode: "500"
    };
    return jsonError;
  } on SocketException catch (_) {
    // Other exception
    var jsonError = {
      kDataResult: "Something went wrong. Please try again later.",
      kDataCode: "500"
    };
    return jsonError;
  }
  var jsonResponse;
  try {
    jsonResponse = convert.jsonDecode(response);
    return jsonResponse;
  } on Exception catch (_) {
    var jsonError = {
      kDataResult: "Something went wrong. Please try again later.",
      kDataCode: "500"
    };
    return jsonError;
  }
  
}

Future<dynamic> skipRegistration() async {
  var response;

  try {
    dynamic user = await GetSharedPreference(kDataLoginUser);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${user[kDataToken].toString()}",
      "Content-Type": "multipart/form-data"
    };

    // string to uri
    var uri = Uri.parse(baseUrl + 'events/3/register/skip');

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    request.headers.addAll(headers);

    // send request to upload image
    await request.send().then((responsee) async {
      responsee.stream.transform(utf8.decoder).listen((value) {
        response = value;
      });
    }).catchError((e) {
      print(e);
    });
  } on TimeoutException catch (_) {
    // A timeout occurred.
    var jsonError = {
      kDataResult: "Server not responding. Please try again later",
      kDataCode: "500"
    };
    return jsonError;
  } on SocketException catch (_) {
    // Other exception
    var jsonError = {
      kDataResult: "Something went wrong. Please try again later.",
      kDataCode: "500"
    };
    return jsonError;
  }
  var jsonResponse;
  try {
    jsonResponse = convert.jsonDecode(response);
  } on Exception catch (_) {
    var jsonError = {
      kDataResult: "Something went wrong. Please try again later.",
      kDataCode: "500"
    };
    return jsonError;
  }
  if (jsonResponse[kDataStatusCode] == 200) {
    jsonResponse[kDataCode] = "200";
    return jsonResponse;
  } else if (jsonResponse[kDataStatusCode] == 401) {
    var jsonError = {kDataResult: jsonResponse[kDataResult], kDataCode: "401"};
    return jsonError;
  } else if (jsonResponse[kDataStatusCode] == 204) {
    var jsonError = {kDataResult: jsonResponse[kDataResult], kDataCode: "204"};
    return jsonError;
  } else if (jsonResponse[kDataStatusCode] == 500) {
    var jsonError = {kDataResult: jsonResponse[kDataResult], kDataCode: "500"};
    Future.delayed(const Duration(milliseconds: 500), () {
      RemoveSharedPreference(kDataLoginUser);
//      SetHomePage(0);
    });
    return jsonError;
  } else {
    var jsonError = {
      kDataResult: "Something went wrong. Please try again later.",
      kDataCode: "404"
    };
    return jsonError;
  }
}


