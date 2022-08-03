class MessageModel {
  String? senderId;
  String? receiverId;
  String? dateTime;
  String? messageText;


  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.dateTime,
    required this.messageText,
  });

  MessageModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      senderId = json['senderId'];
      receiverId = json['receiverId'];
      dateTime = json['dateTime'];
      messageText = json['messageText'];

    }
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'dateTime': dateTime,
      'messageText': messageText,
    };
  }
}
