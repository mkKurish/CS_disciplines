% In a small town the population is p0 = 1000 at the beginning of a year.
% The population regularly increases by 2 percent per year and moreover 50
% new inhabitants per year come to live in the town. How many years does
% the town need to see its population greater than or equal to p = 1200 inhabitants?

% At the end of the first year there will be: 
% 1000 + 1000 * 0.02 + 50 => 1070 inhabitants
%
% At the end of the 2nd year there will be: 
% 1070 + 1070 * 0.02 + 50 => 1141 inhabitants (** number of inhabitants is an integer **)
%
% At the end of the 3rd year there will be:
% 1141 + 1141 * 0.02 + 50 => 1213
%
% It will need 3 entire years.

% Examples:
% nb_year(1500, 5, 100, 5000) -> 15
% nb_year(1500000, 2.5, 10000, 2000000) -> 10

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