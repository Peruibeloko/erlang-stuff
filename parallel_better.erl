-module(parallel_better).
-compile(export_all).

merge_sort([Xs], Return_pid) ->
    Return_pid ! [Xs];
merge_sort([], Return_pid) ->
    Return_pid ! [];
merge_sort(Xs, Return_pid) ->
    {L, R} = lists:split(length(Xs) div 2, Xs),

    Sort_pid = self(),
    merge_sort(L, spawn(fun() -> receive L_out ->
        merge_sort(R, spawn(fun() -> receive R_out ->
            Sort_pid ! {L_out, R_out}
        end end))
    end end)),

    receive
        {L_out, R_out} -> Return_pid ! merge(L_out, R_out)
    end.

merge(Xs, []) -> Xs;
merge([], Xs) -> Xs;
merge(L, R) when hd(L) > hd(R) -> [hd(R) | merge(L, tl(R))];
merge(L, R) -> [hd(L) | merge(tl(L), R)].

main() ->
    Src = [1, 9, 7, 3, 5, 4, 8],
    io:format("input: ~w~n", [Src]),
    spawn(parallel, merge_sort, [Src, self()]),
    receive
        Result -> io:format("output: ~w~n", [Result])
    end.
