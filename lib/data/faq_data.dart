import '../model/faq_model.dart';

class FAQData {
  static final List<FAQModel> faqData = [
    FAQModel(
      title: "What is this app used for?",
      description:
          "primary purpose of this QR mobile app, such as scanning and generating QR codes.",
    ),
    FAQModel(
      title: "What types of QR codes can this app read?",
      description:
          "List the types of data supported by the QR code scanner (e.g., URLs, text, contact info, etc.).",
    ),
    FAQModel(
      title: "Can I save QR codes?",
      description:
          "Provide information on saving a QR code to the gallery, including image formats and quality.",
    ),
    FAQModel(
      title: "Why is my camera not working?",
      description:
          "Offer solutions for troubleshooting camera issues, such as permissions or hardware problems.",
    ),
    FAQModel(
      title: "What should I do if the app doesn’t scan a QR code?",
      description:
          "Provide tips like adjusting lighting, focusing the camera, or checking if the QR code is valid.",
    ),
    FAQModel(
      title: "How do I manage app permissions (e.g., camera, storage)?",
      description: "Explain how to enable or modify necessary app permissions.",
    ),
  ];
}
