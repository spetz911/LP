#! /usr/bin/prolog -s !#

% standart predicate
member(X, [X|_]).
member(X, [_|T]):- member(X, T).

remove(D,[D|T],T).
remove(D,[H|T],[H|X]):-remove(D,T,X).

permute([],[]).
permute(L, [H|T]):- remove(H,L,L1), permute(L1,T).

%--------------------------------------------------

people(X):-
	X = [alexeev, borisov, konstan, dmitriev].
books(Y):-
	Y = [astronom, poet, proza, drama].

solList(X):-
	books(Y),
	permute(Y , X).

written(A,B,C) :- zzz(A,B,C).
reading(A,B,C) :- zzz(A,B,C).
has(A,B,C) :- zzz(A,B,C).

zzz(alexeev, X, [X,_,_,_]).
zzz(borisov, X, [_,X,_,_]).
zzz(konstan, X, [_,_,X,_]).
zzz(dmitriev, X, [_,_,_,X]).

test2(A,Sw,Sr,Sh) :-
    written(A, X,Sw), not(reading(A,X,Sr)), not(has(A,X,Sh)).

test(Sw,Sr,Sh) :-
    not(written(dmitriev, proza,Sw)),
    reading(alexeev, X1,Sr), has(borisov, X1,Sh),
    reading(borisov, X2,Sr), has(alexeev, X2,Sh),
    has(borisov, X3,Sh), written(dmitriev,X3,Sw),
    written(X4, poet,Sw), reading(X4, drama,Sr),

    written(X5, proza,Sw),
    not(reading(X5, astronom,Sr)),
    not(has(X5, astronom,Sh)).

findSol(X) :- 
	people(Y),
	solList(Sw),
	solList(Sr),
	solList(Sh),

	test(Sw,Sr,Sh),
	
	test2(alexeev,Sw,Sr,Sh),
	test2(borisov,Sw,Sr,Sh),
	test2(dmitriev,Sw,Sr,Sh),
	test2(konstan,Sw,Sr,Sh),
	
	write('HERE answer:\n'),
	write(Y),
	write(' who\n'),
	write(Sw),
	write(' write\n'),
	write(Sr),
	write(' read\n'),
	write(Sh),
	write(' have\n'),
	X = (Y,Sw,Sr,Sh).

f(X) :- findSol(X).