import 'widgets/drop_down_select.dart';

List<String> immLetters = <String>[
    'أ',
    'ب',
    'ج',
    'د',
    'ه',
    'و',
    'ز',
    'ح',
    'ط',
    'ي',
    'ك',
    'ل',
    'م',
    'ن',
    'س',
    'ع',
    'ف',
    'ص',
    'ق',
    'ر',
    'ش',
    'ت',
    'ث',
    'خ',
    'ذ',
    'ض',
    'ظ',
    'غ',
  ];

  List<SelectOption> operationOptions = [
    SelectOption(id: 0, value: "Vente (بيع)"),
    SelectOption(id: 2, value: "Gratuit (مجاني)"),
    SelectOption(id: 3, value: "Accident (حادثة)"),
    SelectOption(id: 4, value: "Change (تغيير)"),
  ];
  List<SelectOption> classOptions = [
    SelectOption(id: 0, value: "Normaux (G)"),
    SelectOption(id: 1, value: "Double jaune (DJ)"),
    SelectOption(id: 2, value: "Blancs"),
    SelectOption(id: 4, value: "Cassés"),
    SelectOption(id: 5, value: "Félés"),
    SelectOption(id: 6, value: "Congelés (Kg)"),
    SelectOption(id: 7, value: "Éliminés"),
    SelectOption(id: 8, value: "Sale"),
  ];