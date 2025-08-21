import 'package:bank_sha/services/local_storage_service.dart';
import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/widgets/shared/form.dart';
import 'package:bank_sha/utils/user_data_mock.dart';
import 'package:bank_sha/ui/widgets/shared/layout.dart';
import 'package:bank_sha/ui/widgets/shared/buttons.dart';
import 'package:bank_sha/utils/toast_helper.dart';
import 'package:bank_sha/services/notification_service.dart';
import 'package:bank_sha/services/user_service.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  UserService? _userService;

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _initLocalStorage();
  }

  Future<void> _initLocalStorage() async {
    _localStorageService = await LocalStorageService.getInstance();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final credentials = await _localStorageService.getCredentials();
    if (credentials != null) {
      setState(() {
        _emailController.text = credentials['email']!;
        _passwordController.text = credentials['password']!;
      });
=======
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      _userService = await UserService.getInstance();
      await _userService!.init();

      // Check if user is already logged in
      final isLoggedIn = await _userService!.getCurrentUser() != null;
      if (isLoggedIn && mounted) {
        // If already logged in, navigate to home page
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      print("Error initializing services: $e");
>>>>>>> c3c3211 (feat: Implement auto-fill for sign-in credentials and improve password visibility handling)
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }



  // Handle sign in
  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Make sure service is initialized
      if (_userService == null) {
        await _initializeServices();
      }

      // Login using UserService
      final user = await _userService?.loginUser(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (user != null) {
        // Menampilkan notifikasi login berhasil
        await NotificationService().showNotification(
          id: DateTime.now().millisecond,
          title: 'Login Berhasil',
          body: 'Selamat datang di Gerobaks!',
        );

        // Menampilkan toast login berhasil dengan poin
        if (mounted) {
          ToastHelper.showToast(
            context: context,
            message: 'Login berhasil! Poin Anda: ${user.points}',
            isSuccess: true,
          );

          // Navigasi ke halaman home
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      } else {
        if (mounted) {
          ToastHelper.showToast(
            context: context,
            message: 'Email atau password salah!',
            isSuccess: false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showToast(
          context: context,
          message: 'Terjadi kesalahan: ${e.toString()}',
          isSuccess: false,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

>>>>>>> c3c3211 (feat: Implement auto-fill for sign-in credentials and improve password visibility handling)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Logo Section dengan spacing yang tepat
                  const SizedBox(height: 80),

                  // Logo GEROBAKS dengan fallback
                  Container(
                    width: 250,
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    child: Image.asset(
                      'assets/img_gerobakss.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback jika asset tidak ditemukan
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shopping_cart,
                              color: greenColor,
                              size: 32,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'GEROBAKS',
                              style: greeTextStyle.copyWith(
                                fontSize: 28,
                                fontWeight: bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Google Sign In Button - menggunakan CustomGoogleSignInButton
                  CustomGoogleSignInButton(
                    title: 'Log in dengan Google',
                    onPressed: () {
                      // Handle Google Sign In
                    },
                  ),

                  const SizedBox(height: 24),

                  // OR Divider
                  const CustomDividerLayout(title: 'Or'),

                  const SizedBox(height: 24),

                  // Email Input menggunakan CustomFormField
                  CustomFormField(
                    title: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),

                  const SizedBox(height: 16),

<<<<<<< HEAD
                  // Password Input menggunakan CustomFormField
                  CustomFormField(
                    title: 'Password',
                    obscureText: true,
                    controller: _passwordController,
=======
                        // Password Input menggunakan CustomFormField
                        CustomFormField(
                          title: 'Password',
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                            if (value.length < 6) {
                              return 'Password minimal 6 karakter';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
>>>>>>> c3c3211 (feat: Implement auto-fill for sign-in credentials and improve password visibility handling)
                  ),

                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Lupa Password?',
                        style: greentextstyle2.copyWith(
                          fontSize: 14,
                          fontWeight: regular,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sign In Button - menggunakan CustomFilledButton
                  CustomFilledButton(
                    title: 'Sign In',
                    height: 48,
                    onPressed: () async {
                      final email = _emailController.text;
                      final password = _passwordController.text;

                      if (email.isNotEmpty && password.isNotEmpty) {
                        final user = UserDataMock.getUserByEmail(email);

                        if (user != null && user['password'] == password) {
                          // Save user data to local storage
                          await _localStorageService.saveUserData(user);
                          await _localStorageService.saveCredentials(email, password);

                          // Menampilkan notifikasi login berhasil
                          await NotificationService().showNotification(
                            id: DateTime.now().millisecond,
                            title: 'Login Berhasil',
                            body: 'Selamat datang di Gerobaks, ${user['name']}!',
                          );

                          // Menampilkan toast login berhasil
                          ToastHelper.showToast(
                            context: context,
                            message: 'Login berhasil!',
                            isSuccess: true,
                          );

                          // Navigasi ke halaman home
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (route) => false,
                          );
                        } else {
                          // Menampilkan toast jika kredensial salah
                          ToastHelper.showToast(
                            context: context,
                            message: 'Email atau password salah',
                            isSuccess: false,
                          );
                        }
                      } else {
                        // Menampilkan toast jika email atau password kosong
                        ToastHelper.showToast(
                          context: context,
                          message: 'Email dan password harus diisi',
                          isSuccess: false,
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  // Sign Up Nav
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum punya akun? ',
                        style: greyTextStyle.copyWith(fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/sign-up-batch-1');
                        },
                        child: Text(
                          'Sign Up',
                          style: greeTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: semiBold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
