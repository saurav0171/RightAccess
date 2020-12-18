import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';             uncomment for firebase chat
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:right_access/Globals/globals.dart';
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/UI/login.dart';
import 'package:right_access/UI/loginOptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:right_access/Globals/globals.dart" as globals;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart';
// import 'package:paytm_payments/paytm_payments.dart';

// ******Color Code********//

final appBackgroundColor = Color(0xFFFFFFFF);
final appThemeColor1 = Color(0xFFE0161D);
final appThemeColor2 = Color(0xFF3885C6); 
// final lightTheme2Color = Color(0xFF04A4FF);





final galleryBackgroundColor = "#202021";
final greyShadeColor = "#434445";
final sideMenuColor = "#7CACAE";


// Constants

final baseUrl = "http://www.togetherevent.tk/api/v1";


final defaultFontFamily = "Comic Sans";
final defaultFontFamilyForAppBar = "edmunds";

final paytmTestMerchantID = "bUOkcU29274757569018";
final paytmTestMerchantKey = "E5_qntf8@%VK#3T6";

final paytmProductionMerchantID = "lvzwAr46030570995685";
final paytmProductionMerchantKey = "Li_e7eC1h02hCvfP";

final methodLogin = "login";
final methodSignup = "signup";
final methodGetMessagesList = "getMessages";
final methodPushMessage = "pushMessage";

final kDataLoginUser = "loginuser";
final kDataData = "data";
final kDataID = "id";
final kDataName = "name";
final kDataMobileNo = "mobileno";
final kDataCreatedDate = "createddate";
final kDataLastLoginDate = "lastlogindate";
final kDataCode = "code";
final kDataError = "error";
final kDataErrors = "errors";
final kDataSuccess = "success";
final kDataAPS = "aps";
final kDataMessage = "message";
final kDataNotification = "notification";
final kDataBody = "body";
final kDataAlert = "alert";
final kDataSender = "sender";
final kDatacreatedDate = "createdDate";
final kDataDate = "date";
final kDataDeviceToken = "devicetoken";
final kDataUser = "user";
final kDataUsers = "Users";
final kDatausers = "users";
final kDataToken = "token";
final kDataDashboard = "dashboard";
final kDataPhone = "phone";
final kDataPhoneNumber = "phone_number";
final kDataCountry = "country";
final kDataEmail = "email";
final kDataPassword = "password";
final kDataFirstname = "firstName";
final kDataLastname = "lastName";
final kDataStartDate = "start_date";
final kDataDueDate = "due_date";
final kDataDescription = "description";
final kDataMonth = "month";
final kDataYear = "year";
final kDataCountries = "countries";
final kDataTitle = "title";
final kDataFullName = "full_name";
final kDataStates = "states";
final kDataCities = "cities";
final kDataAddress = "address";
final kDataMobile = "mobile";
final kDataAvatar = "avatar";
final kDataOtpCode = "otpCode";
final kDataStatus = "status";
final kDataStatusCode = "status_code";
final kDataOtp = "otp";
final kDataIsAdmin = "is_admin";

