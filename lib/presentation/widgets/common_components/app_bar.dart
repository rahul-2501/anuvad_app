
import 'package:anuvad_app/presentation/cubits/bluetooth_scan_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:google_fonts/google_fonts.dart';

class AnuvadAppBar extends StatefulWidget implements PreferredSizeWidget {
  const AnuvadAppBar({Key? key}) : super(key: key);

  @override
  State<AnuvadAppBar> createState() => _AnuvadAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AnuvadAppBarState extends State<AnuvadAppBar> {

  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: [
        BlocBuilder<BluetoothScanCubit,List<MidiDevice>>(
          bloc: BlocProvider.of<BluetoothScanCubit>(context),
            builder: (context, state) {
              return state.isNotEmpty ?
           Container(
                margin: const EdgeInsets.only(right: 20),
                width: 40,
                height: 40,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                    onTap: !isScanning ?() {
                      setState(() {
                        isScanning = true;
                      });
                      BlocProvider.of<BluetoothScanCubit>(context).reset();
                      Future.delayed(const Duration(seconds: 5),(){
                        setState(() {
                          isScanning = false;
                        });
                      });
                    }:null,
                    child:   isScanning ? const CupertinoActivityIndicator(
                      color: Colors.black,
                    ): Image.asset("assets/images/spinner.png")),
              ) : const SizedBox();
            })
              ],
      elevation: 3,
      shadowColor: const Color(0xffA3A8B4).withOpacity(0.10),
      backgroundColor: Colors.white,
      centerTitle: false,
      title: Text('CI', style: GoogleFonts.poppins(color: Colors.black,fontSize: 40,fontWeight: FontWeight.w200)),
    );
  }
}
