import '../model/faq_model.dart';

class FAQData {
  static final List<FAQModel> faqData = [
    FAQModel(
      title: "What is this app used for?",
      description:
          "Primary purpose of this QR mobile app is to scan and generate QR codes.",
    ),
    FAQModel(
      title: "What types of QR codes can this app read?",
      description:
          "Text\nURL\nEmail\nContact Information\nWi-Fi Configuration\nGeolocation\nPhone Numbers\nEvent Information\n  SMS.",
    ),
    FAQModel(
      title: "Can I save QR codes?",
      description:
          "Yes, you can save generated QR code images in JPG format with a resolution of 576x576 pixels.",
    ),
    FAQModel(
      title: "How do I manage app permissions",
      description:
          "To enable or modify app permissions, go to Settings > Apps > Easy QR App > Permissions.",
    ),
    FAQModel(
      title: "Why is my camera not working?",
      description:
          "Check Camera Permissions\nRestart the App\nEnsure that you are using the latest version of the app\n Ensure your device's operating system version is compatible with the app.",
    ),
    FAQModel(
      title: "What should I do if the app doesn’t scan a QR code?",
      description:
          "Adjust the lighting around the QR code\nEnsure the QR code is in focus\nCheck if the QR code is valid and not damaged\nClean the camera lens to remove any smudges.",
    ),
  ];
}
