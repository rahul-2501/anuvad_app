import 'package:anuvad_app/midi_handler.dart';
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
  Future<void> scanForBluetoothDevices() async{
    await midiHandler.midi.waitUntilBluetoothIsInitialized().then((value) {

      midiHandler.midi.startScanningForBluetoothDevices();
    }).timeout(const Duration(seconds: 5));
  }

  void fetchBluetoothDevices() async {
    midiHandler.midi.teardown();
    final devices = await midiHandler.midi.devices;
    foundDevices = devices ?? [];
    emit(foundDevices);
  }
}
