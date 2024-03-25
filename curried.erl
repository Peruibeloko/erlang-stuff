-module(curried).
-compile(export_all).

merge_sort([Xs], Callback) ->
    Callback([Xs]);
merge_sort([], Callback) ->
    Callback([]);
merge_sort(Xs, Callback) ->
    {L, R} = lists:split(length(Xs) div 2, Xs),
    merge_sort(R, merge_sort(L, curried_merge(Callback))).

merge(Xs, []) -> Xs;
merge([], Xs) -> Xs;
merge(L, R) when hd(L) > hd(R) -> [hd(R) | merge(L, tl(R))];
merge(L, R) -> [hd(L) | merge(tl(L), R)].

curried_merge(Callback) ->
    fun(L) ->
        fun(R) ->
            Callback(merge(L, R))
        end
    end.

main() ->
    Src = [1, 9, 7, 3, 5, 4, 8],
    io:format("input: ~w~n", [Src]),
    Callback = fun(Result) -> io:format("output: ~w~n", [Result]) end,
    merge_sort(Src, Callback).
