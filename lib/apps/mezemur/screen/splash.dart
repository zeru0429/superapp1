// import 'package:flutter/material.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();

//     // Create the animation controller
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     );

//     // Create the animation
//     _animation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     );

//     // Start the animation
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: FadeTransition(
//           key: UniqueKey(), // Add a unique key to the FadeTransition widget
//           opacity: _animation,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/images/2.JPG', // Replace 'assets/logo.png' with your logo image path
//                 width: 200,
//                 height: 200,
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 "የኢ/ኦ/ተ/ቤ/ክርስትያን በጅማ ቅዱስ ገብርኤል ግቢ ጉባኤ መዝሙር የሞባይል መተግበሪያ (አፕ)",
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SplashScreen(),
//     );
//   }
// }
