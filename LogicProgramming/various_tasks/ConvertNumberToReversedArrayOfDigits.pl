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