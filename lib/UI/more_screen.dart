import 'dart:io';
import 'dart:ui';
import 'dart:isolate';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:googleapis/chat/v1.dart';
import 'package:intl/intl.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:http/http.dart' as http;
import 'package:right_access/Globals/globals.dart';
import 'package:right_access/GoogleCalendar/CalenderClient.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:right_access/ServerFiles/serviceAPI.dart';
import 'package:right_access/UI/support.dart';
import 'package:smiley_rating_dialog/smiley_rating_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';


List notificationsList = [];
List days = [];
List daysDate = [];
String daysString = "";
const debug = true;
String sponsorDisplayName ="";
class MoreScreen extends StatelessWidget {
  var aboutData; bool isRegister; bool isPast;

  MoreScreen({Key key, this.aboutData, this.isRegister, this.isPast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
    child:Stack(
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
            body: MoreScreenExtension(aboutData:  this.aboutData,isRegister: this.isRegister,isPast: this.isPast,)),
      ],
    ),);
  }
}


class MoreScreenExtension extends StatefulWidget {
  var aboutData; bool isRegister; bool isPast;
  MoreScreenExtension({Key key, this.aboutData,this.isRegister, this.isPast}) : super(key: key);
  @override
  _MoreScreenExtensionState createState() => _MoreScreenExtensionState();
}

class _MoreScreenExtensionState extends State<MoreScreenExtension> {

   List<_TaskInfo> _tasks;
  List<_ItemHolder> _items;
  bool _isLoading;
  bool _permissionReady;
  String _localPath;
  ReceivePort _port = ReceivePort();

  var format = DateFormat("yyyy-MM-dd HH:mm:ss");
  Map resultData = {};


  final _documents = [
   
  ];

  var _images = [  ];

  final _videos = [
 
  ];
  @override
  void initState() {
    super.initState();
    resultData = widget.aboutData;
    notificationContext = context;
    // ShowLoader(context);
    // fetchNotification();
    _images = [
    {
      'name': resultData[kDataTitle],
      'link':resultData[kDataResource]
      // 'link':(widget.isRegister && !widget.isPast)?resultData[kDataResource]:resultData[kDataEventPreStage][kDataData][kDataResource]
    },
  ];
    if (!widget.isRegister) 
    {
      getDaysInBeteween(format.parse(widget.aboutData[kDataStartDateTime]), format.parse(widget.aboutData[kDataEndDateTime]));
    }
    else if(widget.isRegister && !widget.isPast)
    {
      getDaysInBeteween(format.parse(widget.aboutData[kDataEvent][kDataData][kDataStartDateTime]), format.parse(widget.aboutData[kDataEvent][kDataData][kDataEndDateTime]));
    }
    if(!widget.isRegister)
    {
      if (widget.aboutData.containsKey(kDataSponserDisplayName) ) 
          {
            sponsorDisplayName = (widget.aboutData[kDataSponserDisplayName] !=null && widget.aboutData[kDataSponserDisplayName].length >0)?widget.aboutData[kDataSponserDisplayName]:"Sponsors";
          }
          else
          {
            sponsorDisplayName = "Sponsors";
          }
    }
    else
    {
      if (widget.aboutData[kDataEvent][kDataData].containsKey(kDataSponserDisplayName) ) 
          {
            sponsorDisplayName = (widget.aboutData[kDataEvent][kDataData][kDataSponserDisplayName] != null && widget.aboutData[kDataEvent][kDataData][kDataSponserDisplayName].length>0)?widget.aboutData[kDataEvent][kDataData][kDataSponserDisplayName]:"Sponsors";
          }
          else
          {
            sponsorDisplayName = "Sponsors";
          }
    }
 
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _isLoading = true;
    _permissionReady = false;
    _prepare();
  }

 

 

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (_tasks != null && _tasks.isNotEmpty) {
        final task = _tasks.firstWhere((task) => task.taskId == id);
        if (task != null) {
          setState(() {
            task.status = status;
            task.progress = progress;
          });
        }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }
////////////////// Downloader//////////////////////


Widget _buildDownloadList() => Container(
  height: 80,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          children: _items
              .map((item) => item.task == null
                  ? _buildListSection(item.name)
                  : Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: DownloadItem(
                        data: item,
                        onItemClick: (task) {
                          _openDownloadedFile(task).then((success) {
                            if (!success) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Cannot open this file')));
                            }
                          });
                        },
                        onAtionClick: (task) {
                          if (task.status == DownloadTaskStatus.undefined) {
                            _requestDownload(task);
                          } else if (task.status == DownloadTaskStatus.running) {
                            _pauseDownload(task);
                          } else if (task.status == DownloadTaskStatus.paused) {
                            _resumeDownload(task);
                          } else if (task.status == DownloadTaskStatus.complete) {
                            _delete(task);
                          } else if (task.status == DownloadTaskStatus.failed) {
                            _retryDownload(task);
                          }
                        },
                      ),
                  ))
              .toList(),
        ),
      );

  Widget _buildListSection(String title) => Container(
    height: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 18.0),
        ),
      );

  Widget _buildNoPermissionWarning() => Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Please grant accessing storage permission to continue -_-',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),
                ),
              ),
              SizedBox(
                height: 32.0,
              ),
              FlatButton(
                  onPressed: () {
                    _checkPermission().then((hasGranted) {
                      setState(() {
                        _permissionReady = hasGranted;
                      });
                    });
                  },
                  child: Text(
                    'Retry',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ))
            ],
          ),
        ),
      );

  void _requestDownload(_TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
  }

  void _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  void _resumeDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(_TaskInfo task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  void _delete(_TaskInfo task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: true);
    await _prepare();
    setState(() {});
  }

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<Null> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = [];
    _items = [];

    // _tasks.addAll(_documents.map((document) =>
    //     _TaskInfo(name: document['name'], link: document['link'])));

    // _items.add(_ItemHolder(name: 'Documents'));
    // for (int i = count; i < _tasks.length; i++) {
    //   _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
    //   count++;
    // }

    _tasks.addAll(_images
        .map((image) => _TaskInfo(name: image['name'], link: image['link'])));

    _items.add(_ItemHolder(name: ''));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }

    // _tasks.addAll(_videos
    //     .map((video) => _TaskInfo(name: video['name'], link: video['link'])));

    // _items.add(_ItemHolder(name: 'Videos'));
    // for (int i = count; i < _tasks.length; i++) {
    //   _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
    //   count++;
    // }

    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });

    _permissionReady = await _checkPermission();

    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  ////////////////// Downloader//////////////////////

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Event Name: ${widget.aboutData[kDataTitle]}',
        text: 'Event description: ${widget.aboutData[kDataShortDescription]}',
        linkUrl: widget.isRegister?widget.aboutData[kDataEvent][kDataData][kDataLink]:widget.aboutData[kDataLink],
        chooserTitle: 'Chooser To Share');
  }

  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = widget.isRegister?'https://maps.google.it/maps?q=${widget.aboutData[kDataEvent][kDataData][kDataMainVenue]}':'https://maps.google.it/maps?q=${widget.aboutData[kDataMainVenue]}';
    // String googleUrl = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/output?input=Museum%20of%20Contemporary%20Art%20Australia&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyDnVva-Y9LHB7O8wNVC95nx0iAs4rqE7YA';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