final kDataCustomerData = "customer_data";
final kDataEntityId = "entityId";
final kDataProducts = "products";
final kDataCategoryName = "category_name";
final kDataPrice = "price";
final kDataShortDescription = "short_description";
final kDataShortImage = "short_image";
final kDataCustomOptions = "custom_options";
final kDataMilk = "milk";
final kDataOptionType = "option_type";
final kDataRequire = "require";
final kDataSize = "size";
final kDataOptionId = "option_id";
final kDataFlavour = "flavour";
final kDataAddOn = "addon";
final kDataCart = "cart";
final kDataCartData = "cart_data";
final kDataOptions = "options";
final kDataQty = "qty";
final kDataProductTitle = "product_title";
final kDataRowTotal = "row_total";
final kDataMethod = "method";
final kDataExtra = "extra";
final kDataType = "type";
final kDataCartItemId = "cart_item_id";
final kDataCartCount = "cart_count";
final kDataInludingTaxAmount = "inluding_tax_amount";
final kDataWithoutTaxAmount = "without_tax_amount";
final kDataTaxAmount = "tax_amount";
final kDataChecksumhash = "CHECKSUMHASH";
final kDataBaseAmount = "base_amount";
final kDatadiscount = "discount";
final kDataFinalAmount = "final_amount";
final kDataDOB = "dob";
final kDataGender = "gender";
final kDataResult = "result";
final kDataUserId = "user_id";
final kDataUser_Name = "user_name";
final kDataUserName = "username";
final kDataCategoriesName = "categories_name";
final kDataCategoriesId = "categories_id";
final kDataCategoryId = "category_id";
final kDataSubCategories = "sub_categories";
final kDataProductsName = "products_name";
final kDataProductsPrice = "products_price";
final kDataProductPrice = "product_price";
final kDataProductsId = "products_id";
final kDataProductId = "product_id";
final kDataProductsImage = "products_image";
final kDataImage = "image";
final kDataWishlistStatus = "wishlist_status";
final kDataChildName = "child_name";
final kDataClassName = "class_name";
final kDataHouseName = "house_name";
final kDataHouse = "house";
final kDataHouses = "houses";
final kDataAge = "age";
final kDataClassId = "class_id";
final kDataClass = "class";
final kDataClasses = "classes";
final kDataQuantity = "quantity";
final kDataTotal = "total";
final kDataStock = "stock";
final kDataCartStatus = "cart_status";
final kDataTotalPrice = "totalprice";
final kDataProductDescription = "product_description";
final kDataHouseId = "house_id";
final kDataChildId = "child_id";
final kDataCountryId = "country_id";
final kDataCountryName = "country_name";
final kDataStateId = "state_id";
final kDataStateName = "state_name";
final kDataChildren = "children";
final kDataRegnId = "regn_id";
final kDataSizes = "sizes";
final kDataSizeId = "size_id";
final kDataOrderPrice = "order_price";
final kDataTotalTax = "total_tax";
final kDataShippingCost = "shipping_cost";
final kDataCouponPrice = "coupon_price";
final kDataGrossTotal = "gross_total";
final kDataOrderId = "order_id";
final kDataOrdersStatus = "orders_status";
final kDataDateOfPurchase = "date_of_purchase";
final kDataReturnStatus = "return_status";
final kDataOrdersId = "orders_id";
final kDataReturnDate = "return_date";
final kDataAmount = "amount";
final kDataKey = "key";
final kDataValue = "value";
final kDataAttributes = "attributes";
final kDataOptionsId = "options_id";
final kDataOptionsName = "options_name";
final kDataOptionsValues = "option_values";
final kDataProductsAttributesId = "products_attributes_id";
final kDataOptionValueName = "option_value_name";
final kDataColors = "colors";
final kDataCouponStatus = "coupon_status";
final kDataCouponCode = "coupon_code";
final kDataFinalPrice = "final_price";
final kDataReturnTracking = "return_tracking";
final kDataOrdersStatusId = "orders_status_id";
final kDataOptionValues = "option_values";
final kDataOptionValuePrice = "option_value_price";
final kDataOriginalImage = "original_image";
final kDataColor = "color";
final kDataPricePrefix = "price_prefix";
final kDataAppVersion = "appVersion";
final kDataBypass = "bypass";
final kDataVersion = "version";
final kDataInfo = "info";
final kDataRating = "rating";
final kDataComment = "comment";
final kDataRate = "rate";


