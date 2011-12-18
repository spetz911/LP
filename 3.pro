#! /usr/bin/prolog -s !#

% лабиринт задается дверьми как граф

%move(X, Y):- door(X,Y)

% 1 предикат поиска в глубину
% 2 предикат поиска в ширину
% 3 с итерационным заглубением
% *когда на определенном уровне срезка на поиске в глубину

% задача с шарами - решать в глубину, написать время выполнения для всех последовательностей move... описать ошибку с нехваткой стека

% посчитать время выполнения chronometer
%?- T1 is chronometer(),%
%	p1(X), T2 is chronometer()%
%		T is T2 - T1
% Оформить табличку
% формализовать состояние системы, написать предикат move из разных состояний


% there is 2*n wagon, black and white
%start(X) :- L = [b,w,b,w,b,w], S = [], R = [], X = [L,S,R].

start([L,S,R]) :- L = [w,w,b,b,b,w,w], S = [], R = [].
start2([L,S,R]) :- L = [b,w,w], S = [], R = [].

reverse2([],[]).
reverse2([X|Xs],YsX) :- reverse2(Xs,Ys), push1(Ys, X, YsX).


empty([]).
test([_|[]]):-!.
test([X|[Y|Rest]]) :- not(X = Y), test([Y|Rest]).

final([Left, Stack, Right]) :- empty(Stack), empty(Left), test(Right).


head([], _).
head([X|[]], X).
head([X|_], X).

move([[H|Left], Stack, Right], [Left, Stack, [H|Right]]).
move([[H|Left], Stack, Right], [Left, [H|Stack], Right]).
move([Left, [H|Stack], Right], [Left, Stack, [H|Right]]).

% лабиринт задается дверьми как граф
door(b, c).
door(a, b).
door(a, e).
door(c, d).
door(c, f).
door(f, e).
door(e, r).
door(r, z).
door(f, z).
; move(X, Y):- door(X,Y).


show_answer([_]):-!.
show_answer([A,B|Tail]):-
        show_answer([B|Tail]),nl,write(B),write(' -> '),write(A).


final1(X) :- X == z.


dfs(S,S, [S]).
dfs(S,F, [S|Tail]) :- move(S, S2), dfs(S2, F, Tail).


% DFS, Depth-first search
prolong([Temp|Tail],[New,Temp|Tail]):-
        move(Temp,New),not(member(New,[Temp|Tail])).

dpth([Finish|Tail],[Finish|Tail]) :- final(Finish).
dpth(TempWay,Way):-
        prolong(TempWay,NewWay),
        dpth(NewWay,Way).

% BFS, Breadth-first search
bdth([[Finish|Tail]|_],[Finish|Tail]) :- final(Finish).
bdth([TempWay|OtherWays],Way):-
        findall(W,prolong(TempWay,W),Ways),
        append(OtherWays,Ways,NewWays),
        bdth(NewWays,Way).

% Iter
int(1).
int(N):-int(M),N is M+1.
 
search_iter(Start, Way):- int(Lev),(Lev>100,!;id([Start],Way,Lev)).

id([Finish|Tail],[Finish|Tail],0) :- final(Finish).
id(TempWay,Way,N):-N>0,
        prolong(TempWay,NewWay),N1 is N-1,
        id(NewWay,Way,N1).


d(X) :- start2(S),dpth([S], Path),  Path = [X|_].
b(X) :- start2(S),bdth([[S]], Path),  Path = [X|_].
i(X) :- start2(S),search_iter(S, Path),  Path = [X|_].

d2(Path) :- start(S),dpth([S], Path).
b2(Path) :- start(S),bdth([[S]], Path).
i2(Path) :- start(S),search_iter(S, Path).

% reverse(Path, X).
%  Path = [X|_]

% may_be add эвристический жадный алгоритм

taste_dfs(X) :- d2(X),!, show_answer(X).
taste_bfs(X) :- b2(X),!, show_answer(X).
taste_iter(X) :- i2(X),!, show_answer(X).
