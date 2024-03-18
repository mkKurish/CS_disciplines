% Develop a function whose argument is a list that returns
% a list of pairs: (<element of the original list> <the number of its occurrences in
% the original list>)
%
% For example:
% Input: (1 2 1 1 3 5 2 5)
% Output: ((1 3) (2 2) (3 1) (5 2))
%
% Prompt: calculate([1, 2, 1, 1, 3, 5, 2, 5], R).
%

increment_by_value(Value, [], [[Value, 1]]):-!.

increment_by_value(Value, [[Value, Body]|T], [[Value, Result]|T]):-
    Result is Body + 1, !.

increment_by_value(Value, [H|T], Result):-
    increment_by_value(Value, T, MidResult),
    Result = [H| MidResult].

calculate([], []):-!.
calculate([H|T], Result):-
    calculate(T, MidResult),
    increment_by_value(H, MidResult, Result).