final kDataOTT = "ott";
final kDataRentPrice = "rent_price";
final kDataBuyPrice = "buy_price";
final kDataPurchaseStatus = "purchase_status";
final kDataActivity = "activity";
final kDataBalance = "balance";
final kDataAddedOn = "added_on";
final kDataOttType = "ott_type";
final kDataOrderStatus = "order_status";
final kDataStartDatetime = "start_datetime";
final kDataEndDatetime = "end_datetime";
final kDataIsMobileProvided = "is_mobile_provided";
final kDataUpRating = "up_rating";
final kDataDownRating = "down_rating";
final kDataErrorBalance = "error_balance";
final kDataSavedAddress = "savedAddress";
final kDataCurrentAddress = "currentAddress";
final kDataCoordinates = "coordinates";
final kDataLatitude = "latitude";
final kDataLongitude = "longitude";
final kDataSelectedShippingAddress = "selectedShippingAddress";
final kDataShopImage = "shop_image";
final kDataShopAddress = "shop_address";
final kDataPhoto = "photo";
final kDataUserType = "user_type";
final kDataRole = "role";
final kDataUserRole = "user_role";
final kDataCartItems = "cartitems";
final kDataCartId = "cart_id";
final kDataUserLatitude = "user_latitude";
final kDataUserLongitude = "user_longitude";
final kDataUserLat = "user_lat";
final kDataUserLong = "user_long";
final kDataIsTermsConditionsAccepted = "isterms";
final kDataBasePrice = "base_price";
final kDataIsIncart = "is_in_cart";
final kDataIsAuthorized = "isAuthorized";
final kDataOrderNumber = "order_number";
final kDataCreatedAt = "created_at";
final kDataCustomerDetail = "customer_detail";
final kDataFrontDoc = "front_doc";
final kDataBackDoc = "back_doc";
final kDataProductsQuantity = "products_quantity";
final kDataDeliveryGuyId = "delivery_guy_id";
final kDataVendorId = "vendor_id";
final kDataProductsList = "products_list";
final kDataTotalPaidAmount = "total paid amount";
final kDataDateOrdered = "date_ordered";
final kDataDeliveryStatus = "delivery_status";
final kDataSinglePrice = "single_price";
final kDataCustomerName = "customer_name";
final kDataCustomerAddress = "customer_address";
final kDataDeliveredAt= "delivered_at";
final kDataTrackStatus = "track_status";
final kDataAddresses = "addresses";
final kDataShippingAddress = "shipping_address";
final kDataCustomerFrontDoc = "customer_front_doc";
final kDataCustomerBackDoc = "customer_back_doc";
final kDataCustomerLatitude =  "customer_latitude";
final kDataCustomerLongitude = "customer_longitude";
final kDataCustomerPhone = "customer_phone";
final kDataAuthenticatedDocs = "authenticated_docs";
final kDataIsAuthenticateDocs = "is_authenticated_docs";
final kDataVerifyFrontDoc = "verify_front_doc";
final kDataVerifyBackDoc = "verify_back_doc";
final kDataTimeInterval = "time_interval";
final kDataMinutesLeft = "minutes_left";
final kDataTotalOrdersCount = "total_orders_count";
final kDataGroupName = "group_name";
final kDataGroupId = "group_id";
final kDataGroupDetails = "group_details";
final kDataGroupMembers = "group_members";
final kDataGroup = "group";
final kDataAdminId = "admin_id";
// final kDataServerContacts = "ServerContacts";
final kDataRemainingPhoneBookContacts = "remainingPhoneBookContacts";
final kDataIsAudio = "is_audio";
final kDataNonUsers ="non_users";
final kDataJwtToken = "jwt_token";
final kDataDatetime = "datetime";
final kDataTotalMembers = "total_members";
final kDataStartTime = "start_time";
final kDataEndTime = "end_time";
final kDataMeetingData = "meeting_data";
final kDataIsCall = "is_call";
final kDataMembers = "members";
final kDataMeetingId = "meeting_id";
final kDataFilePath = "file_path";
final kDataFileName = "file_name";
final kDataBgroups = "bgroups";
final kDataUpImage = "upimage";
final kDataStreet = "street";
final kDataCity = "city";
final kDataState = "state";
final kDataZipcode = "zipcode";
final kDataProductName = "p_name";
final kDataWholesalerName = "whl_name";
final kDataOutstanding = "outstanding";
final kDataPaid = "paid";
final kDataRoleId = "role_id";
final kDataRetailerName = "ret_name";
final kDataRetailerMobile = "ret_mobile";
final kDataTotalOutstanding = "total_outstanding";
final kDataOutstandingBal = "outstanding_bal";
final kDataOutstandingBalance = "outsatanding_balance";
final kDataLastTxn = "last_txn";
final kDataLastPayment = "last_payment";
final kDataInOut = "in_out";
final kDataWholesalerMobile = "whl_mobile";
final kDataZone = "zone";
final kDataDistrictName = "district_name";
final kDataRetailerData = "retailer_data";
final kDataWholesalerData = "whl_data";
final kDataPickupTime = "pickup_time";
final kDataProductDetails = "product_details";
final kDataWholesalerId = "whl_id";
final kDataRetailerId = "ret_id";
final kDataRetailerDetails = "retailer_details";
final kDataRetailerAddress = "ret_address";




