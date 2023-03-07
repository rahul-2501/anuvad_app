import 'dart:async';
import 'dart:typed_data';

import 'package:anuvad_app/midi_handler.dart';
import 'package:anuvad_app/utils/analytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class InstrumentCubit extends Cubit<InstrumentState> {
  InstrumentCubit() : super(InstrumentState.unknown);
  late ByteData sitarData;
  late ByteData guitarData;
  late ByteData pianoData;
  FlutterMidi flutterMidi = FlutterMidi();
  StreamSubscription? streamSubscription;

  loadInstruments() async {
    print(
        "<<<<<<<<<<<<<<<<<<<<<<<< loading started >>>>>>>>>>>>>>>>>>>>>>>>>>>");
    sitarData = await rootBundle.load("assets/sf2/Sitar.SF2");
    guitarData = await rootBundle.load("assets/sf2/Guitar.SF2");
    pianoData = await rootBundle.load("assets/sf2/Piano.sf2");
    print("<<<<<<<<<<<<<<<<<<<<<<<< loading Ended >>>>>>>>>>>>>>>>>>>>>>>>>>>");
  }

  use(Instrument instrument) async {
    emit(InstrumentState.connecting);

    startListening();
    flutterMidi.unmute();

    switch (instrument) {
      case Instrument.sitar:
        AppAnalytics().logEvent("prepare_sitar");
        await flutterMidi.prepare(sf2: sitarData, name: 'Sitar.SF2');
        break;
      case Instrument.guitar:
        AppAnalytics().logEvent("prepare_guitar");
        await flutterMidi.prepare(sf2: guitarData, name: 'Guitar.SF2');
        break;
      case Instrument.piano:
        AppAnalytics().logEvent("prepare_piano");
        await flutterMidi.prepare(sf2: pianoData, name: 'Piano.sf2');
        break;
      default:
        AppAnalytics().logEvent("prepare_piano_default");
        await flutterMidi.prepare(sf2: pianoData, name: 'Piano.sf2');
        break;
    }

    emit(InstrumentState.connected);
  }

  startListening(){
    MidiHandler midiHandler = MidiHandler();
    streamSubscription?.cancel();
    streamSubscription = midiHandler.midi.onMidiDataReceived?.listen((event) {
      flutterMidi.playMidiNote(midi: event.data[1]);
      AppAnalytics().logEvent("play_midi_note",{
        "note": event.data[1]
      });
    });
  }

void stop() {
    streamSubscription?.cancel();
  }

}

enum InstrumentState {
  connected,
  connecting,
  unknown,
}

enum Instrument {
  unknown,
  piano,
  guitar,
  sitar,
}
