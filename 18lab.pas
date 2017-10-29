PROGRAM stackOfQueues;
USES CRT;

CONST 
    {отступы, используется в меню}
    FirstLevel = 1;
    SecondLevel = 2;
    ThirdLevel = 4;

TYPE
  Queue = ^Oue; {Очередь}
  Oue = RECORD
       Data : INTEGER;
       Next : Queue;
  END;

TYPE
  Stack = ^ST; {стек, в котором указали на очередь}
  ST = RECORD
       FirstElementQueue: Queue;
       LastElementQueue: Queue;
       Next: Stack;
  END;
  
VAR
    numberMenuItem: INTEGER;
    topStack, itemStack: Stack;
    
{процедуры - функции для работы со списками}
FUNCTION IsLastStackElement(topStack: Stack): BOOLEAN;
BEGIN
    IsLastStackElement := (topStack = Nil);
END;

FUNCTION YesOrNo: BOOLEAN;
VAR 
    Ch: CHAR;
    Flag: BOOLEAN;
BEGIN
    Flag := FALSE;
    REPEAT
    Ch := READKEY;
    IF Ch = #27 {esc}
    THEN
        BEGIN
            YesOrNo := FALSE;
            Flag := TRUE
        END
    ELSE
        IF Ch = #13 {enter}
        THEN
            BEGIN
                YesOrNo := TRUE;
                Flag := TRUE
            END
    UNTIL (Flag);
END;

FUNCTION IsPositiveNumber(VAR outp: TEXT; incomingNum: INTEGER): BOOLEAN;
BEGIN
    IsPositiveNumber := TRUE;
    IF (incomingNum <= 0) 
    THEN
        BEGIN
            WRITELN(outp, 'Число должно быть позитивным!');
            IsPositiveNumber := FALSE;
        END
END;

PROCEDURE ClearQueueVars(VAR beginQ, endQ: Queue);
BEGIN
    beginQ := Nil;
    endQ := Nil;
END;

PROCEDURE AddElementToQueue(VAR beginQ, endQ: Queue; incomingData: integer); {создает новую очередь}
VAR
    tempQ: Queue;
BEGIN
    NEW(tempQ);
    tempQ^.Data := incomingData;{внести данные в элемент очереди}
    tempQ^.Next := Nil;
    IF (beginQ = Nil) {проверяем, пуста ли очередь}
        THEN{ставим указатель начала очереди на первый созданный элемент}
            beginQ := tempQ
        ELSE{ставим созданный элемент в конец очереди}
            IF ((beginQ^.Next = Nil) AND (endQ = Nil))
            THEN
                BEGIN
                    endQ := tempQ;
                    beginQ^.Next := endQ;
                END
            ELSE
                endQ^.Next := tempQ;
    endQ := tempQ;
END;

PROCEDURE PromotionOfQueue(VAR escape: TEXT; VAR topStack: Stack);
VAR
    tempQ: Queue;
BEGIN
    IF (IsLastStackElement(topStack))
    THEN
        WRITELN(escape, 'Стек не установлен')
    ELSE
        IF (topStack^.FirstElementQueue = NIL)
        THEN
            WRITELN(escape, 'Нельзя продвинуть очередь, т.к. она пуста')
        ELSE
            BEGIN
                tempQ := topStack^.FirstElementQueue;
                topStack^.FirstElementQueue := topStack^.FirstElementQueue^.Next;
                DISPOSE(tempQ);
                WRITELN(escape, 'Очередь продвинута');
            END;
END;

PROCEDURE AddQueueOFStack(VAR escape, incom: TEXT; topStack: Stack);
VAR
    addedData: INTEGER;
BEGIN
    IF (IsLastStackElement(topStack))
    THEN
        WRITELN(escape, 'Стек не установлен')
    ELSE
        BEGIN
            WRITE(escape, 'Введите добавляемое число: ');
            READLN(incom, addedData);
            AddElementToQueue(topStack^.FirstElementQueue, topStack^.LastElementQueue, addedData);
        END
        
END;

