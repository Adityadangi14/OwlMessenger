import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class Encryption{
  var cryptor = new PlatformStringCryptor();

  String key;

  getKey()async{
     key =await  cryptor.generateSalt();
  }

 encryptedString (String message)async{
   
    String encryptedString = await cryptor.encrypt(message, key);
    return encryptedString;
  }

  decryptedString(String encryptedString) async{

    try{
    String decryptedString = await cryptor.decrypt(encryptedString, key);
    return decryptedString;
    }
    on MacMismatchException{
      return encryptedString;
    }
  }
}