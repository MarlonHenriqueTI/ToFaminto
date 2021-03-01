class OrderMessage {
  final int id;
  final String content;
  final String date;

  /// true if message has sent by user
  final bool isUser;

  OrderMessage({this.id, this.content, this.date, this.isUser});

  factory OrderMessage.fromJson(Map<String, dynamic> json) {
    return OrderMessage(
      id: json['id'] ?? -1,
      content: json['content'] ?? '',
      date: json['date'] ?? '',
      isUser: json['isUser'] == 1,
    );
  }
}
