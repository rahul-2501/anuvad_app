import 'package:anuvad_app/presentation/cubits/bluetooth_connectivity_cubit.dart';
import 'package:anuvad_app/presentation/cubits/bluetooth_scan_cubit.dart';
import 'package:anuvad_app/presentation/cubits/instrument_cubit.dart';
import 'package:anuvad_app/presentation/widgets/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

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

class BlueToothPermissionPage extends StatefulWidget {
  const BlueToothPermissionPage({Key? key}) : super(key: key);

  @override
  State<BlueToothPermissionPage> createState() =>
      _BlueToothPermissionPageState();
}

class _BlueToothPermissionPageState extends State<BlueToothPermissionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Stack(
                  alignment: Alignment.center,
              children: [
                Lottie.asset("assets/lottie/bluetooth_loader.json"),
                SizedBox(
                  height: 330,
                  child: Opacity(
                      opacity: 0.3,
                      child: Image.asset("assets/images/frame_active.png")),
                ),
              ],
            )),
            Text(
              'Bluetooth Permissions',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w300),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "To connect with nearby Bluetooth devices, Anuvad needs Bluetooth permissions. When prompted, tap 'Allow'. Your privacy is important to us, so we'll only use Bluetooth when needed",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w200),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {

                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text(
                    "Continue",
                    style: GoogleFonts.poppins(color: Colors.white),
                  )),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ));
  }
}
