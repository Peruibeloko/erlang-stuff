-module(sorting).
-compile(export_all).

merge_sort([Xs]) ->
    [Xs];
merge_sort([]) ->
    [];
merge_sort(Xs) ->
    {L, R} = lists:split(length(Xs) div 2, Xs),
    merge(merge_sort(L), merge_sort(R)).

merge(Xs, []) -> Xs;
merge([], Xs) -> Xs;
merge(L, R) when hd(L) > hd(R) -> [hd(R) | merge(L, tl(R))];
merge(L, R) -> [hd(L) | merge(tl(L), R)].

main() ->
    Src = [1, 9, 7, 3, 5, 4, 8],
    io:format("input: ~w~n", [Src]),
    Result = merge_sort(Src),
    io:format("output: ~w~n", [Result]).
