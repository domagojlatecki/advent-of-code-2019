-module('Day5Task1').
-export([main/0]).

fourArgOp(Mode, PC, Memory) ->
    A = array:get(PC + 1, Memory),
    B = array:get(PC + 2, Memory),
    C = array:get(PC + 3, Memory),
    ModeA = Mode rem 10,
    ModeB = Mode div 10,
    ValueA = if
        ModeA == 1 ->
            A;
        true ->
            array:get(A, Memory)
    end,
    ValueB = if
        ModeB == 1 ->
            B;
        true ->
            array:get(B, Memory)
    end,
    {C, ValueA, ValueB}.

addOp(Mode, PC, Memory) ->
    {C, ValueA, ValueB} = fourArgOp(Mode, PC, Memory),
    ValueC = ValueA + ValueB,
    NewMemory = array:set(C, ValueC, Memory),
    {NewMemory, PC + 4}.

mulOp(Mode, PC, Memory) ->
    {C, ValueA, ValueB} = fourArgOp(Mode, PC, Memory),
    ValueC = ValueA * ValueB,
    NewMemory = array:set(C, ValueC, Memory),
    {NewMemory, PC + 4}.

readOp(PC, Memory) ->
    Dest = array:get(PC + 1, Memory),
    Value = 1,
    NewMemory = array:set(Dest, Value, Memory),
    {NewMemory, PC + 2}.

writeOp(Mode, PC, Memory) ->
    Value = if
        Mode == 1 ->
            array:get(PC + 1, Memory);
        true ->
            array:get(array:get(PC + 1, Memory), Memory)
    end,
    if
        Value == 0 ->
            {Memory, PC + 2};
        true ->
            io:fwrite("~w~n", [Value]),
            {Memory, PC + 2}
    end.

execProgram(PC, Memory) ->
    Value = array:get(PC, Memory),
    OpCode = Value rem 100,
    Mode = Value div 100,
    if
        OpCode == 1 ->
            {NewMemory, NewPC} = addOp(Mode, PC, Memory),
            execProgram(NewPC, NewMemory);
        OpCode == 2 ->
            {NewMemory, NewPC} = mulOp(Mode, PC, Memory),
            execProgram(NewPC, NewMemory);
        OpCode == 3 ->
            {NewMemory, NewPC} = readOp(PC, Memory),
            execProgram(NewPC, NewMemory);
        OpCode == 4 ->
            {NewMemory, NewPC} = writeOp(Mode, PC, Memory),
            execProgram(NewPC, NewMemory);
        OpCode == 99 ->
            unit;
        true ->
            io:fwrite("Invalid OP code: ~w~n", [OpCode])
    end.

main() ->
    Input = io:get_line(""),
    Memory = array:from_list(
        lists:map(fun(X) -> {Parsed, _} = string:to_integer(X), Parsed end, string:tokens(Input, ","))
    ),
    _ = execProgram(0, Memory). 
