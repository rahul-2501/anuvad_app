import 'package:anuvad_app/presentation/cubits/bluetooth_connectivity_cubit.dart';
import 'package:anuvad_app/presentation/cubits/bluetooth_scan_cubit.dart';
import 'package:anuvad_app/presentation/widgets/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double _currentValue = 0;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setCurrentValue();
    });
  }

  setCurrentValue() async {
    setState(() {
      _currentValue = 100.0;
    });
    await Future.delayed(const Duration(milliseconds: 2500));
    switchPage();
  }

  switchPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<BluetoothConnectionCubit>(
              create: (context) => BluetoothConnectionCubit()
                ..checkBluetoothConnection(),
            ),
            BlocProvider<BluetoothScanCubit>(
              create: (context) => BluetoothScanCubit()
            ),
          ],
          child: const HomePage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: Image.asset('assets/images/anuvad_logo.png'),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 400,
              child: FAProgressBar(
                maxValue: 100,
                size: 10,
                backgroundColor: const Color(0xff565656),
                animatedDuration: const Duration(seconds: 2),
                borderRadius: BorderRadius.circular(0),
                progressColor: Colors.white,
                currentValue: _currentValue,
                direction: Axis.horizontal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
