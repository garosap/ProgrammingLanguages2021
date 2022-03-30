longest(File, MaxDiff):-
    read_input(File, M, N, C),
    solve(C, M, N, MaxDiff).

solve([H|T], M, N, MaxDiff):-
    newList([H|T], New, N),
    summary(New, 0, 0, [HSum|TSum], A),
    lmin([HSum|TSum], Lmin, HSum),
    reverse([HSum|TSum], [H2|T2]),
    findRmax([H2|T2], K, H2),
    reverse(K, Rmax),
    compare(Lmin, Rmax, 0, M, 0, 0, Maxdiff2),
    MaxDiff is max(Maxdiff2, A).

newList([],[], _).
newList([H|T], [HNew|TNew], N):-
    HNew is -N-H,
    newList(T, TNew, N).

summary([], Index, Sum, [], A):-
    Sum >= 0 -> A = Index ;
    A = 0.
summary([H|T], Index, Sum, [HSum|TSum], A):-
    HSum is H + Sum,
    IndexNew is Index + 1,
    summary(T, IndexNew, HSum, TSum, A).

lmin([], [], _).
lmin([H|T], [HLmin|TLmin], Min):-
    H < Min -> HLmin is H, lmin(T, TLmin, HLmin) ;
    HLmin is Min, lmin(T, TLmin, Min).

findRmax([], [], _).
findRmax([H|T], [HRmax|TRmax], Max):-
    H > Max -> HRmax is H, findRmax(T, TRmax, H) ;
    HRmax is Max, findRmax(T, TRmax, Max).

compare(_, _, Maxdiff2, M, M, _, Y):-
    Y is Maxdiff2.
compare(_, _, Maxdiff2, M, _, M, Y):-
    Y is Maxdiff2.
compare([HLmin|TLmin], [HRmax|TRmax], Maxdiff2, M, I, J, Y):-
    HLmin =< HRmax -> 
    (Newmaxdiff is max(Maxdiff2, J-I),
    NewJ is J+1,
    compare([HLmin|TLmin], TRmax, Newmaxdiff, M, I, NewJ, Y)
    ) ;
    (NewI is I+1,
    compare(TLmin, [HRmax|TRmax], Maxdiff2, M, NewI, J, Y)
    ).

read_input(File, M, N, C):-
    open(File, read, Stream),
    read_line(Stream, [M, N]),
    read_line(Stream, C).

read_line(Stream, L):-
    read_line_to_codes(Stream , Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).
