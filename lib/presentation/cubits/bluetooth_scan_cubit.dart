import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

///cubit to scan for bluetooth devices
///if bluetooth is enabled then it will start scanning for devices
///if bluetooth is disabled then it will show a snackbar to enable bluetooth
///

class BluetoothScanCubit extends Cubit<List<MidiDevice>> {
  List<MidiDevice> foundDevices = [];
  BluetoothScanCubit() : super([]);

  Future<void> scanForBluetoothDevices() async{
    MidiCommand midiCommand = MidiCommand();
    await midiCommand.waitUntilBluetoothIsInitialized().timeout(const Duration(seconds: 5));
    midiCommand.startScanningForBluetoothDevices();
  }

  void fetchBluetoothDevices() async{
    MidiCommand midiCommand = MidiCommand();
    final devices = await midiCommand.devices;
    devices?.forEach((element) {
      midiCommand.stopScanningForBluetoothDevices();
    });
    foundDevices = devices ?? [];
    emit(foundDevices);
  }
}
