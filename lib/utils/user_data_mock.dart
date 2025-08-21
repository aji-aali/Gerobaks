class UserDataMock {
  static final List<Map<String, dynamic>> users = [
    {
      'email': 'daffa@gmail.com',
      'password': 'password123',
      'name': 'User Daffa',
      'profile_picture': 'assets/img_friend1.png',
      'phone': '081234567890',
      'address': 'Jl. Merdeka No. 1, Jakarta',
      'points': 50, // Starting points
    },
    {
      'email': 'sansan@gmail.com',
      'password': 'password456',
      'name': 'Jane San',
      'profile_picture': 'assets/img_friend2.png',
      'phone': '087654321098',      
      'address': 'Jl. Sudirman No. 2, Bandung',
      'points': 125, // Starting points
    },
    {
      'email': 'wahyuh@gmail.com',
      'password': 'password789',
      'name': 'Lionel Wahyu',
      'profile_picture': 'assets/img_friend3.png',
      'phone': '089876543210',
      'address': 'Jl. Thamrin No. 3, Surabaya',
      'points': 75, // Starting points
    },
  ];

  static Map<String, dynamic>? getUserByEmail(String email) {
    try {
      return users.firstWhere((user) => user['email'] == email);
    } catch (e) {
      return null;
    }
  }
}