CalendarClient calendarClient = CalendarClient();
  addToCalendar()
  {
    if (!widget.isRegister) 
    {
     var result =  calendarClient.insert(
                  resultData[kDataTitle],
                  format.parse(resultData[kDataStartDateTime]),
                  format.parse(resultData[kDataEndDateTime]),
                ); 
     print("status = $result");
    }
    else if(widget.isRegister && !widget.isPast)
    {
     var result =  calendarClient.insert(
                  resultData[kDataTitle],
                  format.parse(resultData[kDataEvent][kDataData][kDataStartDateTime]),
                  format.parse(resultData[kDataEvent][kDataData][kDataEndDateTime]),
                ); 
     print("status = $result");
    }
    
                
  }

  List getDaysInBeteween(DateTime startDate, DateTime endDate) {
    
    daysString="";
    days = [];
    daysDate = [];
    int dayCount = endDate.difference(startDate).inDays;
    if (dayCount<6) 
    {
      for (int i = 0; i <= dayCount; i++)
      {
        days.add(format.format(startDate.add(Duration(days: i))).split(" ")[0]);
        daysDate.add(startDate.add(Duration(days: i)));
        daysString = "$daysString     ${format.format(startDate.add(Duration(days: i))).split(" ")[0]}";
      }
      daysString = daysString.substring(5);
    }
    else
    {
      daysString = "${DateFormat("yyyy-dd-MM").format(startDate)}     to     ${DateFormat("yyyy-dd-MM").format(endDate)}";
    }
    
    return days;
  }
 
 feedback(int rating) async {
    final url = "$baseUrl/feedbacks";

    var param = {};
    param["event_id"] = widget.isRegister?resultData[kDataEventId].toString():resultData[kDataID].toString();
    param["rating"] = rating.toString();
    param["message"] = "message";

    var result = await CallApi("POST", param, url);
    HideLoader(context);
    Navigator.pop(context);
    if (result[kDataCode] == "200") {
      showAlertDialog(result[kDataMessage], context);
    } else if (result[kDataCode] == "401" ||
        result[kDataCode] == "404" ||
        result[kDataCode] == "422") {
      showAlertDialog(result[kDataMessage], context);
    } else {
      showAlertDialog(result[kDataError], context);
    }
  }

