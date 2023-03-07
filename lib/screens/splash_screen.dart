import 'package:anuvad_app/presentation/cubits/bluetooth_connectivity_cubit.dart';
import 'package:anuvad_app/presentation/cubits/bluetooth_scan_cubit.dart';
import 'package:anuvad_app/presentation/widgets/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setCurrentValue();
    });
  }

  setCurrentValue() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    switchPage();
  }

  switchPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<BluetoothConnectionCubit>(
              create: (context) =>
                  BluetoothConnectionCubit()..checkBluetoothConnection(),
            ),
            BlocProvider<BluetoothScanCubit>(
                create: (context) => BluetoothScanCubit()),
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
              width: 200,
              child: Image.asset('assets/images/anuvad_logo.png'),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 100,
              child: Lottie.asset("assets/lottie/white_loader.json"),
            )
          ],
        ),
      ),
    );
  }
}


