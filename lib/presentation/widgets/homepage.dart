import 'dart:async';

import 'package:anuvad_app/presentation/cubits/bluetooth_connectivity_cubit.dart';
import 'package:anuvad_app/presentation/cubits/bluetooth_scan_cubit.dart';
import 'package:anuvad_app/presentation/cubits/instrument_cubit.dart';
import 'package:anuvad_app/presentation/cubits/midi_connection_cubit.dart';
import 'package:anuvad_app/presentation/widgets/common_components/app_bar.dart';
import 'package:anuvad_app/utils/analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    AppAnalytics().logEvent("Home_page_shown");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AnuvadAppBar(),
      body: BlocBuilder<BluetoothConnectionCubit, BluetoothState>(
          bloc: BlocProvider.of<BluetoothConnectionCubit>(context),
          builder: (context, state) {
            switch (state) {
              case BluetoothState.poweredOn:
                AppAnalytics().logEvent("Bluetooth_poweredOn");
                    BlocProvider.of<BluetoothScanCubit>(context)
                        .reset();
                return const FoundDevicesWidget();
              case BluetoothState.poweredOff:
                AppAnalytics().logEvent("Bluetooth_poweredOff");
                return const InfoScreen(text: "Please turn on your bluetooth");
              case BluetoothState.unknown:
                AppAnalytics().logEvent("Bluetooth_unknown");
                return const InfoScreen(
                    text: "Please check your bluetooth settings");
              default:
                break;
            }
            return Container();
          }),
    );
  }
}

class InfoScreen extends StatelessWidget {
  final String text;
  const InfoScreen({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w200),
      ),
    );
  }
}

class FoundDevicesWidget extends StatelessWidget {
  const FoundDevicesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BluetoothScanCubit, List<MidiDevice>>(
      bloc: BlocProvider.of<BluetoothScanCubit>(context),
      builder: (context, state) => SafeArea(
        top: false,
        child: state.isEmpty
            ? const NoDevicesFoundWidget()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text('Available to connect'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.length,
                      itemBuilder: (context, index) {
                        return MidiDeviceTile(
                          midiDevice: state[index],
                        );
                      },
                    ),
                  ),
                  const BottomTextWidget(
                      text: "Select the frame to connect"),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
      ),
    );
  }
}

class NoDevicesFoundWidget extends StatefulWidget {
  const NoDevicesFoundWidget({Key? key}) : super(key: key);

  @override
  State<NoDevicesFoundWidget> createState() => _NoDevicesFoundWidgetState();
}

class _NoDevicesFoundWidgetState extends State<NoDevicesFoundWidget> {
  bool isLoaderVisible = false;
  Timer? timer;

  retry() async {
    if (mounted) {
      setState(() {
        isLoaderVisible = true;
      });
    }
    BlocProvider.of<BluetoothScanCubit>(context).reset();
    await Future.delayed(const Duration(seconds: 5));
    if (mounted) {
      setState(() {
        isLoaderVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              retry();
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: 70,
                    width: 70,
                    child:  AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: isLoaderVisible
                        ? const CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          )
                        : Image.asset("assets/images/spinner.png"))),
                const SizedBox(
                  height: 10,
                ),
                    Opacity(
                      opacity: isLoaderVisible ? 0 : 1,
                      child: Text(
                          "Retry Scanning",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w200),
                        ),
                    ),
              ],
            ),
          ),
        ),
        AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: isLoaderVisible
                ? BottomTextWidget(
                    key: UniqueKey(), text: "Looking for frames . . .")
                : BottomTextWidget(
                    key: UniqueKey(), text: "No Devices Found. Please retry")),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}

class BottomTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  const BottomTextWidget({Key? key, required this.text, this.fontSize = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: fontSize,
              fontWeight: FontWeight.w200),
        ),
      ),
    );
  }
}

class MidiDeviceTile extends StatelessWidget {
  final MidiDevice midiDevice;
  const MidiDeviceTile({Key? key, required this.midiDevice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppAnalytics().logEvent("device_tapped",{
          "device_name": midiDevice.name,
          "device_id": midiDevice.id,
          "device_type":midiDevice.type
        });
        BlocProvider.of<BluetoothScanCubit>(context).stopTimer();
        Utils.showConnectSheet(context, midiDevice);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: 25, child: Image.asset("assets/images/p1.png")),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      midiDevice.name.toUpperCase(),
                      style: GoogleFonts.poppins(
                          fontSize: 17, fontWeight: FontWeight.w300),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

class Utils {
  static void showConnectSheet(BuildContext context, MidiDevice midiDevice) {
    AppAnalytics().logEvent("Connect_sheet_shown",{
      "device_name": midiDevice.name,
      "device_id": midiDevice.id,
      "device_type":midiDevice.type
    });
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        context: context,
        builder: (context) {
          return SafeArea(
              child: BlocProvider(
                  create: (context) => MidiConnectionCubit(midiDevice),
                  child: ConnectSheetWidget(midiDevice: midiDevice)));
        });
  }
}

class ConnectSheetWidget extends StatefulWidget {
  final MidiDevice midiDevice;
  const ConnectSheetWidget({Key? key, required this.midiDevice})
      : super(key: key);

