report 71500 "I9G_ReportConverter"
{
    ProcessingOnly = true;
    dataset
    {
        dataitem(DataItem1000000000; 2000000026) { }
    }
    var
        OnesText: array[20] of Text[30];
        TensText: array[20] of Text[30];
        ExponentText: array[5] of Text[30];
        OutText: array[3] of Text[30];
        Text000: Label 'Document No cannot be Blank';
        Text070: Label 'Zero';
        Text071: Label 'Hundred';
        Text072: Label 'And';
        Text073: Label '%1 results in a written number that is too long.';
        Text074: Label 'One';
        Text075: Label 'Two';
        Text076: Label 'Three';
        Text077: Label 'Four';
        Text078: Label 'Five';
        Text079: Label 'Six';
        Text080: Label 'Seven';
        Text081: Label 'Eight';
        Text082: Label 'Nine';
        Text083: Label 'Ten';
        Text084: Label 'Eleven';
        Text085: Label 'Twelve';
        Text086: Label 'Thirteen';
        Text087: Label 'Fourteen';
        Text088: Label 'Fifteen';
        Text089: Label 'Sixteen';
        Text090: Label 'Seventeen';
        Text091: Label 'Eighteen';
        Text092: Label 'Nineteen';
        Text093: Label 'Twenty';
        Text094: Label 'Thirty';
        Text095: Label 'Forty';
        Text096: Label 'Fifty';
        Text097: Label 'Sixty';
        Text098: Label 'Seventy';
        Text099: Label 'Eighty';
        Text100: Label 'Ninety';
        Text101: Label 'Thousand';
        Text102: Label 'Million';
        Text103: Label 'Billion';
        Text104: Label 'Only';
        Text1500030: Label 'NUENG';
        Text1500031: Label 'SAWNG';
        Text1500032: Label 'SARM';
        Text1500033: Label 'SI';
        Text1500034: Label 'HA';
        Text1500035: Label 'HOK';
        Text1500036: Label 'CHED';
        Text1500037: Label 'PAED';
        Text1500038: Label 'KOW';
        Text1500039: Label 'SIB';
        Text1500040: Label 'SIB-ED';
        Text1500041: Label 'SIB-SAWNG';
        Text1500042: Label 'SIB-SARM';
        Text1500043: Label 'SIB-SI';
        Text1500044: Label 'SIB-HA';
        Text1500045: Label 'SIB-HOK';
        Text1500046: Label 'SIB-CHED';
        Text1500047: Label 'SIB-PAED';
        Text1500048: Label 'SIB-KOW';
        Text1500049: Label 'YI-SIB';
        Text1500050: Label 'SARM-SIB';
        Text1500051: Label 'SI-SIB';
        Text1500052: Label 'HA-SIB';
        Text1500053: Label 'HOK-SIB';
        Text1500054: Label 'CHED-SIB';
        Text1500055: Label 'PAED-SIB';
        Text1500056: Label 'KOW-SIB';
        Text1500057: Label 'PHAN';
        Text1500058: Label 'LAAN?';
        Text1500059: Label 'PHAN-LAAN?';
        Text1500060: Label 'HUNDRED';
        Text1500061: Label 'ZERO';
        Text1500062: Label 'AND';

    procedure FormatNoText(var NoText: array[3] of Text[60]; No: Decimal; CurrencyCode: Code[10]);
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Cents: Integer;
        OriginalNo: Decimal;
        GroupValue: Integer;
    begin
        InitTextVariable;
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '';
        OriginalNo := No;

        if No < 0 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text070)
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;

                if Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text071);
                    if (Tens > 0) OR (Ones > 0) THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, Text072);
                end;
                if Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end ELSE
                    if (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            end;
            if OriginalNo < 1 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, 'Zero');

            Cents := No * 100;
        end;


        if Cents = 0 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'Dollars')
        ELSE
            IF (OriginalNo < 1) AND (Cents < 20) THEN BEGIN
                AddToNoText(NoText, NoTextIndex, PrintExponent, 'Dollars and Cents ' + OnesText[Cents] + '')
            end else if Cents < 20 THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, 'Dollars and Cents ' + OnesText[Cents] + '')
            ELSE BEGIN
                AddToNoText(NoText, NoTextIndex, PrintExponent, 'Dollars and Cents');
                AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[(Cents MOD 100) DIV 10]);
                if Cents MOD 10 <> 0 THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Cents MOD 10])
                ELSE
                    AddToNoText(NoText, NoTextIndex, PrintExponent, '');
            end;
    end;

    procedure AddToNoText(var NoText: array[3] of Text[60]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30]);
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text073, AddText);
        end;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure InitTextVariable();
    begin
        OnesText[1] := Text074;
        OnesText[2] := Text075;
        OnesText[3] := Text076;
        OnesText[4] := Text077;
        OnesText[5] := Text078;
        OnesText[6] := Text079;
        OnesText[7] := Text080;
        OnesText[8] := Text081;
        OnesText[9] := Text082;
        OnesText[10] := Text083;
        OnesText[11] := Text084;
        OnesText[12] := Text085;
        OnesText[13] := Text086;
        OnesText[14] := Text087;
        OnesText[15] := Text088;
        OnesText[16] := Text089;
        OnesText[17] := Text090;
        OnesText[18] := Text091;
        OnesText[19] := Text092;

        TensText[1] := '';
        TensText[2] := Text093;
        TensText[3] := Text094;
        TensText[4] := Text095;
        TensText[5] := Text096;
        TensText[6] := Text097;
        TensText[7] := Text098;
        TensText[8] := Text099;
        TensText[9] := Text100;

        ExponentText[1] := '';
        ExponentText[2] := Text101;
        ExponentText[3] := Text102;
        ExponentText[4] := Text103;
    end;

    procedure InitTextVariableTH()
    begin
        OnesText[1] := Text1500030;
        OnesText[2] := Text1500031;
        OnesText[3] := Text1500032;
        OnesText[4] := Text1500033;
        OnesText[5] := Text1500034;
        OnesText[6] := Text1500035;
        OnesText[7] := Text1500036;
        OnesText[8] := Text1500037;
        OnesText[9] := Text1500038;
        OnesText[10] := Text1500039;
        OnesText[11] := Text1500040;
        OnesText[12] := Text1500041;
        OnesText[13] := Text1500042;
        OnesText[14] := Text1500043;
        OnesText[15] := Text1500044;
        OnesText[16] := Text1500045;
        OnesText[17] := Text1500046;
        OnesText[18] := Text1500047;
        OnesText[19] := Text1500048;

        TensText[1] := '';
        TensText[2] := Text1500049;
        TensText[3] := Text1500050;
        TensText[4] := Text1500051;
        TensText[5] := Text1500052;
        TensText[6] := Text1500053;
        TensText[7] := Text1500054;
        TensText[8] := Text1500055;
        TensText[9] := Text1500056;

        ExponentText[1] := '';
        ExponentText[2] := Text1500057;
        ExponentText[3] := Text1500058;
        ExponentText[4] := Text1500059;
    end;

    procedure FormatNoTextTH(VAR NoText: ARRAY[2] OF Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Cents: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        if No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text1500061)
        ELSE
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                if Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text1500060);
                end;
                if Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end ELSE
                    if (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            end;

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text1500062);
        AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100) + '/100');

        if CurrencyCode <> '' THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
    end;
}