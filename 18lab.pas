PROGRAM stackOfQueues;
USES CRT;

CONST 
    {������, �ᯮ������ � ����}
    FirstLevel = 1;
    SecondLevel = 2;
    ThirdLevel = 4;

TYPE
  Queue = ^Oue; {��।�}
  Oue = RECORD
       Data : INTEGER;
       Next : Queue;
  END;

TYPE
  Stack = ^ST; {�⥪, � ���஬ 㪠���� �� ��।�}
  ST = RECORD
       FirstElementQueue: Queue;
       LastElementQueue: Queue;
       Next: Stack;
  END;
  
VAR
    numberMenuItem: INTEGER;
    topStack, itemStack: Stack;
    
{��楤��� - �㭪樨 ��� ࠡ��� � ᯨ᪠��}
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
            WRITELN(outp, '��᫮ ������ ���� ����⨢��!');
            IsPositiveNumber := FALSE;
        END
END;

PROCEDURE ClearQueueVars(VAR beginQ, endQ: Queue);
BEGIN
    beginQ := Nil;
    endQ := Nil;
END;

PROCEDURE AddElementToQueue(VAR beginQ, endQ: Queue; incomingData: integer); {ᮧ���� ����� ��।�}
VAR
    tempQ: Queue;
BEGIN
    NEW(tempQ);
    tempQ^.Data := incomingData;{����� ����� � ����� ��।�}
    tempQ^.Next := Nil;
    IF (beginQ = Nil) {�஢��塞, ���� �� ��।�}
        THEN{�⠢�� 㪠��⥫� ��砫� ��।� �� ���� ᮧ����� �����}
            beginQ := tempQ
        ELSE{�⠢�� ᮧ����� ����� � ����� ��।�}
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
        WRITELN(escape, '�⥪ �� ��⠭�����')
    ELSE
        IF (topStack^.FirstElementQueue = NIL)
        THEN
            WRITELN(escape, '����� �த������ ��।�, �.�. ��� ����')
        ELSE
            BEGIN
                tempQ := topStack^.FirstElementQueue;
                topStack^.FirstElementQueue := topStack^.FirstElementQueue^.Next;
                DISPOSE(tempQ);
                WRITELN(escape, '��।� �த�����');
            END;
END;

PROCEDURE AddQueueOFStack(VAR escape, incom: TEXT; topStack: Stack);
VAR
    addedData: INTEGER;
BEGIN
    IF (IsLastStackElement(topStack))
    THEN
        WRITELN(escape, '�⥪ �� ��⠭�����')
    ELSE
        BEGIN
            WRITE(escape, '������ ������塞�� �᫮: ');
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

    WRITELN(outp, '�������� ���⮩ ����� � ���設� �⥪�');
    WRITELN(outp, '���� ��������� ��� ��।��? y-enter, n-esc');
    IF (YesOrNo) 
    THEN
        {।���஢��� ��।�}
        BEGIN
            REPEAT
                WRITE(outp, '������ ����� ��।� ');
                Read(INP, digit);
                AddElementToQueue(beginQ, endQ, digit);
                WRITELN('�������� ��? y-enter, n-esc');
            UNTIL (NOT YesOrNo);
        END;
    itemStack^.FirstElementQueue := beginQ;
    itemStack^.LastElementQueue := endQ;
    itemStack^.Next := topStack;
    topStack := itemStack;
END;

FUNCTION IsEndQ(tempQ: Queue): BOOLEAN; {�஢���� 㪠�뢠�� �� tempQ �� Nil, TRUE - ��, FALSE - ���}
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
        WRITELN(escape, '�⥪ ����!')
    ELSE
        WHILE (NOT IsLastStackElement(topStack))
        DO
            IF (topStack^.FirstElementQueue = NiL)
            THEN
                BEGIN
                    WRITELN(escape, J, ' ����� �⥪� ᮤ�ন� ������ ��।�');
                    INC(J, 1);
                    topStack := topStack^.Next;
                END
            ELSE
                BEGIN
                    WRITE(escape, J, ' ����� �⥪� ᮤ�ন�: ');
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
            WRITELN(escape, '���設� �⥪� 㤠����')
        END
    ELSE
        WRITELN(escape, '�� 㤠���� 㤠����, �⥪ � ⠪ ���⮩!');
END;

