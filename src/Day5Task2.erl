-module('Day5Task2').
-export([main/0]).

threeArgOp(Mode, PC, Memory) ->
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
    {C, ValueA, ValueB} = threeArgOp(Mode, PC, Memory),
    ValueC = ValueA + ValueB,
    NewMemory = array:set(C, ValueC, Memory),
    {NewMemory, PC + 4}.

mulOp(Mode, PC, Memory) ->
    {C, ValueA, ValueB} = threeArgOp(Mode, PC, Memory),
    ValueC = ValueA * ValueB,
    NewMemory = array:set(C, ValueC, Memory),
    {NewMemory, PC + 4}.

readOp(PC, Memory) ->
    Dest = array:get(PC + 1, Memory),
    Value = 5,
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

twoArgOp(Mode, PC, Memory) ->
    A = array:get(PC + 1, Memory),
    B = array:get(PC + 2, Memory),
    ModeA = Mode rem 10,
    ModeB = Mode div 10,
    Cond = if
        ModeA == 1 ->
            A;
        true ->
            array:get(A, Memory)
    end,
    Loc = if
        ModeB == 1 ->
            B;
        true ->
            array:get(B, Memory)
    end,
    {Cond, Loc}.

jumpIfTrueOp(Mode, PC, Memory) ->
    {Cond, Loc} = twoArgOp(Mode, PC, Memory),
    if
        Cond /= 0 ->
            {Memory, Loc};
        true ->
            {Memory, PC + 3}
    end.

jumpIfFalseOp(Mode, PC, Memory) ->
    {Cond, Loc} = twoArgOp(Mode, PC, Memory),
    if
        Cond == 0 ->
            {Memory, Loc};
        true ->
            {Memory, PC + 3}
    end.

ltOp(Mode, PC, Memory) ->
    {C, ValueA, ValueB} = threeArgOp(Mode, PC, Memory),
    ValueC = if
        ValueA < ValueB ->
            1;
        true ->
            0
    end,
    NewMemory = array:set(C, ValueC, Memory),
    {NewMemory, PC + 4}.

eqOp(Mode, PC, Memory) ->
    {C, ValueA, ValueB} = threeArgOp(Mode, PC, Memory),
    ValueC = if
        ValueA == ValueB ->
            1;
        true ->
            0
    end,
    NewMemory = array:set(C, ValueC, Memory),
    {NewMemory, PC + 4}.

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
        OpCode == 5 ->
            {NewMemory, NewPC} = jumpIfTrueOp(Mode, PC, Memory),
            execProgram(NewPC, NewMemory);
        OpCode == 6 ->
            {NewMemory, NewPC} = jumpIfFalseOp(Mode, PC, Memory),
            execProgram(NewPC, NewMemory);
        OpCode == 7 ->
            {NewMemory, NewPC} = ltOp(Mode, PC, Memory),
            execProgram(NewPC, NewMemory);
        OpCode == 8 ->
            {NewMemory, NewPC} = eqOp(Mode, PC, Memory),
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
    execProgram(0, Memory). 
