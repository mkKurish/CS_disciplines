% Given a random non-negative number, 
% you have to return the digits of this number
% within an array in reverse order.

% Example(Input => Output):
% 35231 => [1,3,2,5,3]
% 0 => [0]

digitize(N, Res) :- 
  N < 10,
  Res = [N]
.

digitize(N, [H|T]) :-
  N >= 10,
  H is mod(N, 10),
  N1 is div(N, 10),
  digitize(N1, T)
.