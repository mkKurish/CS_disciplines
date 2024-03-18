nb_year(P0, Percent, Aug, P, R) :- 
    P0 >= P,
    R = 0, !.

nb_year(P0, Percent, Aug, P, R) :- 
    Pcur is floor(P0 + P0 * Percent / 100 + Aug),
    nb_year(Pcur, Percent, Aug, P, R2),
    R is R2 + 1.