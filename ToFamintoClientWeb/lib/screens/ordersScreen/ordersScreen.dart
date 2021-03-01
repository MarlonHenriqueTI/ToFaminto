import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/constants/enums.dart';
import 'package:to_faminto_client/constants/phrases_constants.dart';
import 'package:to_faminto_client/models/api_error.dart';
import 'package:to_faminto_client/models/order.dart';
import 'package:to_faminto_client/models/order_message.dart';
import 'package:to_faminto_client/providers/routes_state.dart';
import 'package:to_faminto_client/screens/components/top_notch.dart';
import 'package:to_faminto_client/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:to_faminto_client/services/notifications.dart';

import 'components/order_container.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _apiService = ApiService();
  Future<dynamic> futureOrders;
  bool _isChat = false;
  Order _order;

  void openChat(Order order) {
    _order = order;
    setState(() {
      _isChat = true;
    });
  }

  @override
  void initState() {
    futureOrders = _apiService.orders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopNotch(
          PhrasesConstants.MY_ORDERS_TOP_NOTCH,
          applyMargin: false,
          margin: const EdgeInsets.only(bottom: 10),
        ),
        _isChat
            ? Expanded(child: Chat(_order))
            : FutureBuilder<dynamic>(
                future: futureOrders,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data is ApiError) {
                      final ApiError apiError = snapshot.data;
                      return Expanded(
                        child: Center(
                          child: Text(apiError.text),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return OrderContainer(
                                openChat: (order) => openChat(order),
                                order: snapshot.data[index],
                                index: index,
                              );
                            },
                          ),
                        ),
                      );
                    }
                  }
                  return Expanded(
                      child: Center(child: CircularProgressIndicator()));
                },
              ),
      ],
    );
  }
}

class Chat extends StatefulWidget {
  final Order order;
  Chat(this.order);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _apiService = ApiService();
  List<MessageContainer> messages = [];
  final _controller = TextEditingController();
  bool _hasLoadedMessages = false;
  final _messaging = Messaging.instance;

  void loadMessages() async {
    messages = [];
    final response = await _apiService.getOrderMessages(widget.order.uniqueId);
    if (response is ApiError || response == null) {
    } else {
      for (final message in response as List<OrderMessage>) {
        messages.add(MessageContainer(message));
      }
      setState(() {});
    }
    _hasLoadedMessages = true;
  }

  void sendMessage() async {
    final lastMessageIndex = messages.length - 1;
    final message = _controller.text;
    _controller.clear();
    if (message.length < 1 || message.length > 200) return;
    setState(() {
      messages.add(
        MessageContainer(
          OrderMessage(
            id: messages.isEmpty ? 0 : messages.last.message.id,
            content: message,
            date: DateFormat("HH:mm").format(DateTime.now()),
            isUser: true,
          ),
        ),
      );
    });
    final response =
        await _apiService.sendMessage(message, widget.order.uniqueId);
    if (response is ApiError || response == null) {
      setState(() {
        messages.removeAt(lastMessageIndex);
      });
    }
  }

  void addMessage(Map<String, dynamic> message) async {
    if (mounted) {
      if (Provider.of<RoutesState>(context, listen: false).currentRoute ==
          NavigationRoute.ORDERS) {
        if (message.containsKey('message')) {
          setState(() {
            messages.add(
              MessageContainer(
                OrderMessage(
                  id: messages.isEmpty ? 0 : messages.last.message.id,
                  content: message['message'],
                  date: message['date'],
                  isUser: false,
                ),
              ),
            );
          });
        }
      }
    }
  }

  @override
  void initState() {
    loadMessages();
    _messaging.stream.listen(
      (event) {
        addMessage(event);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _hasLoadedMessages
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.order.restaurantName,
                style: AppStyle.greyRegularText16Style(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: messages,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        style: AppStyle.mediumGreyMediumText16Style(),
                        cursorColor: AppStyle.yellow,
                        autofocus: true,
                        maxLines: 10,
                        minLines: 1,
                        controller: _controller,
                        autocorrect: true,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          fillColor: Colors.white,
                          labelStyle: AppStyle.mediumGreyMediumText16Style(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppStyle.yellow,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppStyle.yellow,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppStyle.yellow,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: sendMessage,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 11, 10, 11),
                      margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: AppStyle.yellow),
                      ),
                      child: Icon(
                        Icons.done,
                        color: AppStyle.yellow,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}

class MessageContainer extends StatelessWidget {
  final OrderMessage message;

  const MessageContainer(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(10),
            bottomRight: const Radius.circular(10),
            topRight: message.isUser ? Radius.zero : const Radius.circular(10),
            topLeft: message.isUser ? const Radius.circular(10) : Radius.zero,
          ),
          border: Border.all(color: AppStyle.yellow),
        ),
        child: Column(
          crossAxisAlignment: message.isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.date,
              style: AppStyle.greyRegularText14Style(),
            ),
            Text(
              message.content,
              style: AppStyle.greyRegularText16Style(),
            ),
          ],
        ),
      ),
    );
  }
}
