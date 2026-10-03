codeunit 52150 CitibankCU
{
    // Spreads the first line of inTextArray array to other lines as MaxLen long strings, return true if no overflow

    /* Test Sample

            action("Test Text Split")
            {
                Caption = 'Test Text Split';
                ApplicationArea = All;
                Image = Split;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    textArray: array[10] of Text;
                    result: Boolean;
                    i: Integer;
                    MsgText: Text;
                    SourceText: Text;
                    textList: List of [Text];
                    elementText: Text;
                begin
                    SourceText := 'The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the lazy dog.';
                    Clear(textArray);
                    textArray[1] := SourceText;
                    result := SplitTextBySize(textArray, 35);
                    i := 0;

                    repeat
                        i += 1;
                        MsgText += Format(i) + ': "' + textArray[i] + '"\';
                    until StrLen(textArray[i]) = 0;

                    Message('Success: ' + Format(result) + '\' + MsgText);

                    MsgText := '';
                    i := 0;

                    Clear(textList);
                    result := SplitTextBySize(SourceText, textList, 35);

                    MsgText += 'List Size: ' + Format(textList.Count) + '\';

                    foreach elementText in textList do begin
                        i += 1;
                        MsgText += Format(i) + ': "' + elementText + '"\';
                    end;

                    Message('Success: ' + Format(result) + '\' + MsgText);

                end;
            }

    */

    procedure SplitTextBySize(var inTextArray: array[10] of Text; MaxLen: Integer): Boolean
    var
        loopIndex: Integer;
    begin
        // Parameter Validation
        if ArrayLen(inTextArray) < 2 then
            Error('Array parameter size must be bigger than 1');

        if MaxLen < 1 then
            Error('MaxLen has to be a positive integer');

        // Start spliting
        for loopIndex := 1 to ArrayLen(inTextArray) - 1 do begin
            inTextArray[loopIndex + 1] := CopyStr(inTextArray[loopIndex], MaxLen + 1);
            inTextArray[loopIndex] := CopyStr(inTextArray[loopIndex], 1, MaxLen);
            if StrLen(inTextArray[loopIndex + 1]) <= MaxLen then
                exit(true);
        end;

        exit(StrLen(inTextArray[loopIndex + 1]) <= MaxLen);

    end;

    procedure SplitTextBySize(SourceText: Text; var inTextList: List of [Text]; MaxLen: Integer): Boolean
    var
        processingText: Text;
        sizeCounter: Integer;
    begin
        // Parameter Validation
        if MaxLen < 1 then
            Error('MaxLen has to be a positive integer');

        processingText := SourceText;

        while StrLen(processingText) > 0 do begin
            inTextList.Add(CopyStr(processingText, 1, MaxLen));
            processingText := CopyStr(processingText, MaxLen + 1);
        end;

        exit(StrLen(inTextList.Get(inTextList.Count)) <= MaxLen);

    end;
}