final kDataItemOrder = "item_order";
int selectedIndex = -1;




/*

************************************Navigation Samples************************
Source: https://pub.dev/packages/page_transition


Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: DetailScreen()));

Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: DetailScreen()));

Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: DetailScreen()));

Navigator.push(context, PageTransition(type: PageTransitionType.upToDown, child: DetailScreen()));

Navigator.push(context, PageTransition(type: PageTransitionType.downToUp, child: DetailScreen()));

Navigator.push(context, PageTransition(type: PageTransitionType.scale, alignment: Alignment.bottomCenter, child: DetailScreen()));

Navigator.push(context, PageTransition(type: PageTransitionType.size, alignment: Alignment.bottomCenter, child: DetailScreen()));

Navigator.push(context, PageTransition(type: PageTransitionType.rotate, duration: Duration(second: 1), child: DetailScreen()));

Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: DetailScreen()));

Navigator.push(context, PageTransition(type: PageTransitionType.leftToRightWithFade, child: DetailScreen()));

*/
String shareSubject = "SHARE APP";
String shareText = "Plasma Donation\niOS Version: https://apps.apple.com/us/app/id12356789\nAndroid Version: https://play.google.com/store/apps/details?id=com.plasma.synergy&hl=en";

SetHomePage(int index, String screenName) async {
  dynamic user = await GetSharedPreference(kDataLoginUser);
  bool check = false;
  if (user != null) {
    check = user[kDataID].toString().length > 0 ? true : false;
    // globals.userType = user[kDataUserType];
    // getfirebaseSubscription(user[kDataResult]);
    globals.globalCurrentUser = user;
  }



  // Widget screen;
  // if (check ) {
  //   if (user[kDataRoleId] == "2") 
  //   {
  //     screen = CustomDrawerWholesaler(positionForDrawerWholesaler = screenName);
  //   }
  //   else if (user[kDataRoleId] == "4") 
  //   {
  //      screen = CustomDrawerDelivery(positionForDrawerDelivery = screenName); 
  //   } 
  //   else
  //   {
  //     screen = CustomDrawer(positionForDrawer = screenName);
  //   }

  //   // screen = CustomDrawerDelivery(positionForDrawerDelivery = screenName);
    
  // } 
  // else {
  //   screen = LoginWithOTP();
  // }
  runApp(MaterialApp(
      theme: ThemeData(
          tabBarTheme: TabBarTheme(
              labelColor: appThemeColor1, unselectedLabelColor: Colors.grey),
          fontFamily:'Archivo-Regular',
          buttonTheme: ButtonThemeData(
              buttonColor: appThemeColor1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              textTheme: ButtonTextTheme.accent,
              height: 50),
          appBarTheme: AppBarTheme(
              color: Colors.transparent,
              iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
              textTheme: TextTheme(
                bodyText1: TextStyle(fontSize: 18.0),
                bodyText2: TextStyle(fontSize: 18.0),
                headline1: TextStyle(fontSize: 18.0),
                headline2: TextStyle(fontSize: 18.0),
                headline3: TextStyle(fontSize: 18.0),
                headline4: TextStyle(fontSize: 18.0),
                headline5: TextStyle(fontSize: 18.0),
                headline6: TextStyle(fontSize: 25.0),
                subtitle1: TextStyle(fontSize: 25.0),
                subtitle2: TextStyle(fontSize: 25.0),
                caption: TextStyle(fontSize: 18.0),
                button: TextStyle(fontSize: 18.0),
                overline: TextStyle(fontSize: 18.0),

                  // title: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 25,
                  //     fontFamily: defaultFontFamilyForAppBar,
                  //     fontStyle: FontStyle.normal)
                      ))),
      home: LoginOptions()
      // home: JoinMeet()
      // home: (check && globals.numberOfChildren > 0) ?  CustomDrawer(positionForDrawer = screenName) : LoginOptions()
      ));
}

