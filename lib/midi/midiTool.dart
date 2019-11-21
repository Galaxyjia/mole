import 'dart:math' as math;

class MidiTool{
  final MIDDLE_A = 440;
  final SEMITONE = 69;

  getNote(frequency){
    var note = 12*(math.log(frequency/MIDDLE_A)/math.log(2));
    return note.floor()+SEMITONE;
  }
}