_TaskInfo _task;
  @override
  Widget build(BuildContext context) {
    
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          height: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      //saurabh
                      !widget.isRegister? Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            trailing: IconButton(
                              onPressed: () {},
                              icon: new Stack(
                                children: <Widget>[
                                  new Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                            leading: IconButton(
                              icon: new Stack(
                                children: <Widget>[
                                  new Icon(
                                    Icons.error_outline,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "About",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Container(child: Html(
                                    data:resultData["long_description"],

                                  ),),
                                ),
                              )
                            ],
                          )):Container(),
                      !widget.isRegister? Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          height: 0.5,
                          color: Colors.grey,
                        ),
                      ):Container(),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(0)),
                        child: ListTile(
                          onTap: () {
                            share();
                          },
                          leading: IconButton(
                            onPressed: () {
                              share();
                            },
                            icon: new Stack(
                              children: <Widget>[
                                new Icon(
                                  Icons.share,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                          title: Text(
                            "Share",
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: IconButton(
                            icon: new Stack(
                              children: <Widget>[
                                new Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          height: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      widget.isRegister && !widget.isPast? Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(0)),
                        child: ExpansionTile(
                          leading: IconButton(
                            icon: new Stack(
                              children: <Widget>[
                                new Icon(
                                  Icons.download_sharp,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                          title: Text(
                            "Download",
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: IconButton(
                            icon: new Stack(
                              children: <Widget>[
                                new Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                          children: [

                            Builder(
                                builder: (context) => _isLoading
                                    ? new Center(
                                  child: new CircularProgressIndicator(),
                                )
                                    : _permissionReady
                                    ? _buildDownloadList()
                                    : _buildNoPermissionWarning()),

                          ],
                        ),
                      ):Container(),
                      widget.isRegister && !widget.isPast? Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          height: 0.5,
                          color: Colors.grey,
                        ),
                      ):Container(),
                      !widget.isPast?Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            trailing: IconButton(
                              icon: new Stack(
                                children: <Widget>[
                                  new Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                            leading: IconButton(
                              icon: new Stack(
                                children: <Widget>[
                                  new Icon(
                                    Icons.calendar_today,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Event Schedule",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  child: Text(daysString, style: TextStyle(color:Colors.black54,fontSize: 15),textAlign: TextAlign.center,),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                                child: Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.grey,
                                  child: FlatButton(onPressed: ()
                                  {
                                    addToCalendar();
                                  }, child: Text(
                                    "Add to Calendar",
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              )

                            ],
                          )
                      ):Container(),
                      !widget.isPast?Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          height: 0.5,
                          color: Colors.grey,
                        ),
                      ):Container(),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(0)),
                        child: ListTile(
                          onTap: () {
                            openMap(30.9010, 75.8573);
                          },
                          leading: IconButton(
                            icon: new Stack(
                              children: <Widget>[
                                new Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                          title: Text(
                            "Location/Direction",
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: IconButton(
                            icon: new Stack(
                              children: <Widget>[
                                new Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          height: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(0)),
                        child: ExpansionTile(
                          leading: IconButton(
                            icon: new Stack(
                              children: <Widget>[
                                new Icon(
                                  Icons.sports,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                          title: Text(
                            sponsorDisplayName,
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: IconButton(
                            icon: new Stack(
                              children: <Widget>[
                                new Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                          children: [

                            resultData[kDataEventSponsors][kDataData].length > 0? Container(
                              color: Colors.white,
                              height: 200,
                              child: PageIndicatorContainer(
                                  child: PageView.builder(
                                    itemCount: resultData[kDataEventSponsors][kDataData].length,
                                    itemBuilder: (BuildContext context, int index) {
                                      String image = resultData[kDataEventSponsors][kDataData][index][kDataImage] != null?resultData[kDataEventSponsors][kDataData][index][kDataImage]:"";
                                      // return Image.network(image,
                                      //     fit: BoxFit.contain);
                                      return Padding(
                                        padding: const EdgeInsets.all(20),
                                        child:  CachedNetworkImage(
                                          height: 250,
                                          fit: BoxFit.fitWidth,
                                          imageUrl: image,
                                          placeholder: (context, url) => Container(
                                            child: Center(
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                )),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Center(child: Icon(Icons.error)),
                                        ),
                                      );
                                    },
                                  ),
                                  align: IndicatorAlign.bottom,
                                  length: resultData[kDataEventSponsors][kDataData].length,
                                  indicatorSpace: 5.0,
                                  padding: const EdgeInsets.all(5),
                                  indicatorColor: Colors.grey.shade300,
                                  indicatorSelectorColor: appThemeColor1,
                                  shape: IndicatorShape.circle(size: 10)),
                            ):Center(child: Text(
                              "No Sponsors available",
                              style: TextStyle(color: Colors.grey),
                            ),),

                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          height: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(0)),
                          child: ListTile(
                            leading: IconButton(
                              icon: new Stack(
                                children: <Widget>[
                                  new Icon(
                                    Icons.headset_mic_sharp,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                            title: Text(
                              "Help",
                              style: TextStyle(color: Colors.black),
                            ),
                            trailing: IconButton(
                              icon: new Stack(
                                children: <Widget>[
                                  new Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: ()
                        {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => SupportPage(supportData = widget.aboutData),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          height: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      (widget.isRegister && widget.isPast)|| !widget.isRegister? GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(0)),
                          child: ListTile(
                            leading: IconButton(
                              icon: new Stack(
                                children: <Widget>[
                                  new Icon(
                                    Icons.feedback,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                            title: Text(
                              "Feedback",
                              style: TextStyle(color: Colors.black),
                            ),
                            trailing: IconButton(
                              icon: new Stack(
                                children: <Widget>[
                                  new Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: ()
                        {
                          showDialog(
                              barrierDismissible: true,
                              context: context, builder: (BuildContext context)
                          {
                            return SmileyRatingDialog(
                              title: Center(child: Text(resultData[kDataTitle],style: TextStyle(fontSize: 18),textAlign: TextAlign.left,)),
                              starColor: appThemeColor1,
                              isRoundedButtons: true,
                              positiveButtonText: 'Ok',
                              negativeButtonText: 'Cancel',
                              positiveButtonColor: appThemeColor1,
                              negativeButtonColor: appThemeColor1,
                              onCancelPressed: () => Navigator.pop(context),
                              onSubmitPressed: (rating) {
                                ShowLoader(context);
                                feedback(rating);
                              },
                            );
                          });
                        },
                      ):Container(),
                      (widget.isRegister && widget.isPast)|| !widget.isRegister? Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          height: 0.5,
                          color: Colors.grey,
                        ),
                      ):Container(),
                      (widget.isRegister && !widget.isPast) ||
                          !widget.isRegister? Container(
                        height: 60,
                      ):Container()
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}














class DownloadItem extends StatelessWidget {
  final _ItemHolder data;
  final Function(_TaskInfo) onItemClick;
  final Function(_TaskInfo) onAtionClick;

  DownloadItem({this.data, this.onItemClick, this.onAtionClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
      child: InkWell(
        onTap: data.task.status == DownloadTaskStatus.complete
            ? () {
                onItemClick(data.task);
              }
            : null,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 64.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      data.name,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: _buildActionForTask(data.task),
                  ),
                ],
              ),
            ),
            data.task.status == DownloadTaskStatus.running ||
                    data.task.status == DownloadTaskStatus.paused
                ? Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: LinearProgressIndicator(
                      value: data.task.progress / 100,
                    ),
                  )
                : Container()
          ].where((child) => child != null).toList(),
        ),
      ),
    );
  }

  Widget _buildActionForTask(_TaskInfo task) {
    if (task.status == DownloadTaskStatus.undefined) {
      return RawMaterialButton(
        onPressed: () {
          onAtionClick(task);
        },
        child: Icon(Icons.file_download),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return RawMaterialButton(
        onPressed: () {
          onAtionClick(task);
        },
        child: Icon(
          Icons.pause,
          color: Colors.red,
        ),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return RawMaterialButton(
        onPressed: () {
          onAtionClick(task);
        },
        child: Icon(
          Icons.play_arrow,
          color: Colors.green,
        ),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Ready',
            style: TextStyle(color: Colors.green),
          ),
          RawMaterialButton(
            onPressed: () {
              onAtionClick(task);
            },
            child: Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            shape: CircleBorder(),
            constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return Text('Canceled', style: TextStyle(color: Colors.red));
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Failed', style: TextStyle(color: Colors.red)),
          RawMaterialButton(
            onPressed: () {
              onAtionClick(task);
            },
            child: Icon(
              Icons.refresh,
              color: Colors.green,
            ),
            shape: CircleBorder(),
            constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.enqueued) {
      return Text('Pending', style: TextStyle(color: Colors.orange));
    } else {
      return null;
    }
  }
}

class _TaskInfo {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}

class _ItemHolder {
  final String name;
  final _TaskInfo task;

  _ItemHolder({this.name, this.task});
}
