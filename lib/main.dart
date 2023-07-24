import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
void main()
{
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: home(),

      routes:
      {
        '/new-contact': (context) =>Newcontact(),
      },
    );
  }
}



class Contact {


  final String id;
  final String name;

  Contact({required this.name,
  }):  id =  Uuid().v4();

}

// create a class in which we build singleton constructor(it is use bcz we use only single instance)

class ContactBook extends ValueNotifier<List<Contact>>
{
  ContactBook._sharedInstance(): super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook()=> _shared;

  // create a list for contact

 final List<Contact> _contacts = [];
 int get len => value.length;

 // create a method to contact
 void addContact({required Contact contact})
 {
   // value.add(contact);

   final contacts = value;
   contacts.add(contact);
   // value = contacts;
   notifyListeners();
 }
 // create a method to remove contact
void removeContact({required Contact contact})
{
  final contacts = value;
 if(contacts.contains(contact))
   {
     contacts.remove(contact);
     notifyListeners();
   }
}
/* create a method to retrieve contact with index && it is the optional
 Contact (it return the contact if the contact index in range)*/
Contact? contact({required int atIndex})=> _contacts.length > atIndex ? _contacts[atIndex] : null;



}




class home extends StatelessWidget {
  const home({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: Text('Contact'),),
      body:ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder: (context, value, child){
          final contacts = value as List<Contact>;
          return  ListView.builder(

            itemCount: contacts.length,
            itemBuilder: (context, index) {

              final contact = contacts[index];
              return Dismissible(
                onDismissed: (direction) {

                  // contacts.remove(contact);
                ContactBook().removeContact(contact: contact);

                }
                ,
                key: ValueKey(contact.id),
                child: Material(

                  color: Colors.white,
                  elevation: 6,
                  child: ListTile(
                    title: Text(contact.name),

                  ),
                ),
              );
            },);
        },

      ),
      floatingActionButton: FloatingActionButton(

        onPressed: () async{
          await Navigator.of(context).pushNamed('/new-contact');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
class Newcontact extends StatefulWidget {
  const Newcontact({super.key});

  @override
  State<Newcontact> createState() => _NewcontactState();
}

class _NewcontactState extends State<Newcontact> {

  late final TextEditingController con;

  @override
  void initState()
  {
    con = TextEditingController();
    super.initState();
  }
  @override
  void dispose()
  {
    con.dispose();
    super.dispose();
  }
  @override
  void didUpdateWidget( covariant Newcontact oldWidget)
  {
    super.didUpdateWidget(oldWidget);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Contact'),),

body: Column(
  children: [

    TextFormField(
      controller: con,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
      ),
    ),
    SizedBox(height: 10,),

    TextButton(onPressed: (){
      final contact =  Contact(name: con.text);
      ContactBook().addContact(contact: contact);
      Navigator.of(context).pop();

    }, child: Text('Add New')),
  ],
),    );
  }
}
