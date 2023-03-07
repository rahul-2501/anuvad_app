import 'package:anuvad_app/presentation/cubits/instrument_cubit.dart';
import 'package:anuvad_app/screens/splash_screen.dart';
import 'package:anuvad_app/utils/analytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await AppAnalytics.init();
  AppAnalytics().logEvent("App_open");
  runApp(BlocProvider(
    lazy: false,
      create: (context) => InstrumentCubit()..loadInstruments(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anuvad',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: GoogleFonts.poppins().fontFamily),
      home: const SplashScreen(),
    );
  }
}
