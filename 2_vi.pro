#! /usr/bin/swipl -s !#

people(X):-
       X = [leonid, michael, nikolay, oleg, petr].
surname(Y):-
       Y = [atarov, bartenev, klenov, danilin, ivanov].

get_friends(X, Name, Solve) :-
       people(Tmp),
       nth0(Pos, Tmp, Name),
       nth0(Pos, Solve, X).

count(Name, Res, Solve) :-
       get_friends(Friends, Name, Solve),
       length(Friends, Res).

know(Name1, Name2, Solve) :-
       get_friends(Friends1, Name1, Solve),
       get_friends(Friends2, Name2, Solve),
       member(Name2, Friends1),
       member(Name1, Friends2).

combinations(_,[]).
combinations([X|T],[X|Comb]) :- combinations(T,Comb).
combinations([_|T],[X|Comb]) :- combinations(T,[X|Comb]).


speedup(Who) :-
       [Atarov, Bartenev, Klenov, Danilin, Ivanov] = Who,

%       Klenov \= nikolay,
%       Klenov \= oleg,
%       Klenov \= michael,
%       Klenov \= petr,

       % =>
       Klenov == leonid,

       Ivanov \= nikolay,
       Danilin \= michael,
       Bartenev \= petr.


test(Who, Solve) :-
       [Atarov, Bartenev, Klenov, Danilin, Ivanov] = Who,

       count(Bartenev, 2, Solve),
       count(petr,     3, Solve),
       count(leonid,   1, Solve),
       not(know(Danilin, michael, Solve)),
       know(nikolay, Ivanov, Solve),

       know(nikolay, michael, Solve),
       know(nikolay, oleg, Solve),
       know(michael, oleg, Solve),

       count(Atarov,   3, Solve),
       count(Klenov,   1, Solve),
       true.




oneSolution(Res, Man) :-
       people(P0),
       delete(P0, Man, P1),
       combinations(P1, Res).

run(X) :-
       people(S0),
       permutation(S0, WhoIsWho),

       speedup(WhoIsWho),

       people([X1,X2,X3,X4,X5]),

       oneSolution(R1, X1),
%       length(R1, 1), % leonide
%       write(R1),
%       write('\n'),

       oneSolution(R5, X5), % petr
%       length(R5, 3),

       oneSolution(R2, X2), % michael
%       member(oleg, R2),
%       member(nikolay, R2),

       oneSolution(R3, X3), % nikolay
%       member(oleg, R3),
%       member(michael, R3),

       oneSolution(R4, X4), % oleg
%       member(michael, R4),
%       member(nikolay, R4),

       [Tmp] = R1,
       [M1, M2, M3] = R5,

		Solve = [R1, R2, R3, R4, R5],


        test(WhoIsWho, Solve),
        foreach(R1, X1, Solve),
        foreach(R2, X2, Solve),
        foreach(R3, X3, Solve),
		foreach(R4, X4, Solve),
		foreach(R5, X5, Solve),

       write('SOLVE:\n'),
       write([R1, R2, R3, R4, R5]),
       write('\n'),

       X = WhoIsWho.
       
foreach([],_,_) :- true.
foreach([H|T], Arg, Solve) :- know(H, Arg, Solve), foreach(T, Arg, Solve).



