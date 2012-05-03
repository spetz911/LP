% #! /usr/bin/prolog -s !#

% �������� �������� ������� ��� ����

%move(X, Y):- door(X,Y)

% 1 �������� ������ � �������
% 2 �������� ������ � ������
% 3 � ������������ �����������
% *����� �� ������������ ������ ������ �� ������ � �������

% ������ � ������ - ������ � �������, �������� ����� ���������� ��� ���� ������������������� move... ������� ������ � ��������� �����

% ��������� ����� ���������� chronometer
%?- T1 is chronometer(),%
%	p1(X), T2 is chronometer()%
%		T is T2 - T1
% �������� ��������
% ������������� ��������� �������, �������� �������� move �� ������ ���������


% there is 2*n wagon, black and white
%start(X) :- L = [b,w,b,w,b,w], S = [], R = [], X = [L,S,R].

start4([L,S,R]) :- L = [w,w,b,b,b,w,w], S = [], R = [].
start2([L,S,R]) :- L = [b,w,w], S = [], R = [].

reverse2([],[]).
reverse2([X|Xs],YsX) :- reverse2(Xs,Ys), push1(Ys, X, YsX).


empty([]).
test([_|[]]):-!.
test([X|[Y|Rest]]) :- not(X = Y), test([Y|Rest]).

% final([Left, Stack, Right]) :- empty(Stack), empty(Left), test(Right).



head([], _).
head([X|[]], X).
head([X|_], X).

% move([[H|Left], Stack, Right], [Left, Stack, [H|Right]]).
% move([[H|Left], Stack, Right], [Left, [H|Stack], Right]).
% move([Left, [H|Stack], Right], [Left, Stack, [H|Right]]).

% �������� �������� ������� ��� ����
door(b, c).
door(a, b).
door(a, e).
door(c, d).
door(c, f).
door(f, e).
door(e, r).
door(r, z).
door(f, z).

% move(X, Y):- door(X,Y).



%%================================================================================
%    LOOK HERE!!!
%%================================================================================

final(S) :- finish_vi(S).

start_vi([[m,m,m], [k,k,k], [], []]).

finish_vi([[], [k], [m,m,m], [k,k]]).

boost([_,_,_,Rk1], [_,_,_,Rk2]) :-
	length(Rk1, N1),
	length(Rk2, N2),
	N2 >= N1.

test_land([Lm, Lk, Rm, Rk]) :-
	length(Lm, L1),
	length(Lk, L2),
	length(Rm, R1),
	length(Rk, R2),
	test_num(L1, L2, R1, R2).

test_num(0, _, 0, _).

test_num(0, _, R1, R2) :-
	R1 >= R2.

test_num(L1, L2, 0, _) :-
	L1 >= L2.

test_num(L1, L2, R1, R2) :-
	L1 >= L2,
	R1 >= R2.

ship_left(S1, S2) :- ship_right(S2, S1).

ship_right([[M|Lm], [K|Lk], Rm, Rk], S2) :-
      S2 = [Lm, Lk, [M|Rm], [K|Rk]],		test_land(S2).

ship_right([[M1,M2|Lm], [K|Lk], Rm, Rk], S2) :-
      S2 = [Lm, Lk, [M1,M2|Rm], [K|Rk]],	test_land(S2).

ship_right([[M|Lm], Lk, Rm, Rk], S2) :-
      S2 = [Lm, Lk, [M|Rm], Rk],		test_land(S2).

ship_right([[M1,M2|Lm], Lk, Rm, Rk], S2) :-
      S2 = [Lm, Lk, [M1,M2|Rm], Rk],		test_land(S2).

ship_right([[M1,M2,M3|Lm], Lk, Rm, Rk], S2) :-
      S2 = [Lm, Lk, [M1,M2,M3|Rm], Rk],		test_land(S2).

move(S1, S2) :- ship_right(S1, S0), ship_left(S0, S2), S1 \= S2, boost(S1, S2).


%%================================================================================
%    END_OF_LOOK
%%================================================================================



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

d3(Path) :- start_vi(S), dpth([S], Path).
b3(Path) :- start_vi(S), bdth([[S]], Path).
i3(Path) :- start_vi(S), search_iter(S, Path).

% reverse(Path, X).
%  Path = [X|_]

% may_be add ������������� ������ ��������

taste_dfs(X) :- d3(X),!, show_answer(X).
taste_bfs(X) :- b3(X),!, show_answer(X).
taste_iter(X) :- i3(X),!, show_answer(X).
