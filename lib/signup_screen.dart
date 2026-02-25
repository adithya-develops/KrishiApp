import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'auth_service.dart';
import 'account_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() =>
      _SignupScreenState();
}

class _SignupScreenState
    extends State<SignupScreen> {

  final nameController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final dobController =
      TextEditingController();

  bool loading = false;

  //////////////////////////////////////////////////////
  /// SIGNUP FUNCTION WITH VALIDATION
  //////////////////////////////////////////////////////

  Future signup() async {

    String name =
        nameController.text.trim();

    String phone =
        phoneController.text.trim();

    String password =
        passwordController.text.trim();

    String dob =
        dobController.text.trim();

    /// CHECK EMPTY
    if (name.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        dob.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Fill all fields"),
        ),
      );
      return;
    }

    /// PHONE VALIDATION (INDIAN MOBILE)
    if (!RegExp(r'^[6-9]\d{9}$')
        .hasMatch(phone)) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
              "Enter valid 10-digit mobile number"),
        ),
      );
      return;
    }

    /// PASSWORD VALIDATION
    if (password.length < 6) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
              "Password must be at least 6 characters"),
        ),
      );
      return;
    }

    setState(() => loading = true);

    String? error =
        await AuthService.signup(

      phone: phone,
      password: password,
      name: name,
      dob: dob,

    );

    setState(() => loading = false);

    if (error == null) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const AccountScreen(),
        ),
      );

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
            content: Text(error)),
      );

    }
  }

  //////////////////////////////////////////////////////
  /// UI
  //////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text("Sign Up"),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            /// NAME
            TextField(
              controller:
                  nameController,
              decoration:
                  const InputDecoration(
                labelText: "Name",
              ),
            ),

            const SizedBox(
                height: 10),

            /// PHONE (FIXED)
            TextField(
              controller:
                  phoneController,
              keyboardType:
                  TextInputType.number,
              maxLength: 10,
              inputFormatters: [
                FilteringTextInputFormatter
                    .digitsOnly,
              ],
              decoration:
                  const InputDecoration(
                labelText:
                    "Phone Number",
                counterText: "",
              ),
            ),

            const SizedBox(
                height: 10),

            /// PASSWORD
            TextField(
              controller:
                  passwordController,
              obscureText: true,
              decoration:
                  const InputDecoration(
                labelText:
                    "Password",
              ),
            ),

            const SizedBox(
                height: 10),

            /// DOB
            TextField(
              controller:
                  dobController,
              decoration:
                  const InputDecoration(
                labelText:
                    "DOB (YYYY-MM-DD)",
              ),
            ),

            const SizedBox(
                height: 20),

            /// BUTTON
            SizedBox(

              width: double.infinity,

              child:
                  ElevatedButton(

                onPressed:
                    loading
                        ? null
                        : signup,

                child: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(
                          strokeWidth:
                              2,
                          color: Colors
                              .white,
                        ),
                      )
                    : const Text(
                        "Create Account"),

              ),

            )

          ],

        ),

      ),

    );
  }

  //////////////////////////////////////////////////////
  /// CLEANUP
  //////////////////////////////////////////////////////

  @override
  void dispose() {

    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    dobController.dispose();

    super.dispose();

  }

}
  