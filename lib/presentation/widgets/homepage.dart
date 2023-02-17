import 'dart:async';

import 'package:anuvad_app/presentation/cubits/bluetooth_connectivity_cubit.dart';
import 'package:anuvad_app/presentation/cubits/bluetooth_scan_cubit.dart';
import 'package:anuvad_app/presentation/cubits/midi_connection_cubit.dart';
import 'package:anuvad_app/presentation/widgets/common_components/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
                timer?.cancel();
                BlocProvider.of<BluetoothScanCubit>(context)
                    .scanForBluetoothDevices();
                BlocProvider.of<BluetoothScanCubit>(context)
                    .fetchBluetoothDevices();
                timer = Timer.periodic(
                  const Duration(seconds: 10),
                  (Timer t) => BlocProvider.of<BluetoothScanCubit>(context)
                      .fetchBluetoothDevices(),
                );
                return const FoundDevicesWidget();
              case BluetoothState.poweredOff:
                return const Center(
                  child: Text('Please turn on bluetooth'),
                );
              case BluetoothState.unknown:
                return const Center(
                  child: Text('Unknown bluetooth state'),
                );
              default:
                break;
            }
            return Container();
          }),
    );
  }
}

class FoundDevicesWidget extends StatelessWidget {
  const FoundDevicesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BluetoothScanCubit, List<MidiDevice>>(
      builder: (context, state) => SafeArea(
        top: false,
        child: Column(
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
            const BottomTextWidget(text: "Select from the list to connect"),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}

class BottomTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  const BottomTextWidget({Key? key,required this.text,this.fontSize = 23}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.black,
              fontSize: fontSize, fontWeight: FontWeight.w200),
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
        Utils.showConnectSheet(context, midiDevice);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                SizedBox(width: 25, child: Image.asset("assets/images/p1.png")),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  midiDevice.name,
                  style: GoogleFonts.poppins(
                      fontSize: 17, fontWeight: FontWeight.w300),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                )
              ],
            )),
      ),
    );
  }
}

class Utils {
  static void showConnectSheet(BuildContext context, MidiDevice midiDevice) {
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
          height: 40,
        ),
        if (state != MidiConnectionState.connected) ...[
          const FrameImage(),
          const SizedBox(
            height: 10,
          ),
          ConnectButton(
            onTap: () {
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

  final List<String> instruments = ["guitar", "piano", "sitar"];

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
              imageFileName: instruments[index],
            );
          },
        ),
      ),
    );
  }
}

class InstrumentTile extends StatelessWidget {
  final String imageFileName;
  const InstrumentTile({Key? key, required this.imageFileName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(BlocProvider.of<MidiConnectionCubit>(context).midiDevice.name);
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) =>  FramePage(midiDevice: BlocProvider.of<MidiConnectionCubit>(context).midiDevice,instrumentName: imageFileName,)));
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
            Image.asset("assets/images/$imageFileName.png"),
            const SizedBox(
              width: 20,
            ),
            Text(
              imageFileName,
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
  const FramePage({Key? key,required this.midiDevice,required this.instrumentName}) : super(key: key);

  @override
  State<FramePage> createState() => _FramePageState();
}

class _FramePageState extends State<FramePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 10,),
          FrameTitle( title: widget.midiDevice.name,),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 300,
                  child:Image.asset("assets/images/frame_active.png"),),

                BottomTextWidget(text: widget.instrumentName[0].toUpperCase()+widget.instrumentName.substring(1),fontSize: 36,)
              ],
            ),
          )

        ],
      )
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
        title,
        style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.w200),
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
