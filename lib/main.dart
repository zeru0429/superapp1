import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:superapp/apps/mezemur/screen/splash.dart';
import 'package:superapp/component/sidebar/hidden_draw.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superapp/apps/mezemur/database/db_connection.dart';
import 'package:superapp/apps/mezemur/screen/search.dart';
import 'package:superapp/apps/mezemur/mezmurMain.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool? codeExecuted = prefs.getBool('codeExecuted');

  if (codeExecuted == null || !codeExecuted) {
    final dbHelper = DatabaseConnection();
    await dbHelper.setDatabase();
    dbHelper.insertData();

    await prefs.setBool('codeExecuted', true);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primarySwatch = MaterialColor(0xFF008292, {
      50: const Color(0xFF008292).withOpacity(0.1),
      100: const Color(0xFF008292).withOpacity(0.2),
      200: const Color(0xFF008292).withOpacity(0.3),
      300: const Color(0xFF008292).withOpacity(0.4),
      400: const Color(0xFF008292).withOpacity(0.5),
      500: const Color(0xFF008292).withOpacity(0.6),
      600: const Color(0xFF008292).withOpacity(0.7),
      700: const Color(0xFF008292).withOpacity(0.8),
      800: const Color(0xFF008292).withOpacity(0.9),
      900: const Color(0xFF008292).withOpacity(1.0),
    });

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primarySwatch,
      ),
      routes: {
        '/search': (context) => Scaffold(
              appBar: AppBar(
                title: const Text("Search"),
              ),
              body: searchMezemur(),
            ),
      },
      home: SplashScreen(),
      onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => MezmurMain(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 500),
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _animationController.forward();

    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const MyHomePage(title: 'Jit Gbi Gubae Super App'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double splashImageSize = MediaQuery.of(context).size.width * 0.4;
    double fontSize = MediaQuery.of(context).size.width * 0.05;
    double loadingSize = MediaQuery.of(context).size.width * 0.05;
    double bannerSize =
        MediaQuery.of(context).size.width * 0.39; // 30% of screen width
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Center(
        child: SingleChildScrollView(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: bannerSize,
                    height: bannerSize,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    """የኢ/ኦ/ተ/ቤ/ክርስትያን በጅማ ቅዱስ ገብርኤል 
          ግቢ ጉባኤ መዝሙር የሞባይል መተግበሪያ (አፕ)
          """,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // Add custom text color
                    ),
                    textAlign: TextAlign.center, // Center align the text
                  ),
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue), // Set custom loading color
                    strokeWidth: 2.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MezmurMain(),
      ),
    );
  }
}
