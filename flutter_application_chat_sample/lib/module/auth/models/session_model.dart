late SessionModel currentSession;

void initialSession({required String username, required phoneNumber,required String fullName}) {
  currentSession = SessionModel(
    username: username,
    phoneNumber: phoneNumber,
    fullName: fullName,
  );
}

class SessionModel {
  SessionModel({required this.username, required this.phoneNumber,required this.fullName});
  String username;
  String phoneNumber;
  String fullName;
}
