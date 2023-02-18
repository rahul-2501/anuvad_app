import 'package:anuvad_app/midi_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

///this cubit to check if bluetooth is enabled or not
///if bluetooth is enabled then it will start scanning for devices
///if bluetooth is disabled then it will show a snackbar to enable bluetooth
///

class BluetoothConnectionCubit extends Cubit<BluetoothState> {
  BluetoothConnectionCubit() : super(BluetoothState.unknown);

  void checkBluetoothConnection() async {
    final midiHandler = MidiHandler();
    await midiHandler.midi.startBluetoothCentral();
    midiHandler.midi.onBluetoothStateChanged.listen((event) {
      if (event == BluetoothState.poweredOn) {
        emit(BluetoothState.poweredOn);
      } else if (event == BluetoothState.poweredOff) {
        emit(BluetoothState.poweredOff);
      }else{
        emit(BluetoothState.unknown);
      }
    });
  }
}





