abstract class ToFamintoRoutePath {}

class LoginRegisterPath extends ToFamintoRoutePath {}

class HomePath extends ToFamintoRoutePath {}

class RestaurantPath extends ToFamintoRoutePath {
  final String slug;

  RestaurantPath(this.slug);
}

class ItemPath extends ToFamintoRoutePath {
  final String slug;
  final int id;

  ItemPath({this.slug, this.id});
}

class CheckoutPath extends ToFamintoRoutePath {}

class CheckoutNewCardPath extends ToFamintoRoutePath {}

class OrdersPath extends ToFamintoRoutePath {}

class CartPath extends ToFamintoRoutePath {}

class DefinitionsPath extends ToFamintoRoutePath {}

class ProfilePath extends ToFamintoRoutePath {}

class AddressesPath extends ToFamintoRoutePath {}

class NewAddressesPath extends ToFamintoRoutePath {}

class CardsPath extends ToFamintoRoutePath {}

class NewCardPath extends ToFamintoRoutePath {}

class FilterPath extends ToFamintoRoutePath {}

class WalletPath extends ToFamintoRoutePath {}
