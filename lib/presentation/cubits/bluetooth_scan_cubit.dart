import 'dart:async';

import 'package:anuvad_app/midi_handler.dart';
import 'package:anuvad_app/utils/analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

///cubit to scan for bluetooth devices
///if bluetooth is enabled then it will start scanning for devices
///if bluetooth is disabled then it will show a snackbar to enable bluetooth
///

class BluetoothScanCubit extends Cubit<List<MidiDevice>> {
  List<MidiDevice> foundDevices = [];
  BluetoothScanCubit() : super([]);
  MidiHandler midiHandler = MidiHandler();
  Timer? timer;

  Future<void> scanForBluetoothDevices() async{
    await midiHandler.midi.waitUntilBluetoothIsInitialized().then((value) {
      midiHandler.midi.startScanningForBluetoothDevices();
    }).timeout(const Duration(seconds: 5));
  }

  void fetchBluetoothDevices() async {
    final devices = await midiHandler.midi.devices;
    if(devices != null){
      foundDevices = devices;
      AppAnalytics().logEvent("found_devices",{
        "devices": devices.toString()
      });
    }
    emit(foundDevices);
  }

  reset() async {
    AppAnalytics().logEvent("reset_execution");
    MidiHandler midiHandler = MidiHandler();
     midiHandler.midi.stopScanningForBluetoothDevices();
     timer?.cancel();
     midiHandler.midi.teardown();
     await scanForBluetoothDevices();
     timer = Timer.periodic(const Duration(seconds: 3), (timer) {
       fetchBluetoothDevices();
     });
     Future.delayed(const Duration(seconds: 20), () {
       timer?.cancel();
       midiHandler.midi.stopScanningForBluetoothDevices();
     });
  }

  void stopTimer() {
    timer?.cancel();
  }
}


