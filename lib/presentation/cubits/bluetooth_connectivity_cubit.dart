import 'dart:async';

import 'package:anuvad_app/midi_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

///this cubit to check if bluetooth is enabled or not
///if bluetooth is enabled then it will start scanning for devices
///if bluetooth is disabled then it will show a snackbar to enable bluetooth
///

class BluetoothConnectionCubit extends Cubit<BluetoothState> {
  BluetoothConnectionCubit() : super(BluetoothState.unknown);
  StreamSubscription<BluetoothState>? bluetoothConnectionStream;

  setBluetoothState(BluetoothState state){
    emit(state);
  }

  void checkBluetoothConnection() async {
    final midiHandler = MidiHandler();
    bluetoothConnectionStream?.cancel();
    bluetoothConnectionStream = midiHandler.midi.onBluetoothStateChanged.listen((event) {
      setBluetoothState(event);
    });
    await midiHandler.midi.startBluetoothCentral();
    await midiHandler.midi.waitUntilBluetoothIsInitialized();
  }
}





