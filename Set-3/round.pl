round(File, M, C):-
    read_input(File, Cities, Cars, InitialState),
    msort(InitialState, SortedInitialState),
    finalConvert(SortedInitialState, Cities,  [FinalCityListHead|Tail]),
    calcSumMax(InitialState, 0, 0, 0, Cities, [InitialSum, InitialMax, InitialCity]),
    filterOutZeros( [FinalCityListHead|Tail], FilteredCityList),
    initialiseFilterCityPosition(1, FilteredCityList, StartingFilteredCity),
    once(solve(Tail, 1, StartingFilteredCity, FilteredCityList, InitialSum, InitialMax, InitialCity, InitialSum, Cities, Cars, (M, C)))
    .


read_input(File, M, N, C):-
    open(File, read, Stream),
    read_line(Stream, [M, N]),
    read_line(Stream, C).

read_line(Stream, L):-
    read_line_to_codes(Stream , Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).


finalConvert([Head|Tail], Length, Result) :-
    once(convertList([Head|Tail], Length, Res)),
    fill0(-1, Head, Res, Result).

convertList([A], Length, [1|Tail]) :- fill0(A, Length, [], Tail). 

convertList([H1|[H2|T]], Length, Result) :- 
    convertList([H2|T], Length, [Head|Tail]),
    (
        H1 = H2 -> Temp is Head + 1,
        Result = [Temp|Tail]
        ; fill0(H1, H2, [Head|Tail], Res),
        Result = [1|Res]

    ).


fill0( A, B, List, Result) :- 
    (
        A =:= B - 1  -> Result = List
        ; Temp is B - 1,
        fill0( A, Temp, [0|List], Result)
    ).


calcDistance(Source, Destination, CityCount, Distance) :- 
    (  
        Source =< Destination -> Distance is Destination - Source
        ; Distance is CityCount - Source + Destination
    ).


calcSumMax([], Sum, Max, City, CityCount, [Sum, Max, City]).  

calcSumMax([H|T], Sum, Max, City, CityCount, Result) :- 
    calcDistance(H, City, CityCount, Distance), 
    SumNew is (Sum + Distance), 
    MaxNew is max(Distance, Max), 
    calcSumMax(T, SumNew, MaxNew, City, CityCount, Result).

delete([], _,[]).
delete([0|T], I, L) :- NewI is I + 1, delete(T, NewI, L).
delete([H|T], I, [(I, H)|T2]) :- NewI is I + 1, delete(T, NewI, T2).

% Creates list of tuples (index, value) of non zero values
filterOutZeros(List, Filtered) :- once(delete(List, 0, Filtered)).


checkValid(Sum, Max, Result) :-
    Temp is Max - (Sum - Max),
    (
        Temp =< 1  -> Result = true 
        ; Result = false
    ).

initialiseFilterCityPosition(Index, [(I, H)|T], FinalList) :- 
    (
        Index >= I ->  initialiseFilterCityPosition(Index, T, FinalList)
        ; FinalList = [(I, H)|T]
    ).

checkSwitch(SumNew, SumOld, Res) :- 
    (
        SumOld > -1 -> (
            SumNew < SumOld -> Res = true
            ;Res = false
        )
        ;Res = true
    ).    

solve([], _, _, Backup, Sum, Max, City, SumRes, CityCount, CarCount, (SumRes, City)). 

solve([H1|T1], Index, [], Backup, Sum, Max, City, SumRes, CityCount, CarCount, Result) :- solve([H1|T1], Index, Backup, Backup, Sum, Max, City, SumRes, CityCount, CarCount, Result).

solve([H1|T1], Index, [(I, H)|T], Backup, Sum, Max, City, SumRes, CityCount, CarCount, Result) :- 
    (
        Index = I -> solve([H1|T1], Index, T, Backup, Sum, Max, City, SumRes, CityCount, CarCount, Result)
        ; NewIndex is Index + 1,
        calcDistance(I, Index, CityCount, MaxDistance),
        NewSum is Sum + CarCount - CityCount*H1,
        checkValid(NewSum, MaxDistance, IsValid),
        (
            IsValid = true -> checkSwitch(NewSum, SumRes, IsSwitch),
                (
                    IsSwitch = true -> solve(T1, NewIndex, [(I, H)|T], Backup, NewSum, MaxDistance, Index, NewSum, CityCount, CarCount, Result)
                    ;solve(T1, NewIndex, [(I, H)|T], Backup, NewSum, Max, City, SumRes, CityCount, CarCount, Result)
                )
            ; solve(T1, NewIndex, [(I, H)|T], Backup, NewSum, Max, City, SumRes, CityCount, CarCount, Result)
        )

    ).    