//singleton class
import 'package:flutter_midi_command/flutter_midi_command.dart';

class MidiHandler{
  static final MidiHandler _instance = MidiHandler._internal();
  factory MidiHandler() => _instance;
  MidiHandler._internal();

  final MidiCommand _midi = MidiCommand();
  MidiCommand get midi => _midi;
}