import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // No Parse SDK initialization needed - using direct HTTP calls
  print('✓ App initialized with HTTP API integration');

  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Splash Screen - checks if user is logged in
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    print('✓ SplashScreen initState called');
    _checkLoginStatus();
  }

  /// Check if user is already logged in
  Future<void> _checkLoginStatus() async {
    print('✓ Checking login status...');
    await Future.delayed(const Duration(seconds: 2));

    try {
      final isLoggedIn = await AuthService.isLoggedIn();
      print('✓ Login status checked: $isLoggedIn');

      if (mounted) {
        if (isLoggedIn) {
          print('✓ User logged in, navigating to /home');
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          print('✓ User not logged in, navigating to /login');
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    } catch (e) {
      print('✗ Error checking login status: $e');
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 80, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Task Manager',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Loading...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