PROCEDURE WriteQueueOfTopStack(VAR escape: TEXT; topStack: Stack);
BEGIN
    IF (IsLastStackElement(topStack))
    THEN
        WRITELN(escape, '�⥪ �� ��⠭�����')
    ELSE
        IF topStack^.FirstElementQueue = NIL
        THEN
            WRITELN(escape, '� ���設� �⥪� ��� ��।�!')
        ELSE 
            BEGIN
                PrintQueueOfStack(escape, topStack);
                WRITELN(escape)
            END
END;

{��楤���-�㭪樨 ����}
PROCEDURE WriteBlank(VAR escape: TEXT; quantity: INTEGER); {���⠥� � 㪠����� ���筨� 㪠����� ���-�� �஡����}
VAR 
    i: INTEGER;
BEGIN
    FOR i := 1 TO quantity
    DO
        WRITE(escape, ' ');
END;

PROCEDURE PrintMainMenu(VAR escape: TEXT);
BEGIN 
    WRITELN(escape, '������� ����');
    WriteBlank(escape, SecondLevel);
    WRITELN(escape, '1. �������� � �⥪ ���� ���⮩ �����');
    WriteBlank(escape, SecondLevel);
    WRITELN(escape, '2. ������� ���設� �⥪�');
    WriteBlank(escape, SecondLevel);
    WRITELN(escape, '3. �뢥�� ���� �⥪');
    WriteBlank(escape, SecondLevel);
    WRITELN(escape, '4. ����� � ���設�� �⥪�');
    WriteBlank(escape, SecondLevel);
    WRITELN(escape, '5. ��室');
    WriteBlank(escape, FirstLevel);
    WRITELN(escape, '>5. �뢥�� ������� ����');
END;

PROCEDURE NotImplemented(VAR escape:TEXT);
BEGIN
    WRITELN(escape, '�� ॠ��������, ��');
END;

PROCEDURE PrintQueueMenu(VAR escape: TEXT);
BEGIN
    WriteBlank(escape, SecondLevel);
    WRITELN(escape, '���� ࠡ��� � ��।��');
    WriteBlank(escape, ThirdLevel);
    WRITELN(escape, '1. �������� ��।� � ���設� �⥪�');
    WriteBlank(escape, ThirdLevel);
    WRITELN(escape, '2. �த������ ��।�');
    WriteBlank(escape, ThirdLevel);
    WRITELN(escape, '3. �������� ��।� �� ���設� �⥪�');
    WriteBlank(escape, ThirdLevel);
    WRITELN(escape, '4. �������� � ������� ����');
END;

FUNCTION SelectQueueFunction(VAR OUTPUT: TEXT; numberQueueMenuItem: INTEGER): BOOLEAN;
BEGIN
    SelectQueueFunction := TRUE;
    CASE numberQueueMenuItem OF
        1: 
            BEGIN {�������� ��।� � ���設� �⥪�} {ॠ��������}
                AddQueueOFStack(OUTPUT, INPUT, topStack);
                PrintQueueMenu(OUTPUT);
            END;
        2: 
            BEGIN {�த������ ��।� � ���設�} {ॠ��������}
                PromotionOfQueue(OUTPUT, topStack); 
                PrintQueueMenu(OUTPUT);
            END;
        3: 
            BEGIN {�������� ��।� �� ���設� �⥪�} {ॠ��������}
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
            BEGIN {������� ���� ���⮩ ����� �⥪�} {ॠ��������}
                AddElementStack(OUTPUT, input, topStack); 
                PrintMainMenu(OUTPUT);
            END;
        2: 
            BEGIN {������� �� �⥪�} {ॠ��������}
                DeleteTopStack(OUTPUT, topStack); 
                PrintMainMenu(OUTPUT);
            END;
        3: 
            BEGIN {�뢮� �⥪�}  {ॠ��������}
                PrintAllStack(OUTPUT, topStack); 
                PrintMainMenu(OUTPUT);
            END;
        4: 
            BEGIN {������ ���� ࠡ��� � �⥪��}
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

{�᭮���� �ணࠬ��}
BEGIN
    topStack := Nil;
    CLRSCR;
    PrintMainMenu(OUTPUT);
    REPEAT
        READ(INPUT, numberMenuItem);
    UNTIL (NOT SelectFunction(OUTPUT, numberMenuItem))
END.