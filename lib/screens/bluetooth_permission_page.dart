
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

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