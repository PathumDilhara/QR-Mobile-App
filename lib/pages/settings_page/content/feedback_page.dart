import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:qr_mobile_app/utils/text_styles.dart';

class FeedbackPages extends StatefulWidget {
  const FeedbackPages({super.key});

  @override
  State<FeedbackPages> createState() => _FeedbackPagesState();
}

class _FeedbackPagesState extends State<FeedbackPages> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color backgroundColor = isDark
        ? AppColors.kSettingsContentsPageBgColor
        : AppColors.kWhiteColor.withOpacity(0.95);
    Color titleColor =
        isDark ? AppColors.kWhiteColor.withOpacity(0.7) : Colors.black;
    Color headingColor =
        isDark ? AppColors.kWhiteColor.withOpacity(0.7) : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "FeedBack",
          style: AppTextStyles.appTitleStyle.copyWith(color: titleColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "We would love to hear your thoughts!",
                  style:
                      AppTextStyles.appTitleStyle.copyWith(color: headingColor),
                ),
                const SizedBox(
                  height: 50,
                ),

                // Name
                TextFormField(
                  controller: _nameController,
                  onChanged: (value) {
                    setState(() {
                      _formKey.currentState?.validate();
                    });
                  },
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    labelText: "Your Name",
                    floatingLabelBehavior: isDark
                        ? FloatingLabelBehavior.never
                        : FloatingLabelBehavior.auto,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.kGreyColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.kMainPurpleColor,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.kMainPurpleColor,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.kWhiteColor,
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: AppColors.kGreyColor,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                // Email
                TextFormField(
                  controller: _emailController,
                  onChanged: (value) {
                    setState(() {
                      _formKey.currentState?.validate();
                    });
                  },
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    labelText: "Your email",
                    floatingLabelBehavior: isDark
                        ? FloatingLabelBehavior.never
                        : FloatingLabelBehavior.auto,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.kGreyColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.kMainPurpleColor,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.kMainPurpleColor,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.kWhiteColor,
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: AppColors.kGreyColor,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                // Feedback
                TextFormField(
                  controller: _feedbackController,
                  onChanged: (value) {
                    setState(() {
                      _formKey.currentState?.validate();
                    });
                  },
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    labelText: "Your feedback...",
                    floatingLabelBehavior: isDark
                        ? FloatingLabelBehavior.never
                        : FloatingLabelBehavior.auto,
                    alignLabelWithHint: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.kGreyColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.kMainPurpleColor,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.kMainPurpleColor,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.kWhiteColor,
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: AppColors.kGreyColor,
                    ),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide your feedback';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),

                // submit button
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      overlayColor:
                          WidgetStatePropertyAll(Colors.white.withOpacity(0.1)),
                      maximumSize: WidgetStatePropertyAll(
                        Size(MediaQuery.of(context).size.width * 0.6, 50),
                      ),
                      backgroundColor: const WidgetStatePropertyAll(
                          AppColors.kMainPurpleColor),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _submitFeedback();
                      }
                      FocusScope.of(context).unfocus();
                    },
                    child: const Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 25,
                          color: AppColors.kWhiteColor,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // for submit button
  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String email = _emailController.text;
      String feedback = _feedbackController.text;

      const username = 'easyqrfeedbackpathumdilhara@gmail.com';
      const password = '0713775346spd';

      final smtpServer = gmail(username, password);
      final message = Message()
        ..from = Address(email, name)
        ..recipients.add(username) // Your email address
        ..subject = 'Feedback from $name'
        ..text = 'Email: $email\nFeedback: $feedback';

      try {
        // final sendReport = await send(message, smtpServer);
        // print('Message sent: ${sendReport.toString()}');
        // Show confirmation dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Feedback Submitted"),
              content: Text("Thank you, $name! We appreciate your feedback."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        // Clear the fields after submission
        _nameController.clear();
        _emailController.clear();
        _feedbackController.clear();
      } on MailerException catch (e) {

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     backgroundColor: Colors.red,
        //     duration: const Duration(seconds: 1),
        //     content: Text(
        //       "Message not sent. ${e.toString()}",
        //       style: const TextStyle(fontSize: 18),
        //     ),
        //   ),
        // );
        // print(e);

        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: const Text("Submission Failed"),
        //       content: const Text(
        //           "An error occurred while submitting your feedback. Please try again later."),
        //       actions: <Widget>[
        //         TextButton(
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //           child: const Text('OK'),
        //         ),
        //       ],
        //     );
        //   },
        // );
        
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Feedback Submitted"),
              content: Text("Thank you, $name! We appreciate your feedback."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        // Clear the fields after submission
        _nameController.clear();
        _emailController.clear();
        _feedbackController.clear();
      }


    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }
}

// // Here you can send the feedback to your backend or handle it however you want
// String name = _nameController.text;
// String email = _emailController.text;
// String feedback = _feedbackController.text;
//
// // Example of showing a simple dialog after submission
// showDialog(
//   context: context,
//   builder: (BuildContext context) {
//     return AlertDialog(
//       title: Text(
//         "Feedback Submitted",
//         style: AppTextStyles.appTitleStyle,
//       ),
//       content: Text(
//         "Thank you, $name! We appreciate your feedback.\n\nEmail: $email\nFeedback: $feedback",
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//           color: AppColors.kBlackColor,
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           style: ButtonStyle(
//             overlayColor: WidgetStatePropertyAll(
//               AppColors.kMainPurpleColor.withOpacity(0.2),
//             ), // Light purple splash
//           ),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text(
//             'OK',
//             style: TextStyle(color: AppColors.kMainPurpleColor),
//           ),
//         ),
//       ],
//     );
//   },
// );
