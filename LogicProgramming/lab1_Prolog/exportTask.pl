% 41. EXPORT TASK (D. Bizam, J. Herceg - Game and logic)

% The products of the Precision Instruments company are in great demand abroad.
% The company's enterprises produce precision instruments of six different types
% (for convenience, we will designate them with Roman numerals I, II, ... VI),
% and all six types are literally in great demand. And now the company has received
% six orders from abroad from trading firms in London, Prague, Rome, Amsterdam,
% Sofia and Helsinki. Empty wagons were lined up in the factory yard, waiting for loading.

% 8 o'clock in the morning. Known for his punctuality, the head of the foreign trade
% department of the company is Comrade Akkurati He walked briskly to the office to
% ensure the timely dispatch of goods, and when he opened the door of his office,
% he almost fainted from shock.

% It turned out that the night before, Gizeke, a beautiful 18-year-old typist,
% absentmindedly threw an outstanding cigarette butt instead of an ashtray into a wastebasket.
% True, the stationery table next to the basket was saved, but all the papers,
% including Comrade Akkurati's handwritten notes, which contained detailed information
% about the cities, the number of wagons and the number of devices to be sent,
% turned into a pile of ashes.

% What to do? All six orders are urgent, and their shipment cannot be delayed for a minute.
% True, it would be possible to call representatives of trading companies by phone and clarify
% orders with them, but such a solution is clearly unacceptable: representatives could lose
% confidence in the company and cancel orders.

% There was nowhere to retreat: the comrade Akkurati had to rely on his own memory.
% Indeed, the head of the foreign trade department of the Precision Instruments
% company managed to recall quite a lot.

% 1. All trading companies ordered only one type of device, and

% 2. Various types of devices were to be sent to all six cities.

% 3. The number of wagons to be shipped was also restored.
% The company should ship 1 car to one city, 2 cars to another,
% 3 cars to the third, etc. (These data were supported by the
% fact that there was just one car in the factory yard waiting
% for loading 1 + 2 3 + 4 + 5 +6 == 21 the carriage.)

% 4. Where should the 4 wagons have been sent? Unfortunately,
% the comrade Akkurati could not remember this, but he knew
% for sure that he was not going to Prague or London.

% 5. Where to send 6 wagons? The head of the Foreign trade
% department tried to recall the order letter. So it is!
% It is safe to say that the order for 6 wagons came from
% either an Italian or a Czech trading company.

% 6. And where to send 5 wagons? So, let's figure it out…
% There is! To one of two cities: either Prague or Amsterdam!

% 7. The first two types of devices (I and II) are ordered
% mainly by London and Prague. There is no doubt that this
% time they ordered these types of devices.

% 8. A Roman trading company usually orders two medium-sized devices (III and IV).
% It is also reasonable to assume that 3 wagons were not intended for shipment to Rome.

% 9. The order for the devices came from Helsinki. What kind of devices
% and how many Finns needed them, comrade could not remember exactly,
% but he knew for sure that it was not V type and not 2 wagons.
% No matter how hard the head of the foreign trade department tried,
% he could not establish anything else, and this upset him very much.

% 10. It was also possible to recall that one of the trading
% companies ordered an even number of wagons with type VI devices,

% 11. but 6 wagons should have been loaded with odd-type devices.
% However, wait a minute… Is it so? No, maybe 6 wagons should have
% been loaded with type VI devices, and if not VI, then the odd type.
% That's for sure.

% 12. 4 wagons had to be loaded with devices of one of the first three types.

% 13. Finally, comrade 'Accurately' remembered quite clearly
% that type IV devices needed to be shipped at least 2 wagons.

% Has it been possible to restore enough information from the
% memory of a comrade 'Accurately' so that we can find out how many
% wagons should be loaded, what types of devices and to which cities to send orders?

devices("I").
devices("II").
devices("III").
devices("IV").
devices("V").
devices("VI").

