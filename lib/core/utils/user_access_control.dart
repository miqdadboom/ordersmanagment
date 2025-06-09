class UserAccessControl {
  static bool ManageEmployee(String role) {
    return role == 'admin';
  }

  static bool ProductsScreenState(String role) {
    return role == 'admin' ||
        role == 'warehouseEmployee' ||
        role == 'salesRepresentative';
  }

  static bool ProductManagementScreen(String role) {
    return role == 'admin' || role == 'warehouseEmployee';
  }

  static bool OrderProductsScreen(String role) {
    return role == 'admin' ||
        role == 'warehouseEmployee' ||
        role == 'salesRepresentative';
  }

  static bool OrderDetailsScreen(String role) {
    return role == 'admin' || role == 'warehouseEmployee';
  }

  static bool CartScreen(String role) {
    return role == 'admin' || role == 'salesRepresentative';
  }

  static bool HomeScreen(String role) {
    return role == 'admin' ||
        role == 'warehouseEmployee' ||
        role == 'salesRepresentative';
  }

  static bool ConfirmOrder(String role) {
    return role == 'admin' ||
        role == 'salesRepresentative' ||
        role == 'warehouseEmployee';
  }

  static bool ProductView(String role) {
    return role == 'admin' ||
        role == 'warehouseEmployee' ||
        role == 'salesRepresentative';
  }

  static bool ListOfOrdersScreen(String role) {
    return role == 'admin' ||
        role == 'warehouseEmployee' ||
        role == 'salesRepresentative';
  }

  static String getHomeRouteForRole(String role) {
    switch (role) {
      case 'admin':
        return '/manage';
      case 'salesRepresentative':
        return '/productScreen';
      case 'warehouseEmployee':
        return '/ProductsScreen';
      default:
        return '/productScreen';
    }
  }

  static String normalizeRole(String? role) {
    switch (role) {
      case 'salesRepresentative':
        return 'salesRepresentative';
      case 'warehouseEmployee':
        return 'warehouseEmployee';
      case 'admin':
        return 'admin';
      case 'warehouse_manager':
        return 'warehouseEmployee';
      case 'sales_representative':
        return 'salesRepresentative';
      default:
        return role ?? '';
    }
  }
}
