% Your goal in this kata is to implement a difference function,
% which subtracts one list from another and returns the result.

% It should remove all values from list a, which are 
% present in list b keeping their order.
% array_diff([1, 2], [1], [2]). % Result = [2]
% If a value is present in b, all of its occurrences must be removed from the other:
% array_diff([1, 2, 2, 2, 3], [2], [1, 3]). % Result = [1, 3]

%%%%-%%%%-%%%%-%%%%-%%%%-%%%%-%%%%-%%%%-%%%%-%%%%-%%%%

array_diff_util([], _, _, []):-!.

array_diff_util([H|T], [], Exclude, Answer):- 
    array_diff_util(T, Exclude, Exclude, Ans2),
    Answer = [H|Ans2], !.

array_diff_util([H|[]], [H|_], _, []):-!.

%%%% %%%% %%%% %%%% %%%% %%%% %%%% %%%% %%%% %%%% %%%%

array_diff_util([H|[]], [E|R], Exclude, Ans):- array_diff_util([H], R, Exclude, Ans), !.

array_diff_util([H|T], [H|R], Exclude, Ans):- array_diff_util(T, Exclude, Exclude, Ans), !.

array_diff_util([H|T], [E|R], Exclude, Ans):- array_diff_util([H|T], R, Exclude, Ans).

%%%% %%%% %%%% %%%% %%%% %%%% %%%% %%%% %%%% %%%% %%%%

array_diff(Array, Exclude, Result):- array_diff_util(Array, Exclude, Exclude, Result).