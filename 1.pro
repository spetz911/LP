#! /usr/bin/prolog -s !#

% The length predicate
length1([],0).
length1([_|Tail],Length) :- length1(Tail,TLen), Length is TLen + 1.

% The member predicate
member1(X, [X|_]).       
member1(X, [_|Tail]) :- member1(X, Tail).

% The append predicate
append1([], Ys, Ys).
append1([X|Xs], Ys, [X|Zs]) :- append1(Xs, Ys, Zs).

% The remove predicate(var13)
remove1(X, [X|T], T).
remove1(X, [H|T], [H|S]):- remove1(X, T, S).

% The permutaton predicate
permute1([], []).
permute1([H|T], R):- permute1(T, X), remove1(H,R,X).

% The sublist\2 predicate
sublist1(P, Text) :- append(Zs, _, Text),append(_, P, Zs).

prefix(P,L):-append(P,_,L).
suffix(S,L):-append(_,S,L).
sublist2(S,L):-prefix(P,L),suffix(S,P).

% The last predicate (var1)
last1(List, Last) :- append(_, [Last], List).

last2([Last|[]], Last).
last2([_|Tail], Last) :- last2(Tail, Last).

% remove last(var2)
last_rm(List2,List) :- append(List, [_], List2).

% The split predicate
split1(List, P, Left, Right) :- append1(Left, [P|Right], List).

% The cycle predicate(var20)
cycle([],[]).
cycle([H|T], List2) :- append(T, [H], List2).

% The head predicate(var8)
head(_,0,[]).
head([],_,[]).
head([H|T], N, [H|T2]):- head(T,N1,T2), N is N1 + 1.

% The reverse predicate(var3)
revappend([], Ys, Ys).
revappend([X|Xs], Ys, Zs) :- revappend(Xs, [X|Ys], Zs).
reverse1(Xs,Ys) :- revappend(Xs,[],Ys).

push1([], A, [A]).
push1([H|T], D, [H|T2]):- push1(T, D, T2).

reverse2([],[]).
reverse2([X|Xs],YsX) :- reverse2(Xs,Ys), push1(Ys, X, YsX).


% reverse order
reversep(X,Z) :- reverse(X,Y), rev1(X,Y,Z).
rev1([],[],[]).
rev1([(X1,_)|Xs],[(_,I2)|Ys],ZsX) :- rev1(Xs,Ys,Zs), push1(Zs, (X1,I2), ZsX).


% The max predicate(var3)
max([H|List], Elem):- max(List, H, Elem).
max([], Elem, Elem).
max([H|T], Z, Elem):- H<Z,!, max(T, Z, Elem).
max([H|T], Z, Elem):- H>=Z, max(T, H, Elem).

% max order
maxp([H|List],I):- mp(List,H,I).
mp([(H,N)|T], (Z,_), Elem):- (H>Z),!, mp(T, (H,N), Elem).
mp([(H,_)|T], (Z,I), Elem):- (H=<Z),!, mp(T, (Z,I), Elem).
mp(_, (_,I), I).


:-op(229,xfx,'==>').

taste_me(A1 ==> X1, A2==>X2, A3==>X3, A4==>X4 ) :- write('testing...'),
	A1 = [1,2,3,4,5,6,7],
	A2 = [(a,1),(c,3),(e,6),(f,7)],
	A3 = [1,2,3,7,5,6,4],
	A4 = [(11,1),(19,3),(13,6)],
% 	write('Reverse list'),
	reverse2(A1, X1),
% 	write('Reverse order list'),
	reversep(A2, X2),
% 	write('Max elem'),
	max(A3, X3),
% 	write('Max elem of order list'),
	reverse2(A4, X4).
	