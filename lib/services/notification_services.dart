import 'dart:convert';
import 'dart:io';

import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/base_response_model.dart';
import 'package:booking_system_flutter/model/firebase_details_model.dart';
import 'package:booking_system_flutter/network/network_utils.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../model/user_data_model.dart';

class NotificationService {
  Future<void> sendPushNotifications(String title, String content, {String? image, required UserData receiverUser, required UserData senderUserData}) async {

    // todo : remove this
   /* Map<String, dynamic> data = {
      "created_at": senderUserData.createdAt,
      "email": senderUserData.email,
      "first_name": senderUserData.firstName,
      "id": senderUserData.id.toString(),
      "last_name": senderUserData.lastName,
      "updated_at": senderUserData.updatedAt,
      "profile_image": senderUserData.profileImage,
      "uid": senderUserData.uid,
    };
    data.putIfAbsent("is_chat", () => "1");
    if (image != null && image.isNotEmpty) data.putIfAbsent("image_url", () => image.validate());

    Map req = {
      "message": {
        "topic": "user_${receiverUser.id.validate()}",
        "notification": {
          "body": content,
          "title": "$title ${language.sentYouAMessage}",
          "image": image.validate(),
        },
        "data": data,
      }
    };

    log("Send Notification request: ${req}");*/

    /*/// NEW
    // Notification Api call
    await sendPushNotification(request: req).catchError((e) {
      toast(e.toString(), print: true);
      return e;
    });

    /// END*/

     await getFirebaseTokenAndId().then((value) async {
      if (value.data != null) {
        Map<String, dynamic> data = {
          "created_at": senderUserData.createdAt,
          "email": senderUserData.email,
          "first_name": senderUserData.firstName,
          "id": senderUserData.id.toString(),
          "last_name": senderUserData.lastName,
          "updated_at": senderUserData.updatedAt,
          "profile_image": senderUserData.profileImage,
          "uid": senderUserData.uid,
        };
        data.putIfAbsent("is_chat", () => "1");
        if (image != null && image.isNotEmpty) data.putIfAbsent("image_url", () => image.validate());

        Map req = {
          "message": {
            "topic": "user_${receiverUser.id.validate()}",
            "notification": {
              "body": content,
              "title": "$title ${language.sentYouAMessage}",
              "image": image.validate(),
            },
            "data": data,
          }
        };

         var header = {
          HttpHeaders.authorizationHeader: 'Bearer ${value.data!.firebaseToken}',
          HttpHeaders.contentTypeHeader: 'application/json',
        };
        log("Send Notification request: ${req}");

        Response res = await post(
          Uri.parse('https://fcm.googleapis.com/v1/projects/${value.data!.projectName}/messages:send'),
          body: jsonEncode(req),
          headers: header,
        );

        log(res.statusCode);
        log(res.body);

        if (res.statusCode.isSuccessful()) {
        } else {
          throw errorSomethingWentWrong;
        }
      }
    }).catchError((e) {
      toast(e.toString());
    });
  }

  Future<FirebaseDetailsModel> getFirebaseTokenAndId({Map? request}) async {
    return FirebaseDetailsModel.fromJson(await handleResponse(await buildHttpResponse('firebase-detail', request: request, method: HttpMethodType.POST)));
  }
}
