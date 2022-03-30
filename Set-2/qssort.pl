
final(state(Queue, [], Moves)) :- isOrdered(Queue).


isOrdered( [] ) .
isOrdered( [_] ) .
isOrdered( [X,Y|Z] ) :- X =< Y , isOrdered( [Y|Z] ) .

popQueue([H|T], H, T).

popStack([Item|Stack], Item, Stack).

count(_, [], 0).
count(X, [X | T], N) :-
  !, count(X, T, N1),
  N is N1 + 1.
count(X, [_ | T], N) :-
  count(X, T, N).


check(Letter, state(Q, S, Moves), Size) :-
    count(Letter, Moves, Occurences),
    HalfLength is Size / 2,
    HalfLength >= Occurences
.


move(state(Queue, Stack, Moves), q, state(NewQueue, NewStack, NewMoves)) :-
    popQueue(Queue, Popped, NewQueue),
    append([Popped], Stack, NewStack),
    append(Moves, ['Q'], NewMoves)
    . 

move(state(Queue, Stack, Moves), s, state(NewQueue, NewStack, NewMoves)) :-
    popStack(Stack, Popped, NewStack),
    append(Queue, [Popped], NewQueue),
    append(Moves, ['S'], NewMoves)
    . 


/* solve(+Conf, ?Moves) */
solve(State, [],  Size) :- final(State).
solve(State, [Move|Moves],  Size) :-              
    check('Q', State, Size),
    check('S', State, Size),
    move(State, Move, State1),   
    solve(State1, Moves, Size).


checkMod2(Num) :-
    0 is mod(Num, 2).


len(List, Length) :-
    length(List, Length),
    checkMod2(Length)
    .


/* solve(-Moves) */
solveMain(UpperMovesString, C) :-
    len(Moves, _),
    length(Moves, Length),
    solve(state(C, [], []), Moves, Length),
    atomics_to_string(Moves, MovesString),
    string_upper(MovesString, UpperMovesString).


qssort(File, Moves) :- 
    read_input(File, N, C),
    ( isOrdered(C) -> Moves = "empty" ; once(solveMain(Moves, C)) )
    .
    
read_input(File, N, C) :-
    open(File, read, Stream),
    read_line(Stream, [N]),
    read_line(Stream, C).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).
