show_sequence(Count, ReturnedString):-
  Count < 0, atom_concat(Count, "<0", ReturnedString), !.

show_sequence(Count, ReturnedString):-
  Count = 0, atom_concat(Count, "=0", ReturnedString), !.

show_sequence_countdown(Count, ReturnedString, ResNumber):-
    Count = 0,
    ResNumber = 0,
    ReturnedString = "0", !.

show_sequence_countdown(Count, ReturnedString, ResNumber):-
    SmallerCount is Count - 1,
    show_sequence_countdown(SmallerCount, PreSequence, SmallerResNumber),
    ResNumber is SmallerResNumber + Count,
    atom_concat("+", Count, CurrentAdding),
    atom_concat(PreSequence, CurrentAdding, ReturnedString).

show_sequence(Count, ReturnedString):-
  show_sequence_countdown(Count, LeftPart, Sum),
  atom_concat(" = ", Sum, RightPart),
  atom_concat(LeftPart, RightPart, ReturnedString).