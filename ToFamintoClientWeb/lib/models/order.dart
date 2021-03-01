import 'order_item.dart';

class Order {
  final String uniqueId;
  final String price;
  final String restaurantName;
  final String restaurantLogo;
  final String status;
  final int statusId;
  final String createdAt;
  final List<OrderItem> items;

  const Order({
    this.uniqueId,
    this.price,
    this.restaurantName,
    this.restaurantLogo,
    this.status,
    this.statusId,
    this.createdAt,
    this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<OrderItem> _items = [];

    for (final item in json['items']) {
      _items.add(OrderItem.fromOrderJson(item));
    }

    String _status;

    switch (json['statusId']) {
      case 1:
        {
          _status = "Aguardando Aceitação";
        }
        break;
      case 2:
        {
          _status = "Sendo Preparado";
        }
        break;
      case 3:
        {
          _status = "Sendo Preparado";
        }
        break;
      case 4:
        {
          _status = "A Caminho";
        }
        break;
      case 5:
        {
          _status = "Entregue";
        }
        break;
      case 6:
        {
          _status = "Cancelado";
        }
        break;
      case 7:
        {
          _status = "Pronto para retirada";
        }
        break;
      default:
        {
          _status = "";
        }
        break;
    }

    final String fullDate = json['createdAt'];
    final String day = fullDate.substring(8, 10);
    final String month = fullDate.substring(5, 7);
    final String year = fullDate.substring(0, 4);

    String toFamintoUrl;
    final String restaurantLogoUrl = json['restaurantLogo'];
    if (restaurantLogoUrl == null) {
      toFamintoUrl = null;
    } else {
      toFamintoUrl = "https://www.tofaminto.com$restaurantLogoUrl";
    }

    return Order(
      uniqueId: json['uniqueId'],
      price: json['payable'],
      status: _status,
      statusId: json['statusId'],
      restaurantLogo: toFamintoUrl,
      restaurantName: json['restaurantName'] ?? "",
      createdAt: "$day/$month/$year",
      items: _items,
    );
  }
}
