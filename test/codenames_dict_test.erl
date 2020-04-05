-module(codenames_dict_test).

-include_lib("eunit/include/eunit.hrl").

-define(SEED, 12345).

filepath_from_lang_test() ->
    ?assertEqual(
        code:priv_dir(codenames_dict) ++ "/srp.txt",
        codenames_dict:filename_by_lang("srp")
    ).

shuffle_list_num_test() ->
    OriginalList = [1, 2, 3, 4, 5],
    %% Seeding with ?SEED produces this specific order
    rand:seed(exsss, ?SEED),
    MockedResult = [3, 4, 2, 1, 5],
    ?assertEqual(MockedResult, codenames_dict:shuffle_list(OriginalList)).

shuffle_list_words_test() ->
    OriginalList = ["alpha", "beta", "gamma", "delta", "epsilon"],
    %% Seeding with ?SEED produces this specific order
    rand:seed(exsss, ?SEED),
    MockedResult = ["gamma", "delta", "beta", "alpha", "epsilon"],
    ?assertEqual(MockedResult, codenames_dict:shuffle_list(OriginalList)).
