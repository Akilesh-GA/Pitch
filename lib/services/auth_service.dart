import '../utils/user_roles.dart';

class AuthService {
  static UserRole? currentUserRole;

  static void setRoleFromString(String role) {
    switch (role) {
      case "storyteller":
        currentUserRole = UserRole.storyteller;
        break;
      case "admin":
        currentUserRole = UserRole.admin;
        break;
      default:
        currentUserRole = UserRole.investor;
    }
  }

  static void clear() {
    currentUserRole = null;
  }
}
