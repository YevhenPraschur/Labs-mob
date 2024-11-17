abstract class UserRepository {
  Future<void> registerUser(String email, String password);
  Future<bool> loginUser(String email, String password);
}
