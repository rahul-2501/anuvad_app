// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_midi/flutter_midi.dart';
// import 'package:flutter_midi_command/flutter_midi_command.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final FlutterMidi flutterMidi = FlutterMidi();
//
//   @override
//   void initState() {
//     getMidiDevices();
//     super.initState();
//     playMidi();
//   }
//
//   playMidi() async {
//
//     flutterMidi.unmute();
//     ByteData byte = await rootBundle.load("assets/sf2/Sitar.SF2");
//     // await flutterMidi.prepare(sf2: byte,name: 'Piano.sf2');
//     await flutterMidi.prepare(sf2: byte,name: 'Sitar.SF2');
//     // await flutterMidi.playMidiNote(midi: 60);
//     // await Future.delayed(Duration(seconds: 1));
//     // await flutterMidi.playMidiNote(midi: 61);
//     // await Future.delayed(Duration(seconds: 1));
//     //
//     // await flutterMidi.playMidiNote(midi: 62);
//     // await Future.delayed(Duration(seconds: 1));
//     //
//     // await flutterMidi.playMidiNote(midi: 63);
//     // await Future.delayed(Duration(seconds: 1));
//     //
//     // await flutterMidi.playMidiNote(midi: 64);
//     // await Future.delayed(Duration(seconds: 1));
//     //
//     // await flutterMidi.playMidiNote(midi: 65);
//
//   }
//
//   playNote(int note) async
//   {
//         //
//         // final note2 = note + 3;
//         // final note3 = note2 + 3 ;
//         flutterMidi.playMidiNote(midi: note - 12 );
//         // flutterMidi.playMidiNote(midi: note+12);
//         // flutterMidi.playMidiNote(midi: note2+12);
//         // flutterMidi.playMidiNote(midi: note3+12);
//         // await Future.delayed(Duration(seconds: 1));
//
//
//   }
//
//   getMidiDevices() async {
//     MidiCommand().teardown();
//     await MidiCommand().startBluetoothCentral();
//
//     await MidiCommand().waitUntilBluetoothIsInitialized().timeout(const Duration(seconds: 5));
//
//     print("HEREEEE");
//
//     // If bluetooth is powered on, start scanning
//     if (MidiCommand().bluetoothState == BluetoothState.poweredOn) {
//       await MidiCommand().startScanningForBluetoothDevices().catchError((err) {
//         print("Error $err");
//       });
//
//       await Future.delayed(Duration(seconds: 5));
//
//
//       final result = await MidiCommand().devices;
//
//       print(result);
//
//       if (result != null && result.isNotEmpty) {
//         ScaffoldMessenger.of(context).hideCurrentSnackBar();
//
//
//         await MidiCommand().connectToDevice(result![1]).then((value) {
//           ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("Connected to ${result![1].name}")));
//
//           MidiCommand().onMidiDataReceived!.listen((event) {
//             if (kDebugMode) {
//               print(event.device.name +" " +event.data.toString());
//             }
//              playNote(event.data[1]);
//             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//             ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(event.data.toString())));
//           });
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         bottom: false,
//         child: Column(
//           children: [
//             Container(
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Crafting Intangibles",
//                             style: GoogleFonts.poppins(
//                                 textStyle: TextStyle(
//                                     fontWeight: FontWeight.w200, fontSize: 40)),
//                           ),
//                           Text(
//                             "Humanising Technology",
//                             style: GoogleFonts.poppins(
//                                 textStyle: TextStyle(
//                                     fontWeight: FontWeight.w300, fontSize: 13)),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     height: 27,
//                   ),
//                   Container(
//                     height: 1,
//                     color: const Color(0xffBABABA),
//                   )
//                 ],
//               ),
//             ),
//             Expanded(child: Container()),
//             Container(
//               padding: EdgeInsets.only(right: 44),
//               height: 64,
//               width: MediaQuery.of(context).size.width,
//               color: const Color(0xffD9D9D9),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     "About Crafting Intangibles",
//                     style: TextStyle(fontSize: 12),
//                     // textScaleFactor: 1.5,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