PROCEDURE AddElementStack(VAR outp: TEXT; VAR INP:TEXT; VAR topStack: Stack); {INP - Input}
VAR
    digit, n, i: INTEGER;
    beginQ, endQ: Queue;
    Ch: CHAR;
    flagAddQueue, flag: BOOLEAN;
BEGIN
    ClearQueueVars(beginQ, endQ);
    NEW(itemStack);

    WRITELN(outp, 'Добавлен пустой элемент в вершину стека');
    WRITELN(outp, 'Хотите наполнить его очередью? y-enter, n-esc');
    IF (YesOrNo) 
    THEN
        {редактировать очередь}
        BEGIN
            REPEAT
                WRITE(outp, 'Введите элемент очереди ');
                Read(INP, digit);
                AddElementToQueue(beginQ, endQ, digit);
                WRITELN('Добавить еще? y-enter, n-esc');
            UNTIL (NOT YesOrNo);
        END;
    itemStack^.FirstElementQueue := beginQ;
    itemStack^.LastElementQueue := endQ;
    itemStack^.Next := topStack;
    topStack := itemStack;
END;

FUNCTION IsEndQ(tempQ: Queue): BOOLEAN; {Проверяет указывает ли tempQ на Nil, TRUE - да, FALSE - нет}
BEGIN
    IsEndQ := (tempQ^.Next = Nil);
END;

PROCEDURE PrintQueueOfStack(VAR outp: TEXT; topStack: Stack);
VAR
    dataQueue: INTEGER;
    tempQueue: Queue;
BEGIN
    tempQueue := topStack^.FirstElementQueue;
    WHILE tempQueue <> Nil 
    DO
        BEGIN
            WRITE(outp, tempQueue^.Data, ' ');
            tempQueue := tempQueue^.Next;
        END;
END;  

PROCEDURE PrintAllStack(VAR escape: TEXT; topStack: Stack);
VAR 
    J: INTEGER;
BEGIN
    J := 1;
    IF (IsLastStackElement(topStack)) 
    THEN
        WRITELN(escape, 'Стек пуст!')
    ELSE
        WHILE (NOT IsLastStackElement(topStack))
        DO
            IF (topStack^.FirstElementQueue = NiL)
            THEN
                BEGIN
                    WRITELN(escape, J, ' элемент стека содержит пустую очередь');
                    INC(J, 1);
                    topStack := topStack^.Next;
                END
            ELSE
                BEGIN
                    WRITE(escape, J, ' элемент стека содержит: ');
                    INC(J, 1);
                    PrintQueueOfStack(escape, topStack);
                    topStack := topStack^.Next;
                    WRITELN;
                END;
END;

PROCEDURE DeleteTopStack(VAR escape: TEXT; VAR topStack: Stack);
VAR 
    tempElementStack: Stack;
BEGIN
    IF (NOT IsLastStackElement(topStack))
    THEN
        BEGIN
            tempElementStack := topStack^.Next;
            DISPOSE(topStack);
            topStack := tempElementStack;
            WRITELN(escape, 'Вершина стека удалена')
        END
    ELSE
        WRITELN(escape, 'Не удалось удалить, стек и так пустой!');
END;

PROCEDURE WriteQueueOfTopStack(VAR escape: TEXT; topStack: Stack);
BEGIN
    IF (IsLastStackElement(topStack))
    THEN
        WRITELN(escape, 'Стек не установлен')
    ELSE
        IF topStack^.FirstElementQueue = NIL
        THEN
            WRITELN(escape, 'В вершине стека нет очереди!')
        ELSE 
            BEGIN
                PrintQueueOfStack(escape, topStack);
                WRITELN(escape)
            END
END;

{процедуры-функции меню}
PROCEDURE WriteBlank(VAR escape: TEXT; quantity: INTEGER); {печатает в указанный источник указаное кол-во пробелов}
VAR 
    i: INTEGER;
BEGIN
    FOR i := 1 TO quantity
    DO
        WRITE(escape, ' ');
END;

