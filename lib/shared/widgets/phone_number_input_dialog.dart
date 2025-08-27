import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PhoneNumberInputDialog extends StatefulWidget {
  final Function(String phoneNumber) onSubmit;

  const PhoneNumberInputDialog({super.key, required this.onSubmit});

  @override
  State<PhoneNumberInputDialog> createState() => _PhoneNumberInputDialogState();
}

class _PhoneNumberInputDialogState extends State<PhoneNumberInputDialog> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              top: 60.0 + 16.0,
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
            ),
            margin: const EdgeInsets.only(top: 60.0),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C3A),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Please enter your phone number to complete your registration.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.white70),
                ),
                const SizedBox(height: 24.0),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: const TextStyle(color: Colors.white70),
                      hintText: 'e.g., +1234567890',
                      hintStyle: const TextStyle(color: Colors.white54),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white54),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.white.withAlpha((0.1 * 255).round()),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                        return 'Please enter a valid phone number (e.g., +1234567890)';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF6200EE),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onSubmit(_phoneNumberController.text);
                        context.go('/home');
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16.0,
            right: 16.0,
            child: CircleAvatar(
              backgroundColor: const Color(0xFF6200EE),
              radius: 60.0,
              child: Icon(
                Icons.phone_android,
                color: Colors.white,
                size: 60.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
