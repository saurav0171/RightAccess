library my_prj.globals;

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';

// import 'package:geocoder/geocoder.dart';

int isInitiallyLoaded = 0;
// Coordinates currentCoords;
Map globalCurrentUser;
Map currentAddress;
Map pickedDeliveryAddress;
int cartCount = 0;
// String mobileNumber = "";
int deviceType = 0;
String deviceToken="123456";
String voipToken = "123456";
String selectedMenuWidget;
String userType = "0";

List categoryData = [];
List <Map<String,String>>vendorProductsData = [];
List deliveryBoyData = [];
bool isVendor = false;

Function updateGlobalCartCount;
Function updateCategoryCartCount;
Function updateListCartCount;
Function updateWidgetList;
Function updateCart;
Function updateGroupInfo;
BuildContext notificationContext ;
FirebaseMessaging firebaseMessaging = FirebaseMessaging();
Map notificationObject ;
bool isAudioCallOnly = false;
String globalGroupName ;
String jwtToken;
String globalManagedCallUUID ;
String globalRTCChannelId ;
Timer timeOutTimer;
Function globalRefreshMeetingList;
Function globalRedefineSelections;
double bottomBarHeight = 0.0;
List globalUserListData;
List globalBloodGroupListData;
String globalProfileUrl;
String globalTabIndex = "1";
Coordinates currentCoords;
LocationData globalLocationData;
int indexTab = 0;
Map globalRetailerLogin = {};
Function manuallyUpdateTab;
Function updateDeliveryStatus;
Function updatePaymentDeliveryStatus;

// Call globalManagedCall;
// FCXCallController globalCallController;