getfirebaseSubscription(Map user) async
{
  // String qvicUserId = "qvic~${user[kDataMobile].toString()}" ;       uncomment for firebase chat

  // final QuerySnapshot result =
  //         await Firestore.instance.collection('users').where('id', isEqualTo: qvicUserId).getDocuments();
  //     final List<DocumentSnapshot> documents = result.documents;
  //     if (documents.length == 0) {
  //       // Update data to server if new user
  //       Firestore.instance.collection('users').document(qvicUserId).setData({
  //         'nickname': user[kDataName],
  //         'photoUrl':user[kDataImage] ,
  //         // 'photoUrl':"" ,
  //         'id': qvicUserId,
  //         'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
  //         'chattingWith': null
  //       });       
  //     } 
  //     return documents;

}

// Future <DocumentSnapshot>getfirebaseUserDetails(Map user) async      uncomment for firebase chat
// {
  // String qvicUserId = "qvic~${user[kDataPhone].toString()}" ;
  // final QuerySnapshot result =
  //         await Firestore.instance.collection('users').where('id', isEqualTo: qvicUserId).getDocuments();
  //     final List<DocumentSnapshot> documents = result.documents;
  //     return documents[0];
// 
// }

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

/*
====================================================================================

Spin kit Source : https://flutterappdev.com/2019/01/29/a-collection-of-loading-indicators-animated-with-flutter/

====================================================================================
*/

void ShowLoader(BuildContext context) {
  SchedulerBinding.instance.addPostFrameCallback((_) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 50,
          child: AbsorbPointer(
            absorbing: true,
            // child: Image.asset("images/loader.gif"),
            child: SpinKitFadingGrid(
              itemBuilder: (_, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index.isEven ? appThemeColor1 : appThemeColor2,
                  ),
                );
              },
              // color: hexToColor(mustardColor),
              size: 50.0,
            ),
          ),
        );
      }));
}

checkValidEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return regex.hasMatch(value);
}

void HideLoader(BuildContext context) {
  Navigator.pop(context);
}

void ShowSuccessMessage(String message, BuildContext context) {
  SchedulerBinding.instance
      .addPostFrameCallback((_) => Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
            content: Text(
              message,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
            backgroundColor: Colors.green,
          )));
}

void ShowErrorMessage(String message, BuildContext context) {
  SchedulerBinding.instance
      .addPostFrameCallback((_) => Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
            content: Text(
              message,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
            backgroundColor: Colors.red,
          )));
}


 Future <bool>sharedPreferenceContainsKey(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
 bool result = prefs.containsKey(key);
 return result;
}


void SetSharedPreference(String key, dynamic value) async {
  var str = convert.json.encode(value);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  prefs.setString(key, str);
}

dynamic GetSharedPreference(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString(key) != null) {
    dynamic obj = convert.jsonDecode(prefs.getString(key));
    return obj;
  }
}

