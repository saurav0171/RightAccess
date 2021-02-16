import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:right_access/Globals/globals.dart';
import 'package:right_access/UI/inviteForm.dart';



Map contactObj = {};

class ContactList extends StatefulWidget {
  ContactList(param1);
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  void initState() {
    super.initState();

    if (contactList == null || contactList.length == 0) 
    {
       getContacts();
    }
  }

  getContacts() async
  {
    var status = await Permission.contacts.request();
    if (status.isGranted) 
    {
      try 
      {
         ShowLoader(context);
         Iterable phoneBook = await ContactsService.getContacts();  
          setState(() {
            contactList = [];
            for (var i = 0; i < phoneBook.length; i++) 
          {
            Contact contactObj = phoneBook.elementAt(i);
            List phone = contactObj.phones.toList();
            if(phone.length > 0)
            {
              for (var cont = 0; cont < phone.length; cont++) 
              {
                Item cnct = phone[cont];
                if (cnct.value.length > 0) 
                {
                   Map contact = {kDataMobile: cnct.value.toString(),kDataName: contactObj.displayName,kDataEmail: contactObj.emails.length > 0?contactObj.emails.toList()[0].value:""} ;
                   contactList.add(contact);
                }                
              }
            }
            
          }
          });
          HideLoader(context);

      } 
      catch (e) 
      {
        print("Errror : $e");
        HideLoader(context);
      }
    }
    else if (status.isDenied)
    {
      showAlert(context, "Please allow to access your phone book");
    }

    
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Stack(
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
            
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            leading: GestureDetector(
              onTap: ()
              {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back,)),
              title: Image.asset("images/logo.png",width: 200,),
            ),
             body:  Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ListView.separated(
        itemCount: contactList.length,
        padding: EdgeInsets.symmetric(horizontal: 0.0),
        itemBuilder: (BuildContext context, int index) {
          Map cntct = contactList[index];
          String name = cntct[kDataName];
          String description = "Mobile: ${cntct[kDataMobile]}";


          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  Container(
                    width: MediaQuery.of(context).size.width ,
                    child: Text(
                      name,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        description,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400),
                        maxLines: 10,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  Navigator.pop(context,contactList[index]);
                
                });
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Divider(
              color: Colors.black12,
              height: 2,
              thickness: 1,
            ),
          );
        },
      ),
    )),
        ],
      ),
    ); 
  }
}
