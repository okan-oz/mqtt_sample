late SessionModel currentSession;

void initialSession({required String username, required phoneNumber}) {
  currentSession = SessionModel(
    username: username,
    phoneNumber: phoneNumber,
  );
}

class SessionModel {
  SessionModel({required this.username, required this.phoneNumber});
  String username;
  String phoneNumber;
}
