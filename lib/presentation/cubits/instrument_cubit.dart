import 'dart:typed_data';

import 'package:anuvad_app/midi_handler.dart';
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

  loadInstruments() async {
    print(
        "<<<<<<<<<<<<<<<<<<<<<<<< loading started >>>>>>>>>>>>>>>>>>>>>>>>>>>");
    sitarData = await rootBundle.load("assets/sf2/Sitar.SF2");
    guitarData = await rootBundle.load("assets/sf2/Sitar.SF2");
    pianoData = await rootBundle.load("assets/sf2/Piano.sf2");
    print("<<<<<<<<<<<<<<<<<<<<<<<< loading Ended >>>>>>>>>>>>>>>>>>>>>>>>>>>");
  }

  use(Instrument instrument) async {
    emit(InstrumentState.connecting);
    print(
        "<<<<<<<<<<<<<<<<<<<<<<<< instrument ${instrument.name} >>>>>>>>>>>>>>>>>>>>>>>>>>>");
    MidiHandler midiHandler = MidiHandler();

    midiHandler.midi.onMidiDataReceived!.listen((event) {
      print(
          "<<<<<<<<<<<<<<<<<<<<<<<< $event >>>>>>>>>>>>>>>>>>>>>>>>>>>");
      flutterMidi.playMidiNote(midi: event.data[1]);
    });
    flutterMidi.unmute();

    switch (instrument) {
      case Instrument.sitar:
        await flutterMidi.prepare(sf2: sitarData, name: 'Sitar.SF2');
        break;
      case Instrument.guitar:
        await flutterMidi.prepare(sf2: guitarData, name: 'Sitar.SF2');
        break;
      case Instrument.piano:
        await flutterMidi.prepare(sf2: pianoData, name: 'Piano.sf2');
        break;
      default:
        await flutterMidi.prepare(sf2: pianoData, name: 'Piano.sf2');
        break;
    }

    emit(InstrumentState.connected);
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
