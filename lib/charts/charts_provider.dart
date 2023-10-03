class ChartsDataLocalProvider {
  static final ChartsDataLocalProvider _instance = ChartsDataLocalProvider._internal();

  factory ChartsDataLocalProvider() {
    return _instance;
  }

  ChartsDataLocalProvider._internal();

// --------- Mortalité ---------------
  List<Mortality> mortData = [];

  set setMortality(List<Mortality> data) {
    mortData = data;
  }

  List<Mortality> get getMortData {
    return mortData;
  }


// --------- PV HOMOG ---------------
  List<PvHomog> pvHomogData = [];

  set setPvHomog(List<PvHomog> data) {
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

class Mortality {
  double? sem_reel;
  final int sem_guide;
  double? cuml_reel;
  final double cuml_guide;
  final int age;

  Mortality({
    required this.sem_reel,
    required this.sem_guide,
    required this.cuml_reel,
    required this.cuml_guide,
    required this.age,
  });
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
