% We want to generate a function that computes the series
% starting from 0 and ending until the given number.

% Example:
%
% Input: 6
% Output: 0+1+2+3+4+5+6 = 21
%
% Input: -15
% Output: -15<0
%
% Input: 0
% Output: 0=0


nb_year(P0, Percent, Aug, P, R) :- 
    P0 >= P,
    R = 0, !.

nb_year(P0, Percent, Aug, P, R) :- 
    Pcur is floor(P0 + P0 * Percent / 100 + Aug),
    nb_year(Pcur, Percent, Aug, P, R2),
    R is R2 + 1.