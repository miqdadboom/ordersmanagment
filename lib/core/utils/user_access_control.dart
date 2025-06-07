class UserAccessControl {
  static bool ManageEmployee(String role) {
    return role == 'admin';
  }

  static bool ProductsScreenState(String role) {
    return role == 'admin' || role == 'warehouse employee' || role == 'sales representative';
  }

  static bool ProductManagementScreen(String role) {
    return role == 'admin' || role == 'warehouse employee';
  }

  static bool OrderProductsScreen(String role) {
    return role == 'admin' || role == 'warehouse employee';
  }

  static bool OrderDetailsScreen(String role) {
    return role == 'admin' || role == 'warehouse employee';
  }

  static bool CartScreen(String role) {
    return role == 'admin' || role == 'sales representative';
  }

  static bool HomeScreen(String role) {
    return role == 'admin' || role == 'warehouse employee' || role == 'sales representative';
  }

  static bool ConfirmOrder(String role) {
    return role == 'admin' || role == 'sales representative';
  }

  static bool ProductView(String role) {
    return role == 'admin' || role == 'warehouse employee' || role == 'sales representative';
  }

  static bool ListOfOrdersScreen(String role) {
    return role == 'admin' || role == 'warehouse employee' || role == 'sales representative';
  }

  static String getHomeRouteForRole(String role) {
    switch (role) {
      case 'admin':
        return '/manage';
      case 'sales representative':
        return '/productScreen';
      case 'warehouse employee':
        return '/ProductsScreen';
      default:
        return '/productScreen';
    }
  }
}
