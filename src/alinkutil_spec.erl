%%%-------------------------------------------------------------------
%%% @author yqfclid
%%% @copyright (C) 2022
%%% @doc
%%%
%%% @end
%%% Created : 25. 6月 2022 下午4:48
%%%-------------------------------------------------------------------
-module(alinkutil_spec).
-author("yqfclid").

%% API
-export([
    child_spec/2,
    child_spec/3,
    child_spec/4
]).

%%%===================================================================
%%% API
%%%===================================================================
-spec(child_spec(Mod :: atom(),
    WorkerType :: worker | supervisor) -> supervisor:child_spec()).
child_spec(Mod, WorkerType) ->
    child_spec(Mod, permanent, WorkerType, []).

-spec(child_spec(Mod :: atom(),
    WorkerType :: worker | supervisor,
    Args :: list()) -> supervisor:child_spec()).
child_spec(Mod, WorkerType, Args) ->
    child_spec(Mod, permanent, WorkerType, Args).


-spec(child_spec(Mod :: atom(),
    Strategy :: permanent | transient | temporary,
    WorkerType :: worker | supervisor,
    Args :: list()) -> supervisor:child_spec()).
child_spec(Mod, Strategy, WorkerType, Args) ->
    IsLegal0 = lists:member(WorkerType, [worker, supervisor]),
    IsLegal1 = lists:member(Strategy, [permanent, transient, temporary]),
    case IsLegal0 andalso IsLegal1 of
        true ->
            #{id => Mod,
                start => {Mod, start_link, Args},
                restart => Strategy,
                shutdown => infinity,
                type => WorkerType,
                modules => [Mod]
            };
        false ->
            erlang:error(bad_arg)
    end.

%%%===================================================================
%%% Application callbacks
%%%===================================================================