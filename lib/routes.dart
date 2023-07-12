import 'package:fireship/about/about.dart';
import 'package:fireship/home/home.dart';
import 'package:fireship/login/login.dart';
import 'package:fireship/profile/profile.dart';
import 'package:fireship/topics/topics.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/topics': (context) => const TopicsScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/about': (context) => const AboutScreen(),
};
