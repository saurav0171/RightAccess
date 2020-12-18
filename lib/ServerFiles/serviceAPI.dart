import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:connectivity/connectivity.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:http/http.dart';
import 'package:image/image.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:right_access/Globals/globals.dart';

Future<dynamic> CallApi(String httpType, dynamic params, String url) async {

var connectivityResult = await (new 
  Connectivity().checkConnectivity());
if (connectivityResult == ConnectivityResult.none)
 {
   var jsonError = {"error": "No Internet Connection. Please check your Connection", "code": "401"};
   return jsonError;
 }

  var response;
  dynamic user = await GetSharedPreference(kDataLoginUser);
  try {
    if (httpType == "GET") {
      if (user == null) {
        response = await http.get(url);
      } else {
        response = await http
            .get(url, headers: {"Authorization": "Bearer ${user[kDataToken]}"});
      }
    } else {
      if (user == null) {
        response = await http.post(url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: params);
      } else {
        response = await http.post(url,
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
              "Authorization": "Bearer ${user[kDataToken]}"
            },
            body: params);
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
  }
   else if (response.statusCode == 401) {
    var jsonResponse = convert.jsonDecode(response.body);
    var jsonError = {"error": jsonResponse[kDataErrors], "code": response.statusCode.toString(),"message":jsonResponse[kDataMessage]};
    return jsonError;
  } else if (response.statusCode == 422) {
    var jsonResponse = convert.jsonDecode(response.body);
    var jsonError = {"error": jsonResponse[kDataErrors], "code": response.statusCode.toString(),"message":jsonResponse[kDataMessage]};
    return jsonError;
  } else if (response.statusCode == 500) {
   var jsonResponse = convert.jsonDecode(response.body);
    var jsonError = {"error": jsonResponse[kDataErrors], "code": response.statusCode.toString(),"message":jsonResponse[kDataMessage]};

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

  Map<String, String> headers = {
    "Content-type": "application/x-www-form-urlencoded"
  };

  Response response = await http.post(url, headers: headers, body: params);
  // check the status code for the result
  int statusCode = response.statusCode;
  // this API passes back the id of the new item added to the body
  String body = response.body;
  print("Output is : $body");
  // {
  //   "title": "Hello",
  //   "body": "body text",
  //   "userId": 1,
  //   "id": 101
  // }
}


// Future<File> testCompressAndGetFile(File file, String targetPath) async {
//     print("testCompressAndGetFile");
//     final result = await FlutterImageCompress.compressAndGetFile(
//       file.absolute.path,
//       targetPath,
//       quality: 90,
//       minWidth: 1024,
//       minHeight: 1024,
//       rotate: 360,
//     );

//     print(file.lengthSync());
//     print(result.lengthSync());

//     return result;
//   }

Future<dynamic> CallUploadImage(File image, String groupId, String mobileList) async {
  var response;

  try {
    
    // open a byteStream
    // ignore: deprecated_member_use
    if (image.path.contains(".JPG")||image.path.contains(".PNG")||image.path.contains(".jpg")||image.path.contains(".png")||image.path.contains(".jpeg")||image.path.contains(".JPEG")) 
    {
       final dir = await path_provider.getTemporaryDirectory();
      final targetPath = dir.absolute.path + "/"+basename(image.path);
      // image = await testCompressAndGetFile(image, targetPath);
    }
   


    var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    // get file length
    var length = await image.length();

    // string to uri
    var uri = Uri.parse('http://ws.qvic.in/api/fileshare');

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);


    request.fields['admin_id'] = globalCurrentUser[kDataID].toString();
    request.fields['group_id'] = groupId;
    request.fields['mobile_list'] = mobileList;
    request.fields['company_id'] = '1';


    // multipart that takes file.. here this "image_file" is a key of the API request
    var multipartFile = new http.MultipartFile('upload', stream, length, filename: basename(image.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send request to upload image
    await request.send().then((responsee) async {

      responsee.stream.transform(utf8.decoder).listen((value) {

        response=value;
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
  }else if (jsonResponse[kDataStatusCode] == 500) {
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
