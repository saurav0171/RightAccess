import 'package:flutter/material.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:right_access/ServerFiles/serviceAPI.dart';

class CountrySelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: <Widget>[
        new Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(color: appBackgroundColor)
            // decoration: setBackgroundImage(),
            ),
        Scaffold(
            backgroundColor: Colors.transparent,
            body: CountrySelectionExtension()),
      ],
    );
  }
}

class CountrySelectionExtension extends StatefulWidget {
  @override
  _CountryExtensionState createState() => _CountryExtensionState();
}

class _CountryExtensionState extends State<CountrySelectionExtension> {
  List countriesList = [];

  @override
  void initState() {
    super.initState();

    ShowLoader(context);
    fetchCountries();
  }

  fetchCountries() async {
    final url = "$baseUrl/countries?limit=200&page=1";
    var result = await CallApi("GET", null, url);
    if (result[kDataCode] == "200") {
      setState(() {
        countriesList = result[kDataData];
      });
    } else if (result[kDataCode] == "401") {
      ShowErrorMessage(result[kDataResult], context);
      HideLoader(context);
    } else if (result[kDataCode] == "422") {
      ShowErrorMessage(result[kDataMessage], context);
      HideLoader(context);
    } else {
      ShowErrorMessage(result[kDataError], context);
      HideLoader(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ListView.separated(
        itemCount: countriesList.length,
        padding: EdgeInsets.symmetric(horizontal: 0.0),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          countriesList[index]["attributes"]["name"],
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  // Navigator.push( context, setNavigationTransition(OrderDetails(orderDetailsObject = order)));
                });
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Divider(
              color: Colors.black26,
              height: 2,
              thickness: 2,
            ),
          );
        },
      ),
    );
  }
}
