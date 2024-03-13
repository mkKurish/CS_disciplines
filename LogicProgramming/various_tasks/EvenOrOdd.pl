% Create a function that takes an integer as an argument and returns "Even" for even numbers or "Odd" for odd numbers.

base_case(0, "Even").
base_case(1, "Odd").

even_or_odd(Num, Result) :-
    Rest is Num mod 2,
    base_case(Rest, Res),
    Result = Res
.