cities("London").
cities("Prague"). % Czech
cities("Rome"). % Italy
cities("Amsterdam").
cities("Sofia").
cities("Helsinki").

railcars_count(1).
railcars_count(2).
railcars_count(3).
railcars_count(4).
railcars_count(5).
railcars_count(6).

railcars_to_ban(X, 4):- X = "Prague" ; X = "London".
railcars_to_ban(X, 6):- not(X = "Prague" ; X = "Rome").
railcars_to_ban(X, 5):- not(X = "Prague" ; X = "Amsterdam").
railcars_to_ban(X, 3):- X = "Rome".
railcars_to_ban(X, 2):- X = "Helsinki".
% everything that is not prohibited by the rules above:
railcars_to(A, B):- cities(A), railcars_count(B), not(railcars_to_ban(A, B)).

devices_to_ban("London", Y):- not(Y = "I" ; Y = "II").
devices_to_ban("Prague", Y):- not(Y = "I" ; Y = "II").
devices_to_ban(X, "I"):- not(X = "London" ; X = "Prague").
devices_to_ban(X, "II"):- not(X = "London" ; X = "Prague").
devices_to_ban("Rome", Y):- not(Y = "III" ; Y = "IV").
devices_to_ban("Helsinki", Y):- Y = "V".
% everything that is not prohibited by the rules above:
devices_to(A, B):- cities(A), devices(B), not(devices_to_ban(A, B)).

railcars_devices_ban(X, "VI") :- Cond is mod(X, 2), Cond \= 0.
railcars_devices_ban(6, Y):- not(Y = "I" ; Y = "III" ; Y = "V" ; Y = "VI").
railcars_devices_ban(4, Y):- not(Y = "I" ; Y = "II" ; Y = "III").
railcars_devices_ban(X, "IV"):- X < 2.
% everything that is not prohibited by the rules above:
railcars_devices(A, B):- railcars_count(A), devices(B), not(railcars_devices_ban(A, B)).

unique_entities(A, B, C, D, E, F):-
    not(A=B),not(A=C),not(A=D),not(A=E),not(A=F),
    not(B=C),not(B=D),not(B=E),not(B=F),
    not(C=D),not(C=E),not(C=F),
    not(D=E),not(D=F),
    not(E=F)
.

unique_base_case(A, B, C, D, E, F, Aord, Bord, Cord, Dord, Eord, Ford, Ac, Bc, Cc, Dc, Ec, Fc):-
    cities(A),
    cities(B),
    cities(C),
    cities(D),
    cities(E),
    cities(F),
    unique_entities(A, B, C, D, E, F),
    A = "London", B = "Prague", C = "Rome", D = "Amsterdam", E = "Sofia", F = "Helsinki",
    devices(Aord),
    devices(Bord),
    devices(Cord),
    devices(Dord),
    devices(Eord),
    devices(Ford),
    unique_entities(Aord, Bord, Cord, Dord, Eord, Ford),
    railcars_count(Ac),
    railcars_count(Bc),
    railcars_count(Cc),
    railcars_count(Dc),
    railcars_count(Ec),
    railcars_count(Fc),
    unique_entities(Ac, Bc, Cc, Dc, Ec, Fc),

    railcars_to(A,Ac),
    railcars_to(B,Bc),
    railcars_to(C,Cc),
    railcars_to(D,Dc),
    railcars_to(E,Ec),
    railcars_to(F,Fc),
    devices_to(A,Aord),
    devices_to(B,Bord),
    devices_to(C,Cord),
    devices_to(D,Dord),
    devices_to(E,Eord),
    devices_to(F,Ford),
    railcars_devices(Ac,Aord),
    railcars_devices(Bc,Bord),
    railcars_devices(Cc,Cord),
    railcars_devices(Dc,Dord),
    railcars_devices(Ec,Eord),
    railcars_devices(Fc,Ford)
.