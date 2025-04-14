import 'package:adminmangga/services/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login/login_page.dart';

void showUpdatePasswordDialog(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: Colors.grey.shade50,
            elevation: 8,
            titlePadding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Update Your Password",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF147452),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Choose a strong, unique password for your account",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.grey.shade300),
              ],
            ),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: !isNewPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      hintText: 'Minimum 6 characters',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF147452),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isNewPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: () {
                          setState(() {
                            isNewPasswordVisible = !isNewPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFF147452), width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: !isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Re-enter your password',
                      prefixIcon: const Icon(
                        Icons.lock_reset,
                        color: Color(0xFF147452),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFF147452), width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            // Show loading indicator
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const Center(
                                  child: LoadingWidget(),
                                );
                              },
                            );

                            final user = FirebaseAuth.instance.currentUser;
                            await user
                                ?.updatePassword(newPasswordController.text);
                            await FirebaseAuth.instance.signOut();

                            // Close loading dialog
                            Navigator.pop(context);
                            Navigator.pop(context);

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.white),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        'Password updated successfully. Please log in again.',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: const Color(0xFF147452),
                                duration: const Duration(seconds: 4),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                margin: const EdgeInsets.all(16),
                              ),
                            );

                            // Navigate to login page
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginPage()),
                              (route) => false,
                            );
                          } on FirebaseAuthException catch (e) {
                            // Close loading dialog
                            Navigator.pop(context);

                            // Show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.error_outline,
                                        color: Colors.white),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        e.message ?? 'Password update failed',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.red.shade700,
                                duration: const Duration(seconds: 4),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                margin: const EdgeInsets.all(16),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF147452),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Update Password",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}