PROCEDURE PrintMainMenu(VAR escape: TEXT);
BEGIN 
    WRITELN(escape, 'Главное меню');
    WriteBlank(escape, SecondLevel);
    WRITELN(escape, '1. Добавить в стек новый пустой элемент');
    WriteBlank(escape, SecondLevel);
    WRITELN(escape, '2. Удалить вершину стека');
    WriteBlank(escape, SecondLevel);
    WRITELN(escape, '3. Вывести весь стек');
    WriteBlank(escape, SecondLevel);
    WRITELN(escape, '4. Работа с вершиной стека');
    WriteBlank(escape, SecondLevel);
    WRITELN(escape, '5. Выход');
    WriteBlank(escape, FirstLevel);
    WRITELN(escape, '>5. Вывести главное меню');
END;

PROCEDURE NotImplemented(VAR escape:TEXT);
BEGIN
    WRITELN(escape, 'Не реализовано, увы');
END;

PROCEDURE PrintQueueMenu(VAR escape: TEXT);
BEGIN
    WriteBlank(escape, SecondLevel);
    WRITELN(escape, 'Меню работы с очередью');
    WriteBlank(escape, ThirdLevel);
    WRITELN(escape, '1. Добавить очередь в вершину стека');
    WriteBlank(escape, ThirdLevel);
    WRITELN(escape, '2. Продвинуть очередь');
    WriteBlank(escape, ThirdLevel);
    WRITELN(escape, '3. Показать очередь из вершины стека');
    WriteBlank(escape, ThirdLevel);
    WRITELN(escape, '4. Вернуться в главное меню');
END;

FUNCTION SelectQueueFunction(VAR OUTPUT: TEXT; numberQueueMenuItem: INTEGER): BOOLEAN;
BEGIN
    SelectQueueFunction := TRUE;
    CASE numberQueueMenuItem OF
        1: 
            BEGIN {Добавить очередь в вершину стека} {реализовано}
                AddQueueOFStack(OUTPUT, INPUT, topStack);
                PrintQueueMenu(OUTPUT);
            END;
        2: 
            BEGIN {Продвинуть очередь в вершине} {реализовано}
                PromotionOfQueue(OUTPUT, topStack); 
                PrintQueueMenu(OUTPUT);
            END;
        3: 
            BEGIN {Показать очередь из вершины стека} {реализовано}
                WriteQueueOfTopStack(OUTPUT, topStack); 
                PrintQueueMenu(OUTPUT);
            END;
        4:  
            BEGIN
                SelectQueueFunction := FALSE;
                CLRSCR;
            END
        ELSE 
            PrintQueueMenu(OUTPUT);
    END;
END;

FUNCTION SelectFunction(VAR escape:TEXT; numberFunction: INTEGER): BOOLEAN;
VAR
    numberQueueMenuItem: INTEGER;
BEGIN
    SelectFunction := TRUE;
    CASE numberFunction OF
        1: 
            BEGIN {Создать новый пустой элемент стека} {реализовано}
                AddElementStack(OUTPUT, input, topStack); 
                PrintMainMenu(OUTPUT);
            END;
        2: 
            BEGIN {Удалить из стека} {реализовано}
                DeleteTopStack(OUTPUT, topStack); 
                PrintMainMenu(OUTPUT);
            END;
        3: 
            BEGIN {Вывод стека}  {реализовано}
                PrintAllStack(OUTPUT, topStack); 
                PrintMainMenu(OUTPUT);
            END;
        4: 
            BEGIN {открыть меню работы с стеком}
                CLRSCR;
                PrintQueueMenu(escape); 
                REPEAT
                    READ(INPUT, numberQueueMenuItem);
                UNTIL (NOT SelectQueueFunction(OUTPUT, numberQueueMenuItem));
                PrintMainMenu(OUTPUT);
            END;
        5: 
            SelectFunction := FALSE;
        ELSE
            PrintMainMenu(escape);
    END;
END;

{основная программа}
BEGIN
    topStack := Nil;
    CLRSCR;
    PrintMainMenu(OUTPUT);
    REPEAT
        READ(INPUT, numberMenuItem);
    UNTIL (NOT SelectFunction(OUTPUT, numberMenuItem))
END.