void RemoveSharedPreference(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

BoxDecoration SetBackgroundImage(String image) {
  return BoxDecoration(
    image: DecorationImage(
      image: AssetImage(image),
      fit: BoxFit.cover,
    ),
  );
}

// extension StringExtension on String {
//     String capitalize() {
//       return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
//     }
// }



BoxDecoration setBoxDecoration(Color color)
{
  return BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
          border: Border.all(color:appThemeColor1.withAlpha(50),width: 1),
          color: color,
           boxShadow: [
          // BoxShadow(
          // color: color.withAlpha(100),
          // offset: Offset(1, 2),
          // blurRadius: 1.5,
          // spreadRadius: 2
          // ),
          ]);
}


BoxDecoration setBoxDecorationForUpperCorners(Color color, Color shadowColor)
{
  return BoxDecoration(
          borderRadius: new BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
          color: color, boxShadow: [
          // BoxShadow(
          // color: shadowColor,
          // offset: Offset(1, 2),
          // blurRadius: 1.5,
          // spreadRadius: 2
          // ),
          ]
          );
}

InputDecoration setInputDecoration(
    String labelText,
    String hintText,
    Color fillColor,
    Color labelTextColor,
    Color borderColor,
    IconData prefix,
    FocusNode myFocusNode) {
  return InputDecoration(
    labelStyle: TextStyle(
        color:Colors.black
        ),
    fillColor: Colors.transparent,
    filled: true,
    errorStyle: TextStyle(color: Colors.black),
    labelText: labelText,
    hintText: hintText,
    prefixIcon: prefix == null
        ? null
        : Icon(
            prefix,
            color:appThemeColor1,
          ),
    focusColor: Colors.black,
    // enabledBorder: UnderlineInputBorder(
    // borderSide: BorderSide(color: Colors.red),
    // ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: appThemeColor1,width: 1),
    ),
  );
}


InputDecoration setInputDecorationForEdit(
    String labelText,
    String hintText,
    Color fillColor,
    Color labelTextColor,
    Color borderColor,
    IconData prefix,
    FocusNode myFocusNode) {
  return InputDecoration(
    labelStyle: TextStyle(
        color:myFocusNode.hasFocus?appThemeColor1:Colors.black,
        ),
    // fillColor: Colors.transparent,
    // filled: true,
    errorStyle: TextStyle(color: Colors.black),
    labelText: labelText,
    hintText: hintText,
    prefixIcon: prefix == null
        ? null
        : Icon(
            prefix,
            color:appThemeColor1,
          ),
    focusColor: myFocusNode.hasFocus?appThemeColor1:Colors.black,
    enabledBorder: OutlineInputBorder(
       borderSide: BorderSide(color: Colors.black45,width: 1),
          borderRadius: const BorderRadius.all(
            const Radius.circular(15.0),
            
          )
      ),
    disabledBorder: OutlineInputBorder(
       borderSide: BorderSide(color: Colors.black45,width: 1),
          borderRadius: const BorderRadius.all(
            const Radius.circular(15.0),
            
          )
      ),
    focusedBorder: OutlineInputBorder(
      
      borderSide: BorderSide(color: Colors.black45,width: 1),
      borderRadius: const BorderRadius.all(
            const Radius.circular(15.0),
            
          )
    ),
  );
}




setNavigationTransition(Widget targetWidget) {
  return PageTransition(
      duration: Duration(milliseconds: 500),
      type: PageTransitionType.leftToRightWithFade,
      child: targetWidget,
      alignment: Alignment.centerLeft);
}

setNavigationTransitionWithSettings(Widget targetWidget, String settingName) {
  return PageTransition(
      duration: Duration(milliseconds: 500),
      type: PageTransitionType.leftToRightWithFade,
      child: targetWidget,
      settings: RouteSettings(name: settingName));
}

LinearGradient setGradientColor() {
  return LinearGradient(
    // Where the linear gradient begins and ends
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    // Add one stop for each color. Stops should increase from 0 to 1
    stops: [0.1,0.4, 0.7, 0.9],
    colors: [
      // Colors are easy thanks to Flutter's Colors class.
      hexToColor("#031396"),
      hexToColor("#0627A6"),
      hexToColor("#0740B6"),
      hexToColor("#0965CC"),
    ],
  );
}

