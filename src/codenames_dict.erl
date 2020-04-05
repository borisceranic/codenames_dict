-module(codenames_dict).
-import(file, [read_file/1]).

-export([
    get_words_from_default_dict/1,
    get_words_from_dict/2,
    get_lang_word_list/1,
    get_num_random_words_from_list/2,
    filename_by_lang/1,
    take_random/2,
    shuffle_list/1]).

-define(DEFAULT_LANG, "srp").

-spec get_words_from_default_dict(number()) -> list(unicode:chardata()).
get_words_from_default_dict(WordCount) ->
    get_words_from_dict(WordCount, ?DEFAULT_LANG).

-spec get_words_from_dict(number(), unicode:chardata()) -> list(unicode:chardata()).
get_words_from_dict(WordCount, Lang) ->
    Dict = get_lang_word_list(Lang),
    get_num_random_words_from_list(Dict, WordCount).

-spec get_lang_word_list(unicode:chardata()) -> list().
get_lang_word_list(Language) ->
    FileName = filename_by_lang(Language),
    terms_from_file(FileName).

-spec get_num_random_words_from_list(list(), number()) -> list().
get_num_random_words_from_list(List, Count) when erlang:is_list(List), erlang:length(List) >= Count ->
    take_random(shuffle_list(List), Count).

-spec filename_by_lang(unicode:chardata()) -> unicode:chardata().
filename_by_lang(Language) ->
    code:priv_dir(codenames_dict) ++ "/" ++ Language ++ ".txt".

-spec take_random(list(), number()) -> list().
take_random(List, Count) when erlang:is_list(List), erlang:length(List) >= Count ->
    lists:sublist(List, Count).

-spec shuffle_list(list()) -> list().
shuffle_list([]) ->
    [];
shuffle_list(List1) when erlang:is_list(List1), erlang:length(List1) > 0 ->
    [Y || {_, Y} <- lists:sort([{rand:uniform(), N} || N <- List1])].

-spec terms_from_file(unicode:chardata()) -> list(unicode:chardata()).
terms_from_file(FileName) when erlang:is_list(FileName), erlang:length(FileName) > 0 ->
    case file:consult(FileName) of
        {ok, Words} ->
            lists:filtermap(
                fun(Word) ->
                    TrimmedWord = string:trim(Word),
                    case string:is_empty(TrimmedWord) of
                        false -> {true, TrimmedWord};
                        true -> false
                    end
                end, Words);
        Error -> throw(Error)
    end.
