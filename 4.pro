#! /usr/bin/prolog -s !#

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

%Правило:
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
