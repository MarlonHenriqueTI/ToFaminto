import 'package:flutter/material.dart';

import 'routes.dart';

class ToFamintoRouteInformationParser
    extends RouteInformationParser<ToFamintoRoutePath> {
  @override
  Future<ToFamintoRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final pathSegments = Uri.parse(routeInformation.location).pathSegments;

    if (pathSegments.isNotEmpty) {
      if (pathSegments.length == 1) {
        final firstSegment = pathSegments[0];
        if (firstSegment == 'lojas') {
          return HomePath();
        } else if (firstSegment == 'pedidos') {
          return OrdersPath();
        } else if (firstSegment == 'carrinho') {
          return CartPath();
        } else if (firstSegment == 'definicoes') {
          return DefinitionsPath();
        } else if (firstSegment == 'explorar') {
          return FilterPath();
        }
      } else if (pathSegments.length == 2) {
        final firstSegment = pathSegments[0];
        final secondSegment = pathSegments[1];

        if (firstSegment == 'definicoes') {
          if (secondSegment == 'perfil') {
            return ProfilePath();
          } else if (secondSegment == 'enderecos') {
            return AddressesPath();
          } else if (secondSegment == 'cartoes') {
            return CardsPath();
          } else if (secondSegment == 'carteira-digital') {
            return WalletPath();
          } else {
            return DefinitionsPath();
          }
        } else if (firstSegment == 'carrinho') {
          return CartPath();
        } else if (firstSegment == 'lojas') {
          return RestaurantPath(secondSegment.toString());
        }
      } else if (pathSegments.length == 3) {
        final firstSegment = pathSegments[0];
        final secondSegment = pathSegments[1];
        final thirdSegment = pathSegments[2];

        if (firstSegment == 'definicoes') {
          if (secondSegment == 'enderecos') {
            if (thirdSegment == 'novo-endereco') {
              return NewAddressesPath();
            }
            return ProfilePath();
          } else if (secondSegment == 'cartoes') {
            if (thirdSegment == 'novo-cartao') {
              return NewCardPath();
            }
            return ProfilePath();
          }
        }
      } else if (pathSegments.length == 3) {
        final firstSegment = pathSegments[0];
        final secondSegment = pathSegments[1];
        final thirdSegment = pathSegments[2];
        if (firstSegment == 'lojas') {
          return ItemPath(
            slug: secondSegment,
            id: int.tryParse(thirdSegment),
          );
        }
      } else {
        return LoginRegisterPath();
      }
    }
    return LoginRegisterPath();
  }

  @override
  RouteInformation restoreRouteInformation(ToFamintoRoutePath configuration) {
    if (configuration is HomePath) {
      return RouteInformation(location: '/lojas');
    } else if (configuration is LoginRegisterPath) {
      return RouteInformation(location: '/login');
    } else if (configuration is RestaurantPath) {
      return RouteInformation(location: '/lojas/${configuration.slug}');
    } else if (configuration is ItemPath) {
      return RouteInformation(
        location: '/lojas/${configuration.slug}/${configuration.id}',
      );
    } else if (configuration is CheckoutPath) {
      return RouteInformation(location: '/carrinho/checkout');
    } else if (configuration is CheckoutNewCardPath) {
      return RouteInformation(location: '/carrinho/checkout/novo-cartao');
    } else if (configuration is CartPath) {
      return RouteInformation(location: '/carrinho');
    } else if (configuration is OrdersPath) {
      return RouteInformation(location: '/pedidos');
    } else if (configuration is DefinitionsPath) {
      return RouteInformation(location: '/definicoes');
    } else if (configuration is ProfilePath) {
      return RouteInformation(location: '/definicoes/perfil');
    } else if (configuration is AddressesPath) {
      return RouteInformation(location: '/definicoes/enderecos');
    } else if (configuration is CardsPath) {
      return RouteInformation(location: '/definicoes/cartoes');
    } else if (configuration is NewAddressesPath) {
      return RouteInformation(location: '/definicoes/enderecos/novo-endereco');
    } else if (configuration is NewCardPath) {
      return RouteInformation(location: '/definicoes/cartoes/novo-cartao');
    } else if (configuration is FilterPath) {
      return RouteInformation(location: '/explorar');
    } else if (configuration is WalletPath) {
      return RouteInformation(location: '/definicoes/carteira-digital');
    }
    return null;
  }
}
