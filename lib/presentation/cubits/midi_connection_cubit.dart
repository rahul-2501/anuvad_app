import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class MidiConnectionCubit extends Cubit<MidiConnectionState>{
  MidiConnectionCubit(this._midiDevice) : super(MidiConnectionState.unknown);
  final MidiDevice _midiDevice;

  void startMidiConnection() async{
    emit(MidiConnectionState.connecting);
    await Future.delayed(const Duration(seconds: 2),);
    // MidiCommand midiCommand = MidiCommand();
    // await midiCommand.connectToDevice(midiDevice).then((value) {
      emit(MidiConnectionState.connected);
    // }).catchError((error){
    //   emit(MidiConnectionState.disconnected);
    // });
  }

  MidiDevice get midiDevice => _midiDevice;
}

enum MidiConnectionState{
  connected,
  connecting,
  disconnected,
  unknown
}