final Shader linearGradientForText = LinearGradient(
  colors: <Color>[
    hexToColor("#DC973D"),
    hexToColor("#CC8A33"),
    hexToColor("#AD6D23"),
    hexToColor("#975A19")
  ],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

LinearGradient setGradientColorHorizontalAxis() {
  return LinearGradient(
    // Where the linear gradient begins and ends
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    // Add one stop for each color. Stops should increase from 0 to 1
    stops: [0.1, 0.5, 0.7, 0.9],
    colors: [
      // Colors are easy thanks to Flutter's Colors class.
      hexToColor("#DC973D"),
      hexToColor("#CC8A33"),
      hexToColor("#AD6D23"),
      hexToColor("#975A19"),
    ],
  );
}
class customBottomNavigationBarExtension extends StatefulWidget {
  @override
  _customBottomNavigationBarExtensionState createState() =>
      _customBottomNavigationBarExtensionState();
}

class _customBottomNavigationBarExtensionState
    extends State<customBottomNavigationBarExtension> {


  @override
  Widget build(BuildContext context) {
    double myHeight =
        (MediaQuery.of(context).size.height * 15) / 120; //Your height HERE
    globals.bottomBarHeight = myHeight;
    return AbsorbPointer(
      absorbing: false,
          child: SizedBox(
        height: myHeight,
        width: MediaQuery.of(context).size.width,
        child: Container(
          decoration: new BoxDecoration(
            color: appThemeColor1,
            // borderRadius: new BorderRadius.only(
            //     topLeft: const Radius.circular(40.0),
            //     topRight: const Radius.circular(40.0)),
            // gradient: setGradientColor()
          ),

          // color: hexToColor(mustardColor),
          child: TabBar(
            tabs: [
              Tab(
                  icon: Icon(Icons.list,size: 25,),
                  text: "User List",
              ),
              Tab(
                   icon: Icon(Icons.edit),
                  text: "Edit Profile",),
            ],
            labelStyle: TextStyle(fontSize: 17.0),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.black,
            onTap: (value) {
              print("Pressed tab : $value");
               setState(() {
                selectedIndex = value;
              });
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              runApp(MaterialApp(
                  theme: ThemeData(
                      fontFamily: defaultFontFamily,
                      buttonTheme: ButtonThemeData(
                          buttonColor: Colors.yellow,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          textTheme: ButtonTextTheme.accent,
                          height: 50),
                      appBarTheme: AppBarTheme(
                        color: Colors.transparent,
                        // textTheme: TextTheme(title: TextStyle(color: Colors.white,
                        // fontSize: 22,
                        // fontStyle: FontStyle.normal,
                        // fontWeight: FontWeight.w400 ))
                      )),
                  home: tabBarNavigation(value)
                  // home: ScaffoldExtentionForWelcome()
                  ));
            },
          ),
        ),
      ),
    );
  }
}

Widget customBottomNavigationBar(BuildContext context, int index) 
{
  if(index != -1)
  {
    selectedIndex = index;
  }
  
  return customBottomNavigationBarExtension();
}

tabBarNavigation(int index) {
  
  switch (index) {
    case 0:
      {
        // return UsersListExtension();
        // return CustomDrawer();
      }
      break;
    case 1:
      { 
        // return EditProfile();
      }
      break;
  }
}

showCartButton(BuildContext context, )
{
  return Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
          child: GestureDetector(
            child: Stack(
                      children: <Widget>[
                        
                        new Icon(Icons.shopping_cart,size: 40,),
                        new Positioned(
                            top: 0.0,
                            right: 1.0,
                            child: Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: new BoxDecoration(
                                color: appThemeColor2,
                                shape: BoxShape.circle,
                              ),
                              child: new Center(
                                child: new Text(
                                  globals.cartCount.toString(),
                                  style: new TextStyle(
                                    // backgroundColor: Colors.black,
                                      color: Colors.white,
                                      fontSize: 10.0,
                                  ),
                                ),
                              ),
                            )),


                      ],
                    ),
            onTap: ()
            {
              //  Navigator.push(context, setNavigationTransition(Cart(isFromSideMenu = false,isFromSideMenuCart = 0, updateCartCountFromCommon)));
            },
            ),
        );
}

