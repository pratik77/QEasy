import 'package:covidpass/enums/user_role.dart';

class UserRoleSerializer {
  static String getRoleFromEnum(UserRole currentUserRole) {
    switch (currentUserRole) {
      case UserRole.CUSTOMER:
        return "normalUser";
      case UserRole.MERCHANT:
        return "merchant";
      case UserRole.POLICE:
        return "police";
      default:
        return null;
    }
  }

  static UserRole getEnumFromRole(String currentUserRole) {
    switch (currentUserRole) {
      case "normalUser":
        return UserRole.CUSTOMER;
      case "merchant":
        return UserRole.MERCHANT;
      case "police":
        return UserRole.POLICE;
      default:
        return null;
    }
  }
}
