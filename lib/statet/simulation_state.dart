class SimulationState {
  static final SimulationState _instance = SimulationState._internal();

  factory SimulationState() => _instance;

  SimulationState._internal();

  /// =========================
  /// 🔥 SCENE 2
  /// =========================
  String orgName = "";
  Map<String, String> orgData = {};

  /// =========================
  /// 🔥 SCENE 3
  /// =========================
  String leadershipChoice = "";
  String leadershipType = "";

  /// =========================
  /// 🔥 SCENE 4
  /// =========================
  double controlLevel = 0;
  Map<String, dynamic>? continuumResult;
  /// =========================
  /// 🔥 SCENE 5
  /// =========================
  Map<String, String> teamDecision = {};
  Map<String, dynamic>? teamResult;
  /// =========================
  /// 🔥 SCENE 6
  /// =========================
String crisisStrategy = "";
Map<String, dynamic>? crisisResult;
  /// =========================
  /// 🔥 RESET (optional)
  /// =========================
  void reset() {
    orgName = "";
    orgData = {};
    leadershipChoice = "";
    leadershipType = "";
    controlLevel = 0;
    teamDecision = {};
    crisisStrategy = "";
  }
}