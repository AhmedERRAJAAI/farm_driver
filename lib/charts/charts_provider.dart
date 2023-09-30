class ChartsDataLocalProvider {
  static final ChartsDataLocalProvider _instance = ChartsDataLocalProvider._internal();

  factory ChartsDataLocalProvider() {
    return _instance;
  }

  ChartsDataLocalProvider._internal();

// --------- PV HOMOG ---------------
  List<PvHomog> pvHomogData = [];

  set setPvLight(List<PvHomog> data) {
    pvHomogData = data;
  }

  List<PvHomog> get getPvHomog {
    return pvHomogData;
  }

// --------- LIGHT -----------------
  List<LightFlash> lightData = [];

  set setFlashLight(List<LightFlash> data) {
    lightData = data;
  }

  List<LightFlash> get getLightData {
    return lightData;
  }
}

class PvHomog {
  double? pvReel;
  final int pvGuide;
  double? homogReel;
  final double homogGuide;
  final int age;

  PvHomog({
    required this.pvReel,
    required this.homogReel,
    required this.pvGuide,
    required this.homogGuide,
    required this.age,
  });
}

class LightFlash {
  final double flash;
  final double light;
  final int intensite;
  final int age;

  LightFlash({
    required this.flash,
    required this.light,
    required this.intensite,
    required this.age,
  });
}