updateCartCountFromCommon()
{
  return globals.cartCount.toString();
}

// setBackgroundImage()
// {
//   return BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(appBackgroundImage),
//             fit: BoxFit.cover,
//           ),
//         );
// }
// emptyGlobals() {
//   globals.addOnCost = 0.00;
//   globals.cart = [];
//   globals.currentItemCost = 0.00;
//   globals.currentItemProcessing = {};
//   globals.flavourCost = 0.00;
//   globals.itemsDetailData = {};
//   globals.milkCost = 0.00;
//   globals.selectedAddOnList = [];
//   globals.selectedFlavourObject = {};
//   globals.selectedMilkObject = {};
//   globals.selectedMethodObject = {};
//   globals.selectedExtraObject = {};
//   globals.selectedTypeObject = {};
//   globals.selectedSize = {};
// }

launchURL(String contct) async {
  var url = "tel:+91$contct";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

launchEmail(String emaill) async 
{
  final Uri _emailLaunchUri = Uri(
  scheme: 'mailto',
  path: emaill,
  queryParameters: {
    'subject': 'Plasma Donation'
  }
  );
  launch(_emailLaunchUri.toString());
}



showAlert(BuildContext context, String message)
{

  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK",style: TextStyle(color: appThemeColor1),),
    onPressed: () 
    {
       Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("MEDIT",style: TextStyle(color: appThemeColor1),),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

 rotatePersonImage(BuildContext context,File image3) async {

  //  if (Platform.isIOS) 
  //  {
    //  final dir = await path_provider.getTemporaryDirectory();
    //   final targetPath = dir.absolute.path + "/"+basename(image3.path);
    //   image3 = await testCompressAndGetFile(image3, targetPath);
  //  }
    

    List<int> imageBytes1 = await image3.readAsBytes();

    final originalImage = img.decodeImage(imageBytes1);

    final exifData = await readExifFromBytes(imageBytes1);

    img.Image fixedImage;

    if (exifData['Image Orientation'].printable.contains('90 CW')) {
      fixedImage = img.copyRotate(originalImage, 90);
    } else if (exifData['Image Orientation']
        .printable
        .contains('90 CCW')) {
      fixedImage = img.copyRotate(originalImage, -90);
    } else {
      fixedImage = img.copyRotate(originalImage, 0);
    }

    final fixedFile = await image3.writeAsBytes(img.encodeJpg(fixedImage,quality: 90));
    final bytes = fixedFile.readAsBytesSync();
    String imageB642 = base64Encode(bytes);
    return imageB642;
  }

  Future<dynamic> compressImageFunction(File image) async
{
  if (image.path.contains(".JPG")||image.path.contains(".jpg")||image.path.contains(".jpeg")||image.path.contains(".JPEG")) 
    {
       final dir = await path_provider.getTemporaryDirectory();
       final targetPath = dir.absolute.path + "/"+basename(image.path);
       image = await testCompressAndGetFile(image, targetPath,false);
    }
    else if (image.path.contains(".PNG")||image.path.contains(".png"))
    {
       final dir = await path_provider.getTemporaryDirectory();
       final targetPath = dir.absolute.path + "/"+basename(image.path);
       image = await testCompressAndGetFile(image, targetPath,true);
    }
    return image ;
}

Future<File> testCompressAndGetFile(File file, String targetPath, bool isPNG) async {
    print("testCompressAndGetFile");
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: isPNG?70:90,
      minWidth: 1024,
      minHeight: 1024,
      rotate: 360,
      format: isPNG?CompressFormat.png:CompressFormat.jpeg

    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }


