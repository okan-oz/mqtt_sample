late SessionModel currentSession;

void initialSession({required String username}) {
  currentSession = SessionModel(username: username);
}

class SessionModel {
  SessionModel({required this.username});
  String username;
}
