import 'package:anuvad_app/midi_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class MidiConnectionCubit extends Cubit<MidiConnectionState>{
  MidiConnectionCubit(this._midiDevice) : super(MidiConnectionState.unknown);
  final MidiDevice _midiDevice;

  void startMidiConnection() async {
    emit(MidiConnectionState.connecting);
    await Future.delayed(const Duration(seconds: 2),);
    MidiHandler midiHandler = MidiHandler();
    await midiHandler.midi.connectToDevice(_midiDevice).then((value) {
      print("<<<<<<<<<<<<<<<<<<<<<<<< connected >>>>>>>>>>>>>>>>>>>>>>>>>>>");
      // midiHandler.midi.onMidiDataReceived!.listen((event) {
      //   print("<<<<<<<<<<<<<<<<<<<<<<<< event >>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //   print(event);
      //   print("<<<<<<<<<<<<<<<<<<<<<<<< event >>>>>>>>>>>>>>>>>>>>>>>>>>>");
      // });
      emit(MidiConnectionState.connected);
    }).catchError((error){
      emit(MidiConnectionState.disconnected);
    });
  }

  MidiDevice get midiDevice => _midiDevice;
}

enum MidiConnectionState{
  connected,
  connecting,
  disconnected,
  unknown
}