  @override
  State<ConnectSheetWidget> createState() => _ConnectSheetWidgetState();
}

class _ConnectSheetWidgetState extends State<ConnectSheetWidget> {
  double height = 0;
  double topHeight = 20;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MidiConnectionCubit, MidiConnectionState>(
      bloc: BlocProvider.of<MidiConnectionCubit>(context),
      builder: (context, state) {
        if (state == MidiConnectionState.connected) {
          height = MediaQuery.of(context).size.height;
          topHeight = 60;
        } else {
          height = MediaQuery.of(context).size.height * 0.7;
          topHeight = 20;
        }
        return AnimatedContainer(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 500),
            height: height,
            child: getContentWidgets(state));
      },
    );
  }

  getContentWidgets(MidiConnectionState state) {
    return SafeArea(
        child: Column(
      children: [
        AnimatedContainer(
          curve: Curves.easeInSine,
          duration: const Duration(milliseconds: 500),
          height: topHeight,
          child: const SizedBox(
            height: 20,
          ),
        ),
        FrameTitle(title: widget.midiDevice.name),
        const SizedBox(
          height: 20,
        ),
        if (state != MidiConnectionState.connected) ...[
          const FrameImage(),
          const SizedBox(
            height: 10,
          ),
          ConnectButton(
            onTap: () {
              AppAnalytics().logEvent("Connect_tapped",{
                "device_name": widget.midiDevice.name,
                "device_id": widget.midiDevice.id,
                "device_type":widget.midiDevice.type
              });
              BlocProvider.of<MidiConnectionCubit>(context)
                  .startMidiConnection();
            },
          ),
        ] else ...[
          InstrumentListWidget(),
          const BottomTextWidget(text: "Select an instrument to play"),
        ],
        const SizedBox(
          height: 30,
        ),
      ],
    ));
  }
}

class InstrumentListWidget extends StatelessWidget {
  InstrumentListWidget({Key? key}) : super(key: key);

  final List<Instrument> instruments = [
    Instrument.guitar,
    Instrument.piano,
    Instrument.sitar
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 3,
          separatorBuilder: (context, index) => const SizedBox(
            height: 50,
          ),
          itemBuilder: (context, index) {
            return InstrumentTile(
              instrument: instruments[index],
            );
          },
        ),
      ),
    );
  }
}

class InstrumentTile extends StatelessWidget {
  final Instrument instrument;
  const InstrumentTile({Key? key, required this.instrument}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(BlocProvider.of<MidiConnectionCubit>(context).midiDevice.name);
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        AppAnalytics().logEvent("Instrument_tapped",{
          "type": instrument.name,
        });
        BlocProvider.of<InstrumentCubit>(context).use(instrument);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => FramePage(
                  midiDevice:
                      BlocProvider.of<MidiConnectionCubit>(context).midiDevice,
                  instrumentName: instrument.name,
                )));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/${instrument.name}.png"),
            const SizedBox(
              width: 20,
            ),
            Text(
              instrument.name,
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.w300),
            )
          ],
        ),
      ),
    );
  }
}

class FramePage extends StatefulWidget {
  final MidiDevice midiDevice;
  final String instrumentName;
  const FramePage(
      {Key? key, required this.midiDevice, required this.instrumentName})
      : super(key: key);

  @override
  State<FramePage> createState() => _FramePageState();
}

class _FramePageState extends State<FramePage> {

  @override
  void initState() {
    AppAnalytics().logEvent("Frame_page_shown");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<InstrumentCubit>(context).stop();
        return true;
      },
      child: Material(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(
            height: 10,
          ),
          FrameTitle(
            title: widget.midiDevice.name,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 300,
                  child: Image.asset("assets/images/frame_active.png"),
                ),
                BottomTextWidget(
                  text: widget.instrumentName[0].toUpperCase() +
                      widget.instrumentName.substring(1),
                  fontSize: 36,
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}

class ConnectButton extends StatelessWidget {
  final void Function()? onTap;
  const ConnectButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      elevation: 5,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 1),
          ),
          height: 100,
          width: 100,
          child: BlocBuilder<MidiConnectionCubit, MidiConnectionState>(
              bloc: BlocProvider.of<MidiConnectionCubit>(context),
              builder: (context, state) {
                switch (state) {
                  case MidiConnectionState.connected:
                    return const Center(
                      child: Text('Connected',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                    );
                  case MidiConnectionState.connecting:
                    return Lottie.asset("assets/lottie/loader.json");
                  case MidiConnectionState.disconnected:
                  case MidiConnectionState.error:
                    Fluttertoast.showToast(msg: "Error connecting to device. Please verify if the device is connected.");
                    Navigator.of(context).pop();
                    return const Center(
                      child: Text('Connect',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                    );
                  case MidiConnectionState.unknown:
                    return const Center(
                      child: Text('Connect',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                    );
                }
              }),
        ),
      ),
    );
  }
}

class FrameTitle extends StatelessWidget {
  final String title;
  const FrameTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(fontSize: 21, fontWeight: FontWeight.w200),
      ),
    );
  }
}

class FrameImage extends StatelessWidget {
  const FrameImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child:
          SizedBox(height: 300, child: Image.asset("assets/images/frame1.png")),
    );
  }
}
