#! /usr/bin/prolog -s !#


%%===============================================================

z(Res) :- cfg_phrase(Res, [sasha, like, apple, not_like, juice]).

% cfg == context-free grammar

cfg_name(sasha).
cfg_name(petia).
cfg_object(apple).
cfg_object(juice).

cfg_object_group(none, []).

cfg_object_group(Res, [Obj|Rest]) :-
	cfg_object(Obj),
	cfg_object_group(Res2, Rest),
	(Res = Obj;
	 Res = Res2),
	Res \= none.

cfg_like_group(none, []).

cfg_like_group(Res, Str) :-
	(Do = like; Do = not_like),
	append([Do|What], Rest, Str),
	cfg_object_group(Obj, What),
	cfg_like_group(Res2, Rest),
	(Res = [[], Do, Obj];
	 Res = Res2),
	Res \= none.


cfg_phrase(Res, [Name|Rest]) :-
	cfg_name(Name),
	cfg_like_group([_,Like,What], Rest),
	Res = [Name, Like, What].

%%======================================================


% debug:

stuff(_).

just_phrase(none, []).

just_phrase(Res, Str) :-
	append([Name | _], Rest, Str),
%	print(Name),
%	print('\n'),
	cfg_name(Name),
	just_phrase(Res2,Rest),
	
	(Res = [Name, like, what];
	 Res = Res2).



t(Res) :-
	cfg_name(Answ),
	(Res = [Answ, like, what];
	 Res = [qq, ww, ee]).




%%======================================================


% f(X, Y) :- simplity(X,Y).

simplity(X,X) :- atomic(X).
simplity(X,Y) :- X=..[Op, A, B],
		simplity(A,U),
		simplity(B,V),
		rule(Op, U, V, Y).

rule(*, _, 0,0).
rule(*, 0, _,0).
rule(+,X,0,X).
rule(+,0,X,X).
rule(*,X,1,X).
rule(*,1,X,X).

rule(+,X,Y,Z) :- number(X),number(Y), Z is X + Y.
rule(*,X,Y,Z) :- number(X),number(Y), Z is X * Y.
rule(^,X,Y,Z) :- number(X),number(Y), pow(X, Y,Z).

% finalize
rule(+,X,Y, X+Y).
rule(*,X,Y, X*Y).
rule('^',X,Y, X'^'Y).

calculate(Expr, Val) :- reverse(Expr, Expr1),
	a_expr(Val, Expr1).
	
a_number(NS, [NS]) :- number(NS).

a_pow(V,T) :- append(N,['^'|A],T),
	(a_pow(Vx,N);a_number(Vx,N)),
	a_number(Vy,A),
	pow(Vy,Vx,V).

a_term(V,T) :- (a_number(V,T); a_pow(V,T)).

a_term(V,T) :- append(X,['*'|Y],T),
	(a_number(Vx,X);a_pow(Vx,X)),
	a_term(Vy,Y),
	V is Vy*Vx.

a_term(V,T) :- append(X, ['/'|Y],T),
	(a_number(Vx,X);a_pow(Vx,X)),
	a_term(Vy,Y),
	V is Vy/Vx.

%�������:
a_expr(V,T) :- a_term(V,T).
a_expr(V,T) :- append(X,['+'|Y],T),
	a_term(Vx, X),
	a_expr(Vy, Y),
	V is Vy + Vx.
	
%may be e_term().
a_expr(V,T) :- append(X,['-'|Y],T),
	a_term(Vx, X),
	a_expr(Vy, Y),
	V is Vy - Vx.

% f(V) :- pars([12,'+',34,'-',5], V).
f(RES) :- calculate([6, '+',3,'*',2, '^',5,'/',4, '-', 1],RES),!.
g(RES) :- simplity(7+13+15*2+3*2*a^b*7,RES),!.
