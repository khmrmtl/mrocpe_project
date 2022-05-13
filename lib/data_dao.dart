import 'package:firebase_database/firebase_database.dart';
import 'package:mrocpe_project/data_model.dart';

class MessageDao {
  // final DatabaseReference _messagesRef =
  //     FirebaseDatabase.instance.reference().child('messages');
  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.ref("project");

  // void saveMessage(Data message) {
  //   _messagesRef.push().set(message.toJson());
  // }

  Stream<DatabaseEvent> getData() {
    return _messagesRef.onValue;
  }
}
