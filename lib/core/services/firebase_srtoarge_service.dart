// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path/path.dart' as path;
// import 'package:fruit_hub_dash_board/core/services/stoarge_service.dart';

// class FirebaseStorageService implements StorageService {
//   final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

//   @override
//   Future<String> uploadImage(String imagePath) async {
//     try {
//       // Create a file object from the path
//       final File imageFile = File(imagePath);

//       // Check if file exists
//       if (!await imageFile.exists()) {
//         throw Exception('Image file not found at path: $imagePath');
//       }

//       // Get the filename from the path
//       final String fileName = path.basename(imagePath);

//       // Create a unique filename with timestamp
//       final String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
//       final String uniqueFileName = '${timeStamp}_$fileName';

//       // Create reference to the file location in Firebase Storage
//       final Reference storageRef = _firebaseStorage
//           .ref()
//           .child('images/products/$uniqueFileName');

//       // Upload the file
//       final TaskSnapshot uploadTask = await storageRef.putFile(imageFile);

//       // Get the download URL
//       final String downloadUrl = await uploadTask.ref.getDownloadURL();

//       return downloadUrl;
//     } on FirebaseException catch (e) {
//       throw Exception('Firebase Storage Error: ${e.message}');
//     } catch (e) {
//       throw Exception('Error uploading image: $e');
//     }
//   }
// }
