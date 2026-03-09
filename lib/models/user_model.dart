class AppUser {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String image;

  final double totalBalance;
  final double winningBalance;
  final double depositBalance;
  final double referBalance;

  final int garenaPlayed;
  final int ludoPlayed;
  final int carromPlayed;

  final List<String> notifications; // each string can be a simple message

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.image,
    this.totalBalance = 0.0,
    this.winningBalance = 0.0,
    this.depositBalance = 0.0,
    this.referBalance = 0.0,
    this.garenaPlayed = 0,
    this.ludoPlayed = 0,
    this.carromPlayed = 0,
    this.notifications = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'image': image,
      'totalBalance': totalBalance,
      'winningBalance': winningBalance,
      'depositBalance': depositBalance,
      'referBalance': referBalance,
      'garenaPlayed': garenaPlayed,
      'ludoPlayed': ludoPlayed,
      'carromPlayed': carromPlayed,
      'Request&notifications': notifications,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      image: json['image'] ?? '',
      totalBalance: (json['totalBalance'] ?? 0).toDouble(),
      winningBalance: (json['winningBalance'] ?? 0).toDouble(),
      depositBalance: (json['depositBalance'] ?? 0).toDouble(),
      referBalance: (json['referBalance'] ?? 0).toDouble(),
      garenaPlayed: json['garenaPlayed'] ?? 0,
      ludoPlayed: json['ludoPlayed'] ?? 0,
      carromPlayed: json['carromPlayed'] ?? 0,
      notifications: List<String>.from(json['Request&notifications'] ?? []),
    );
  }
}
