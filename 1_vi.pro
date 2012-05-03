test(X) :- once(member(X, [1,2,3])).

foreach([]) :- true.
foreach([H|T]) :- test(H), foreach(T).

forany([]) :- false.
forany([H|T]) :- once(test(H); foreach(T)).


run(X) :- true.
