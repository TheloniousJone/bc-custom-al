codeunit 50000 "Hyphens CU"
{
    Permissions = TableData "Sales Invoice Header" = rimd,
                TableData "Sales Cr.Memo Header" = rimd;

    var
        grec_Temp: Record "Temp Table" temporary;
        ExcelBuffer: Record "Excel Buffer" temporary;
        DimMgt: Codeunit DimensionManagement;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        gdt_PostingDateBIPO: Date;

    local procedure GetValueAtIndex(RowNo: Integer; ColNo: Integer): Text
    var
    begin
        ExcelBuffer.Reset();
        IF ExcelBuffer.Get(RowNo, ColNo) then
            exit(ExcelBuffer."Cell Value as Text");
    end;

    procedure ImportBIPOOld(Template: Code[10]; Batch: Code[10]) //As of 20210405
    var
        ImportFileName: Text;
        ImportStream: InStream;
        TempBlobData: Codeunit "Temp Blob";
        FileCU: Codeunit 419;
        ExcelCellValue: Text;
        Sheetname: Text;
        InRows: Integer;
        TotalColumns: Integer;
        RowNo: Integer;
        ColNo: Integer;
        FirstColumnText: Text;
        EntryNo: Integer;
        RowID: Text;
        ItemCode: Text;
        ItemName: Text;
        ColumnF: Text;
        ColumnG: Text;
        ColumnH: Text;
        ColumnI: Text;
        ldec_F: Decimal;
        ldec_G: Decimal;
        ldec_H: Decimal;
        ldec_I: Decimal;
        x: Integer;

        Alphabets: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        lrec_GJL: Record "Gen. Journal Line";
        lint_LineNo: Integer;
        lrec_BIPO: Record "BIPO Impport Setup";
        lrec_DimSetEntry: Record "Dimension Set Entry";
        lrec_DimSetCount: Record "Dimension Set Entry";
        GenJnlBatch: Record "Gen. Journal Batch";
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        LastDocNo: Code[20];
        lrec_NoSeriesLine: Record "No. Series Line";
        lrec_BIPO2: Record "BIPO Impport Setup";
    begin
        if ExcelBuffer.IsTemporary then
            ExcelBuffer.DeleteAll();
        if grec_Temp.IsTemporary then
            grec_Temp.DeleteAll();

        FileCU.BLOBImport(TempBlobData, ImportFileName);
        TempBlobData.CreateInStream(ImportStream, TextEncoding::UTF8);
        Sheetname := ExcelBuffer.SelectSheetsNameStream(ImportStream);

        // Get Data and Match
        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(ImportStream, Sheetname);
        ExcelBuffer.ReadSheet();

        Commit();

        // Processing

        InRows := 2; // Start at Row 2
        FirstColumnText := Format(GetValueAtIndex(InRows, 4));
        Clear(EntryNo);
        EntryNo := 1;

        //Insert and SUM into grec_Temp >>
        while StrLen(FirstColumnText) > 0 do begin
            // ColumnF := Format(GetValueAtIndex(InRows, 6));
            // Evaluate(ldec_F, ColumnF);
            // ColumnG := Format(GetValueAtIndex(InRows, 7));
            // Evaluate(ldec_G, ColumnG);
            // ColumnH := Format(GetValueAtIndex(InRows, 8));
            // Evaluate(ldec_H, ColumnH);
            // ColumnI := Format(GetValueAtIndex(InRows, 9));
            // Evaluate(ldec_I, ColumnI);
            FirstColumnText := CopyStr(FirstColumnText, 1, 100);

            ColumnG := Format(GetValueAtIndex(InRows, 5));

            lrec_BIPO.Reset();
            lrec_BIPO.SetRange("BIPO Type", lrec_BIPO."BIPO Type"::ColumnID);
            if lrec_BIPO.FindSet() then begin
                repeat
                    x := StrPos(Alphabets, lrec_BIPO."BIPO Code");

                    ColumnF := Format(GetValueAtIndex(InRows, x));
                    Evaluate(ldec_F, ColumnF);

                    if ldec_F <> 0 then begin
                        grec_Temp.Reset();
                        grec_Temp.SetRange(Text1, FirstColumnText);
                        grec_Temp.SetRange(Text2, lrec_BIPO."BIPO Code");
                        if grec_Temp.FindFirst() then begin
                            grec_Temp.Decimal1 := grec_Temp.Decimal1 + ldec_F;
                            grec_Temp.Modify();
                        end else begin
                            grec_Temp.Init();
                            grec_Temp."Entry No." := EntryNo;
                            grec_Temp.Text1 := FirstColumnText;
                            grec_Temp.Text2 := lrec_BIPO."BIPO Code";
                            grec_Temp.Text3 := ColumnG;
                            grec_Temp.Decimal1 := ldec_F;
                            grec_Temp.Insert();
                            EntryNo += 1;
                        end;
                    end;
                until lrec_BIPO.Next() = 0;
            end;

            InRows := InRows + 1;
            FirstColumnText := Format(GetValueAtIndex(InRows, 4));
        end;
        // Message('count %1', InRows);

        Commit();

        //Insert and SUM into grec_Temp <<
        lrec_GJL.Reset();
        lrec_GJL.SetRange("Journal Template Name", Template);
        lrec_GJL.SetRange("Journal Batch Name", Batch);
        if lrec_GJL.FindLast() then begin
            lint_LineNo := lrec_GJL."Line No." + 10000;
        end else begin
            lint_LineNo := 10000;
        end;

        Clear(LastDocNo);
        if GenJnlBatch.Get(Template, Batch) then begin
            if GenJnlBatch."No. Series" <> '' then begin
                lrec_NoSeriesLine.Reset();
                lrec_NoSeriesLine.SetRange("Series Code", GenJnlBatch."No. Series");
                if lrec_NoSeriesLine.FindLast() then begin
                    LastDocNo := IncStr(lrec_NoSeriesLine."Last No. Used");
                    // lrec_NoSeriesLine."Last No. Used" := LastDocNo;
                    // lrec_NoSeriesLine.Modify();
                end;
                // Clear(NoSeriesMgt);
                // lrec_GJL.CheckDocNoBasedOnNoSeries(LastDocNo, GenJnlBatch."No. Series", NoSeriesMgt);
                // NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", lrec_GJL."Posting Date", false);
            end;
        end;

        //Insert Into GJL >>
        grec_Temp.Reset();
        grec_Temp.SetCurrentKey(Text1, Text2);
        grec_Temp.SetAscending(Text1, true);
        // grec_Temp.SetAscending( Text2,true);
        if grec_Temp.FindSet() then begin
            repeat
                if grec_Temp.Decimal1 <> 0 then begin
                    lrec_BIPO2.Reset();
                    lrec_BIPO2.SetRange("BIPO Type", lrec_BIPO2."BIPO Type"::RowID);
                    lrec_BIPO2.SetRange("BIPO Code", grec_Temp.Text1);
                    if lrec_BIPO2.FindFirst() then begin
                        if (lrec_BIPO2."Account No." <> '') or (lrec_BIPO2."Bal. Account No." <> '') then begin
                            lrec_GJL.Init();
                            lrec_GJL."Journal Template Name" := Template;
                            lrec_GJL."Journal Batch Name" := Batch;
                            lrec_GJL."Line No." := lint_LineNo;
                            lrec_GJL."Document No." := LastDocNo;
                            // lrec_GJL.RenumberDocumentNo();
                            lrec_GJL."Posting Date" := Today;
                            lrec_GJL.Insert(true);
                            lrec_BIPO.Reset();
                            lrec_BIPO.SetRange("BIPO Type", lrec_BIPO."BIPO Type"::RowID);
                            lrec_BIPO.SetRange("BIPO Code", grec_Temp.Text1);
                            if lrec_BIPO.FindFirst() then begin
                                lrec_GJL."Account Type" := lrec_BIPO."Account Type";
                                lrec_GJL.Validate("Account No.", lrec_BIPO."Account No.");
                                lrec_GJL."Bal. Account Type" := lrec_BIPO."Bal. Account Type";
                                lrec_GJL.Validate("Bal. Account No.", lrec_BIPO."Bal. Account No.");
                            end;
                            lrec_GJL.Validate(Amount, grec_Temp.Decimal1);
                            lrec_GJL.Description := grec_Temp.Text3;
                            lrec_GJL.Modify(true);
                            lint_LineNo += 10000;

                            lrec_BIPO.Reset();
                            lrec_BIPO.SetRange("BIPO Type", lrec_BIPO."BIPO Type"::ColumnID);
                            lrec_BIPO.SetRange("BIPO Code", grec_Temp.Text2);
                            if lrec_BIPO.FindFirst() then begin
                                lrec_DimSetEntry.Reset();
                                lrec_DimSetEntry.SetRange("Dimension Code", lrec_BIPO."Dimension Code");
                                lrec_DimSetEntry.SetRange("Dimension Value Code", lrec_BIPO."Dimension Value");
                                if lrec_DimSetEntry.FindSet() then begin
                                    repeat
                                        lrec_DimSetCount.Reset();
                                        lrec_DimSetCount.SetRange("Dimension Set ID", lrec_DimSetEntry."Dimension Set ID");
                                        if lrec_DimSetCount.Count = 1 then begin
                                            lrec_GJL.Validate("Dimension Set ID", lrec_DimSetCount."Dimension Set ID");
                                            lrec_GJL.Modify(true);
                                        end;
                                    until (lrec_DimSetCount.Count = 1) or (lrec_DimSetEntry.Next() = 0);
                                end;

                                if lrec_GJL."Dimension Set ID" = 0 then begin
                                    DimMgt.GetDimensionSet(TempDimSetEntry, lrec_GJL."Dimension Set ID");
                                    TempDimSetEntry.Init;
                                    TempDimSetEntry.VALIDATE("Dimension Code", lrec_BIPO."Dimension Code");
                                    TempDimSetEntry.VALIDATE("Dimension Value Code", lrec_BIPO."Dimension Value");
                                    if not TempDimSetEntry.INSERT then
                                        TempDimSetEntry.Modify;
                                    lrec_GJL.Validate("Dimension Set ID", DimMgt.GetDimensionSetID(TempDimSetEntry));
                                    lrec_GJL.MODIFY(true);
                                end;
                                Commit();
                            end;

                        end;
                    end;
                end;

            // if grec_Temp.Decimal2 <> 0 then begin
            //     lrec_GJL.Init();
            //     lrec_GJL."Journal Template Name" := 'GENERAL';
            //     lrec_GJL."Journal Batch Name" := 'BIPO';
            //     lrec_GJL."Line No." := lint_LineNo;
            //     lrec_GJL."Document No." := LastDocNo;
            //     lrec_GJL."Posting Date" := Today;
            //     lrec_GJL.Insert(true);
            //     lrec_BIPO.Reset();
            //     lrec_BIPO.SetRange("BIPO Type", lrec_BIPO."BIPO Type"::RowID);
            //     lrec_BIPO.SetRange("BIPO Code", grec_Temp.Text1);
            //     if lrec_BIPO.FindFirst() then begin
            //         lrec_GJL."Account Type" := lrec_BIPO."Account Type";
            //         lrec_GJL.Validate("Account No.", lrec_BIPO."Account No.");
            //         lrec_GJL."Bal. Account Type" := lrec_BIPO."Bal. Account Type";
            //         lrec_GJL.Validate("Bal. Account No.", lrec_BIPO."Bal. Account No.");
            //     end;
            //     lrec_GJL.Validate(Amount, grec_Temp.Decimal2);
            //     lrec_GJL.Modify(true);
            //     lint_LineNo += 10000;

            //     lrec_BIPO.Reset();
            //     lrec_BIPO.SetRange("BIPO Type", lrec_BIPO."BIPO Type"::ColumnID);
            //     lrec_BIPO.SetRange("BIPO Code", 'G');
            //     if lrec_BIPO.FindFirst() then begin
            //         lrec_DimSetEntry.Reset();
            //         lrec_DimSetEntry.SetRange("Dimension Code", lrec_BIPO."Dimension Code");
            //         lrec_DimSetEntry.SetRange("Dimension Value Code", lrec_BIPO."Dimension Value");
            //         if lrec_DimSetEntry.FindSet() then begin
            //             repeat
            //                 lrec_DimSetCount.Reset();
            //                 lrec_DimSetCount.SetRange("Dimension Set ID", lrec_DimSetEntry."Dimension Set ID");
            //                 if lrec_DimSetCount.Count = 1 then begin
            //                     lrec_GJL.Validate("Dimension Set ID", lrec_DimSetCount."Dimension Set ID");
            //                     lrec_GJL.Modify(true);
            //                 end;
            //             until (lrec_DimSetCount.Count = 1) or (lrec_DimSetEntry.Next() = 0);
            //         end;

            //         if lrec_GJL."Dimension Set ID" = 0 then begin
            //             DimMgt.GetDimensionSet(TempDimSetEntry, lrec_GJL."Dimension Set ID");
            //             TempDimSetEntry.Init;
            //             TempDimSetEntry.VALIDATE("Dimension Code", lrec_BIPO."Dimension Code");
            //             TempDimSetEntry.VALIDATE("Dimension Value Code", lrec_BIPO."Dimension Value");
            //             if not TempDimSetEntry.INSERT then
            //                 TempDimSetEntry.Modify;
            //             lrec_GJL.Validate("Dimension Set ID", DimMgt.GetDimensionSetID(TempDimSetEntry));
            //             lrec_GJL.MODIFY(true);
            //         end;
            //     end;
            //     Commit();
            // end;

            // if grec_Temp.Decimal3 <> 0 then begin
            //     lrec_GJL.Init();
            //     lrec_GJL."Journal Template Name" := 'GENERAL';
            //     lrec_GJL."Journal Batch Name" := 'BIPO';
            //     lrec_GJL."Line No." := lint_LineNo;
            //     lrec_GJL."Document No." := LastDocNo;
            //     lrec_GJL."Posting Date" := Today;
            //     lrec_GJL.Insert(true);
            //     lrec_BIPO.Reset();
            //     lrec_BIPO.SetRange("BIPO Type", lrec_BIPO."BIPO Type"::RowID);
            //     lrec_BIPO.SetRange("BIPO Code", grec_Temp.Text1);
            //     if lrec_BIPO.FindFirst() then begin
            //         lrec_GJL."Account Type" := lrec_BIPO."Account Type";
            //         lrec_GJL.Validate("Account No.", lrec_BIPO."Account No.");
            //         lrec_GJL."Bal. Account Type" := lrec_BIPO."Bal. Account Type";
            //         lrec_GJL.Validate("Bal. Account No.", lrec_BIPO."Bal. Account No.");
            //     end;
            //     lrec_GJL.Validate(Amount, grec_Temp.Decimal3);
            //     lrec_GJL.Modify(true);
            //     lint_LineNo += 10000;

            //     lrec_BIPO.Reset();
            //     lrec_BIPO.SetRange("BIPO Type", lrec_BIPO."BIPO Type"::ColumnID);
            //     lrec_BIPO.SetRange("BIPO Code", 'H');
            //     if lrec_BIPO.FindFirst() then begin
            //         lrec_DimSetEntry.Reset();
            //         lrec_DimSetEntry.SetRange("Dimension Code", lrec_BIPO."Dimension Code");
            //         lrec_DimSetEntry.SetRange("Dimension Value Code", lrec_BIPO."Dimension Value");
            //         if lrec_DimSetEntry.FindSet() then begin
            //             repeat
            //                 lrec_DimSetCount.Reset();
            //                 lrec_DimSetCount.SetRange("Dimension Set ID", lrec_DimSetEntry."Dimension Set ID");
            //                 if lrec_DimSetCount.Count = 1 then begin
            //                     lrec_GJL.Validate("Dimension Set ID", lrec_DimSetCount."Dimension Set ID");
            //                     lrec_GJL.Modify(true);
            //                 end;
            //             until (lrec_DimSetCount.Count = 1) or (lrec_DimSetEntry.Next() = 0);
            //         end;

            //         if lrec_GJL."Dimension Set ID" = 0 then begin
            //             DimMgt.GetDimensionSet(TempDimSetEntry, lrec_GJL."Dimension Set ID");
            //             TempDimSetEntry.Init;
            //             TempDimSetEntry.VALIDATE("Dimension Code", lrec_BIPO."Dimension Code");
            //             TempDimSetEntry.VALIDATE("Dimension Value Code", lrec_BIPO."Dimension Value");
            //             if not TempDimSetEntry.INSERT then
            //                 TempDimSetEntry.Modify;
            //             lrec_GJL.Validate("Dimension Set ID", DimMgt.GetDimensionSetID(TempDimSetEntry));
            //             lrec_GJL.MODIFY(true);
            //         end;
            //     end;
            //     Commit();
            // end;

            // if grec_Temp.Decimal4 <> 0 then begin
            //     lrec_GJL.Init();
            //     lrec_GJL."Journal Template Name" := 'GENERAL';
            //     lrec_GJL."Journal Batch Name" := 'BIPO';
            //     lrec_GJL."Line No." := lint_LineNo;
            //     lrec_GJL."Document No." := LastDocNo;
            //     lrec_GJL."Posting Date" := Today;
            //     lrec_GJL.Insert(true);
            //     lrec_BIPO.Reset();
            //     lrec_BIPO.SetRange("BIPO Type", lrec_BIPO."BIPO Type"::RowID);
            //     lrec_BIPO.SetRange("BIPO Code", grec_Temp.Text1);
            //     if lrec_BIPO.FindFirst() then begin
            //         lrec_GJL."Account Type" := lrec_BIPO."Account Type";
            //         lrec_GJL.Validate("Account No.", lrec_BIPO."Account No.");
            //         lrec_GJL."Bal. Account Type" := lrec_BIPO."Bal. Account Type";
            //         lrec_GJL.Validate("Bal. Account No.", lrec_BIPO."Bal. Account No.");
            //     end;
            //     lrec_GJL.Validate(Amount, grec_Temp.Decimal4);
            //     lrec_GJL.Modify(true);
            //     lint_LineNo += 10000;

            //     lrec_BIPO.Reset();
            //     lrec_BIPO.SetRange("BIPO Type", lrec_BIPO."BIPO Type"::ColumnID);
            //     lrec_BIPO.SetRange("BIPO Code", 'I');
            //     if lrec_BIPO.FindFirst() then begin
            //         lrec_DimSetEntry.Reset();
            //         lrec_DimSetEntry.SetRange("Dimension Code", lrec_BIPO."Dimension Code");
            //         lrec_DimSetEntry.SetRange("Dimension Value Code", lrec_BIPO."Dimension Value");
            //         if lrec_DimSetEntry.FindSet() then begin
            //             repeat
            //                 lrec_DimSetCount.Reset();
            //                 lrec_DimSetCount.SetRange("Dimension Set ID", lrec_DimSetEntry."Dimension Set ID");
            //                 if lrec_DimSetCount.Count = 1 then begin
            //                     lrec_GJL.Validate("Dimension Set ID", lrec_DimSetCount."Dimension Set ID");
            //                     lrec_GJL.Modify(true);
            //                 end;
            //             until (lrec_DimSetCount.Count = 1) or (lrec_DimSetEntry.Next() = 0);
            //         end;

            //         if lrec_GJL."Dimension Set ID" = 0 then begin
            //             DimMgt.GetDimensionSet(TempDimSetEntry, lrec_GJL."Dimension Set ID");
            //             TempDimSetEntry.Init;
            //             TempDimSetEntry.VALIDATE("Dimension Code", lrec_BIPO."Dimension Code");
            //             TempDimSetEntry.VALIDATE("Dimension Value Code", lrec_BIPO."Dimension Value");
            //             if not TempDimSetEntry.INSERT then
            //                 TempDimSetEntry.Modify;
            //             lrec_GJL.Validate("Dimension Set ID", DimMgt.GetDimensionSetID(TempDimSetEntry));
            //             lrec_GJL.MODIFY(true);
            //         end;
            //     end;
            //     Commit();
            // end;

            until grec_Temp.Next() = 0;
        end;
        // Insert Into GJL <<

        Message('File Imported');
    end;

    procedure ImportBIPO(Template: Code[10]; Batch: Code[10]; PostingDate: Date/*; var HyphensCU: Codeunit "Hyphens CU"*/)
    var
        ImportFileName: Text;
        ImportStream: InStream;
        TempBlobData: Codeunit "Temp Blob";
        FileCU: Codeunit 419;
        ExcelCellValue: Text;
        Sheetname: Text;
        InRows: Integer;
        TotalColumns: Integer;
        RowNo: Integer;
        ColNo: Integer;
        FirstColumnText: Text;
        EntryNo: Integer;
        RowID: Text;
        ItemCode: Text;
        ItemName: Text;
        ColumnF: Text;
        ColumnG: Text;
        ColumnH: Text;
        ColumnI: Text;
        ldec_F: Decimal;
        ldec_G: Decimal;
        ldec_H: Decimal;
        ldec_I: Decimal;
        x: Integer;
        ListDim: Text;
        ListDimVal: Text;

        Alphabets: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        lrec_GJL: Record "Gen. Journal Line";
        lint_LineNo: Integer;
        lrec_BIPO: Record "BIPO Impport Setup";
        lrec_DimSetEntry: Record "Dimension Set Entry";
        lrec_DimSetCount: Record "Dimension Set Entry";
        GenJnlBatch: Record "Gen. Journal Batch";
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        LastDocNo: Code[20];
        lrec_NoSeriesLine: Record "No. Series Line";
        lrec_BIPO2: Record "BIPO Impport Setup";
    begin
        if ExcelBuffer.IsTemporary then
            ExcelBuffer.DeleteAll();
        if grec_Temp.IsTemporary then
            grec_Temp.DeleteAll();

        FileCU.BLOBImport(TempBlobData, ImportFileName);
        TempBlobData.CreateInStream(ImportStream, TextEncoding::UTF8);
        Sheetname := ExcelBuffer.SelectSheetsNameStream(ImportStream);

        // Get Data and Match
        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(ImportStream, Sheetname);
        ExcelBuffer.ReadSheet();

        Commit();

        // Processing

        InRows := 2; // Start at Row 2
        FirstColumnText := Format(GetValueAtIndex(InRows, 4));
        Clear(EntryNo);
        EntryNo := 1;

        //Insert and SUM into grec_Temp >>
        while StrLen(FirstColumnText) > 0 do begin
            FirstColumnText := CopyStr(FirstColumnText, 1, 100);

            ColumnG := Format(GetValueAtIndex(InRows, 5));

            lrec_BIPO.Reset();
            lrec_BIPO.SetRange("BIPO Type", lrec_BIPO."BIPO Type"::ColumnID);
            if lrec_BIPO.FindSet() then begin
                repeat
                    x := StrPos(Alphabets, lrec_BIPO."BIPO Code");

                    ColumnF := Format(GetValueAtIndex(InRows, x));
                    Evaluate(ldec_F, ColumnF);

                    if ldec_F <> 0 then begin
                        grec_Temp.Reset();
                        grec_Temp.SetRange(Text1, FirstColumnText);
                        grec_Temp.SetRange(Text2, lrec_BIPO."BIPO Code");
                        if grec_Temp.FindFirst() then begin
                            grec_Temp.Decimal1 := grec_Temp.Decimal1 + ldec_F;
                            grec_Temp.Modify();
                        end else begin
                            grec_Temp.Init();
                            grec_Temp."Entry No." := EntryNo;
                            grec_Temp.Text1 := FirstColumnText;
                            grec_Temp.Text2 := lrec_BIPO."BIPO Code";
                            grec_Temp.Text3 := ColumnG;
                            grec_Temp.Decimal1 := ldec_F;
                            grec_Temp.Insert();
                            EntryNo += 1;
                        end;
                    end;
                until lrec_BIPO.Next() = 0;
            end;

            InRows := InRows + 1;
            FirstColumnText := Format(GetValueAtIndex(InRows, 4));
        end;

        Commit();

        //Insert and SUM into grec_Temp <<
        lrec_GJL.Reset();
        lrec_GJL.SetRange("Journal Template Name", Template);
        lrec_GJL.SetRange("Journal Batch Name", Batch);
        if lrec_GJL.FindLast() then begin
            lint_LineNo := lrec_GJL."Line No." + 10000;
        end else begin
            lint_LineNo := 10000;
        end;

        Clear(LastDocNo);
        if GenJnlBatch.Get(Template, Batch) then begin
            if GenJnlBatch."No. Series" <> '' then begin
                lrec_NoSeriesLine.Reset();
                lrec_NoSeriesLine.SetRange("Series Code", GenJnlBatch."No. Series");
                if lrec_NoSeriesLine.FindLast() then begin
                    LastDocNo := IncStr(lrec_NoSeriesLine."Last No. Used");
                end;
            end;
        end;

        //Insert Into GJL >>
        grec_Temp.Reset();
        grec_Temp.SetCurrentKey(Text1, Text2);
        grec_Temp.SetAscending(Text1, true);
        if grec_Temp.FindSet() then begin
            repeat
                if grec_Temp.Decimal1 <> 0 then begin
                    lrec_BIPO2.Reset();
                    lrec_BIPO2.SetRange("BIPO Type", lrec_BIPO2."BIPO Type"::RowID);
                    lrec_BIPO2.SetRange("BIPO Code", grec_Temp.Text1);
                    if lrec_BIPO2.FindFirst() then begin
                        if (lrec_BIPO2."Account No." <> '') or (lrec_BIPO2."Bal. Account No." <> '') then begin
                            lrec_GJL.Init();
                            lrec_GJL."Journal Template Name" := Template;
                            lrec_GJL."Journal Batch Name" := Batch;
                            lrec_GJL."Line No." := lint_LineNo;
                            lrec_GJL."Document No." := LastDocNo;
                            lrec_GJL."Posting Date" := PostingDate;
                            lrec_GJL.Insert(true);
                            lrec_BIPO.Reset();
                            lrec_BIPO.SetRange("BIPO Type", lrec_BIPO."BIPO Type"::RowID);
                            lrec_BIPO.SetRange("BIPO Code", grec_Temp.Text1);
                            if lrec_BIPO.FindFirst() then begin
                                lrec_GJL."Account Type" := lrec_BIPO."Account Type";
                                lrec_GJL.Validate("Account No.", lrec_BIPO."Account No.");
                                lrec_GJL."Bal. Account Type" := lrec_BIPO."Bal. Account Type";
                                lrec_GJL.Validate("Bal. Account No.", lrec_BIPO."Bal. Account No.");
                                lrec_GJL.Description := lrec_BIPO.Description;//KM20210405
                            end;
                            lrec_GJL.Validate(Amount, grec_Temp.Decimal1);
                            // lrec_GJL.Description := grec_Temp.Text3; //KM20210405
                            //KM20210406 - Start
                            if lrec_GJL.Description = '' then
                                lrec_GJL.Description := grec_Temp.Text3;
                            //KM20210406 - End
                            lrec_GJL.Modify(true);
                            lint_LineNo += 10000;

                            lrec_BIPO2.Reset();
                            lrec_BIPO2.SetRange("BIPO Type", lrec_BIPO2."BIPO Type"::FixedDim);
                            if lrec_BIPO2.FindSet() then begin
                                repeat
                                    // Clear(ListDim);
                                    // repeat
                                    //     ListDim += lrec_BIPO2."Dimension Code" + '|';
                                    //     ListDimVal += lrec_BIPO2."Dimension Value" + '|';
                                    // until lrec_BIPO2.Next() = 0;
                                    // ListDim := CopyStr(ListDim,1,StrLen(ListDim)-1);
                                    // ListDimVal := CopyStr(ListDimVal,1,StrLen(ListDimVal)-1);
                                    // lrec_DimSetEntry.Reset();
                                    // lrec_DimSetEntry.SetRange("Dimension Code", lrec_BIPO2."Dimension Code");
                                    // lrec_DimSetEntry.SetRange("Dimension Value Code", lrec_BIPO2."Dimension Value");
                                    // if lrec_DimSetEntry.FindSet() then begin
                                    //     repeat
                                    //         lrec_DimSetCount.Reset();
                                    //         lrec_DimSetCount.SetRange("Dimension Set ID", lrec_DimSetEntry."Dimension Set ID");
                                    //         if lrec_DimSetCount.Count = 1 then begin
                                    //             lrec_GJL.Validate("Dimension Set ID", lrec_DimSetCount."Dimension Set ID");
                                    //             lrec_GJL.Modify(true);
                                    //         end;
                                    //     until (lrec_DimSetCount.Count = 1) or (lrec_DimSetEntry.Next() = 0);

                                    DimMgt.GetDimensionSet(TempDimSetEntry, lrec_GJL."Dimension Set ID");
                                    TempDimSetEntry.Init;
                                    TempDimSetEntry.VALIDATE("Dimension Code", lrec_BIPO2."Dimension Code");
                                    TempDimSetEntry.VALIDATE("Dimension Value Code", lrec_BIPO2."Dimension Value");
                                    if not TempDimSetEntry.INSERT then
                                        TempDimSetEntry.Modify;
                                    lrec_GJL.Validate("Dimension Set ID", DimMgt.GetDimensionSetID(TempDimSetEntry));
                                    lrec_GJL.MODIFY(true);
                                until lrec_BIPO2.Next() = 0;

                                // Commit();
                            end;

                            lrec_BIPO.Reset();
                            lrec_BIPO.SetRange("BIPO Type", lrec_BIPO."BIPO Type"::ColumnID);
                            lrec_BIPO.SetRange("BIPO Code", grec_Temp.Text2);
                            if lrec_BIPO.FindFirst() then begin
                                DimMgt.GetDimensionSet(TempDimSetEntry, lrec_GJL."Dimension Set ID");
                                TempDimSetEntry.Init;
                                TempDimSetEntry.VALIDATE("Dimension Code", lrec_BIPO."Dimension Code");
                                TempDimSetEntry.VALIDATE("Dimension Value Code", lrec_BIPO."Dimension Value");
                                if not TempDimSetEntry.INSERT then
                                    TempDimSetEntry.Modify;
                                lrec_GJL.Validate("Dimension Set ID", DimMgt.GetDimensionSetID(TempDimSetEntry));
                                lrec_GJL.MODIFY(true);

                                // Commit();
                            end;

                            Commit();
                        end;
                    end;
                end;


            until grec_Temp.Next() = 0;
        end;
        // Insert Into GJL <<

        Message('File Imported');
    end;

    // YF 29 Nov 2021
    /*
    // YF 18 Nov 2021 // Peg Data Transfer from Sales Header to Cust. Ledger Entries
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeRunGenJnlPostLine', '', false, false)]
    local procedure OnBeforeRunGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line"; SalesInvHeader: Record "Sales Invoice Header")
    var
        CompanyInfoRec: Record "Company Information";
    begin
        CompanyInfoRec.Get;

        if CompanyInfoRec."Enable Peg Rate Module" then begin
            GenJnlLine."Peg Rate" := SalesInvHeader."Peg Rate";
            GenJnlLine."VND Amount" := SalesInvHeader."VND Amount";
            GenJnlLine."VND-LCY Rate" := SalesInvHeader."VND-LCY Rate";
            GenJnlLine."Peg SGD Amount" := SalesInvHeader."Peg SGD Amount";
            GenJnlLine."FCY-LCY Rate" := SalesInvHeader."FCY-LCY Rate";
            GenJnlLine."LCY Amount" := SalesInvHeader."LCY Amount";
            GenJnlLine.Adjustment := SalesInvHeader.Adjustment;
            if GenJnlLine.Modify(false) then begin end;
        end;

    end;
    */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitCustLedgEntry', '', false, false)]
    local procedure OnAfterInitCustLedgEntry(VAR CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line");
    var
        CompanyInfoRec: Record "Company Information";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCMHeader: Record "Sales Cr.Memo Header";
        NotTriggered: Boolean;

        // YF 19 Jan 2022 // Recalculate based on Qty to Invoice
        Recompute_VNDAmount: Decimal;
        Recompute_PegSGDAmount: Decimal;
        Recompute_LCYAmount: Decimal;
        Recompute_Adjustment: Decimal;
    // YF 19 Jan 2022 // Recalculate based on Qty to Invoice
    begin
        NotTriggered := true;
        CompanyInfoRec.Get;

        if CompanyInfoRec."Enable Peg Rate Module" then begin

            if CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice then begin
                SalesInvHeader.Reset;
                if SalesInvHeader.Get(CustLedgerEntry."Document No.") then begin

                    // YF 19 Jan 2022
                    SalesInvHeader.CalcFields(Amount);
                    Recompute_VNDAmount := SalesInvHeader.Amount * SalesInvHeader."Peg Rate";
                    if SalesInvHeader."VND-LCY Rate" <> 0 then
                        Recompute_PegSGDAmount := Recompute_VNDAmount / SalesInvHeader."VND-LCY Rate";
                    if SalesInvHeader."Currency Factor" <> 0 then
                        Recompute_LCYAmount := SalesInvHeader.Amount / SalesInvHeader."Currency Factor"
                    else
                        Recompute_LCYAmount := SalesInvHeader.Amount; // YF 14 Apr 2022
                    Recompute_Adjustment := Recompute_PegSGDAmount - Recompute_LCYAmount;
                    // YF 19 Jan 2022                 

                    // Peg Rate
                    CustLedgerEntry."Peg Rate" := SalesInvHeader."Peg Rate";
                    CustLedgerEntry."VND-LCY Rate" := SalesInvHeader."VND-LCY Rate";
                    CustLedgerEntry."FCY-LCY Rate" := SalesInvHeader."FCY-LCY Rate";
                    CustLedgerEntry."Peg Rate of Invoice" := SalesInvHeader."Peg Rate"; // YF 08 Dec 2021
                                                                                        // Peg Rate

                    // YF 19 Jan 2022
                    CustLedgerEntry."VND Amount" := Recompute_VNDAmount;
                    CustLedgerEntry."Peg SGD Amount" := Recompute_PegSGDAmount;
                    CustLedgerEntry."LCY Amount" := Recompute_LCYAmount;
                    CustLedgerEntry.Adjustment := Recompute_Adjustment;
                    /*
                    CustLedgerEntry."VND Amount" := SalesInvHeader."VND Amount";
                    CustLedgerEntry."Peg SGD Amount" := SalesInvHeader."Peg SGD Amount";
                    CustLedgerEntry."LCY Amount" := SalesInvHeader."LCY Amount";
                    CustLedgerEntry.Adjustment := SalesInvHeader.Adjustment;
                    */
                    // YF 19 Jan 2022

                    NotTriggered := false;
                end;
            end;

            if CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::"Credit Memo" then begin
                SalesCMHeader.Reset;
                if SalesCMHeader.Get(CustLedgerEntry."Document No.") then begin

                    // YF 19 Jan 2022
                    SalesCMHeader.CalcFields(Amount);
                    Recompute_VNDAmount := SalesCMHeader.Amount * SalesCMHeader."Peg Rate";
                    if SalesCMHeader."VND-LCY Rate" <> 0 then // YF 09 Mar 2022 // Bug Fix
                        Recompute_PegSGDAmount := Recompute_VNDAmount / SalesCMHeader."VND-LCY Rate";
                    if SalesCMHeader."Currency Factor" <> 0 then // YF 09 Mar 2022 // Bug Fix
                        Recompute_LCYAmount := SalesCMHeader.Amount / SalesCMHeader."Currency Factor"
                    else
                        Recompute_LCYAmount := SalesCMHeader.Amount; // YF 14 Apr 2022
                    Recompute_Adjustment := Recompute_PegSGDAmount - Recompute_LCYAmount;
                    // YF 19 Jan 2022      

                    // Peg Rate
                    CustLedgerEntry."Peg Rate" := SalesCMHeader."Peg Rate";
                    CustLedgerEntry."VND-LCY Rate" := SalesCMHeader."VND-LCY Rate";
                    CustLedgerEntry."FCY-LCY Rate" := SalesCMHeader."FCY-LCY Rate";
                    // CustLedgerEntry.Adjustment := SalesCMHeader.Adjustment;
                    CustLedgerEntry."Peg Rate of Invoice" := SalesCMHeader."Peg Rate"; // YF 08 Dec 2021
                                                                                       // Peg Rate

                    // YF 19 Jan 2022
                    CustLedgerEntry."VND Amount" := Recompute_VNDAmount * -1;
                    CustLedgerEntry."Peg SGD Amount" := Recompute_PegSGDAmount * -1;
                    CustLedgerEntry."LCY Amount" := Recompute_LCYAmount * -1;
                    CustLedgerEntry.Adjustment := (Recompute_PegSGDAmount * -1) - (Recompute_LCYAmount * -1);
                    /*
                    CustLedgerEntry."VND Amount" := SalesCMHeader."VND Amount" * -1;
                    CustLedgerEntry."Peg SGD Amount" := SalesCMHeader."Peg SGD Amount" * -1;
                    CustLedgerEntry."LCY Amount" := SalesCMHeader."LCY Amount" * -1;
                    CustLedgerEntry.Adjustment := (SalesCMHeader."Peg SGD Amount" * -1) - (SalesCMHeader."LCY Amount" * -1);
                    */
                    // YF 19 Jan 2022

                    NotTriggered := false;
                end;
            end;

            if NotTriggered then begin
                // Peg Rate
                CustLedgerEntry."Peg Rate" := GenJournalLine."Peg Rate";
                CustLedgerEntry."VND Amount" := GenJournalLine."VND Amount";
                CustLedgerEntry."VND-LCY Rate" := GenJournalLine."VND-LCY Rate";
                CustLedgerEntry."Peg SGD Amount" := GenJournalLine."Peg SGD Amount";
                CustLedgerEntry."FCY-LCY Rate" := GenJournalLine."FCY-LCY Rate";
                CustLedgerEntry."LCY Amount" := GenJournalLine."LCY Amount";
                CustLedgerEntry.Adjustment := GenJournalLine.Adjustment;
                CustLedgerEntry."Peg Rate of Invoice" := GenJournalLine."Peg Rate"; // YF 08 Dec 2021
                                                                                    // Peg Rate
            end;

            // Paid Rate // YF 23 Nov 2021
            CustLedgerEntry."Peg Rate of Invoice" := GenJournalLine."Peg Rate of Invoice";
            CustLedgerEntry."VND Paid Rate" := GenJournalLine."VND Paid Rate";
            CustLedgerEntry."Paid VND" := GenJournalLine."Paid VND";
            CustLedgerEntry."Difference VND" := GenJournalLine."Difference VND";
            CustLedgerEntry."Exchange Variable" := GenJournalLine."Exchange Variable";
            CustLedgerEntry."Exchange Variable Settlement" := GenJournalLine."Exchange Variable Settlement";
            // Paid Rate // YF 23 Nov 2021
        end;
    end;


    // Paid Rate // YF 23 Nov 2021
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Apply", 'OnApplyCustomerLedgerEntryOnBeforeModify', '', false, false)]
    local procedure OnApplyCustomerLedgerEntryOnBeforeModify(var GenJnlLine: Record "Gen. Journal Line"; CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        CompanyInfoRec: Record "Company Information";
    begin
        CompanyInfoRec.Get;

        if CompanyInfoRec."Enable Peg Rate Module" then begin
            GenJnlLine."Peg Rate of Invoice" := CustLedgerEntry."Peg Rate"; // get peg rate from invoice
                                                                            // YF 08 Dec 2021
            if CustLedgerEntry."Peg Rate" = 0 then
                GenJnlLine."Peg Rate of Invoice" := CustLedgerEntry."Peg Rate of Invoice";
            // YF 08 Dec 2021
        end;

    end;
    // Paid Rate // YF 23 Nov 2021

    // Cash Receipt Journal Exchange Settlement // YF 29 Nov 2021
    procedure ProcessExchangeSettlementLines(var GenJnlLines: Record "Gen. Journal Line"): Boolean
    var
        CompanyInfoRec: Record "Company Information";
        ProcessedCounter: Integer;
        NewGenJnlLine: Record "Gen. Journal Line";
        Amount: Decimal;
        AmountLCY: Decimal;
        ExchVariable: Decimal;
        ExchVariableSettle: Decimal;
    begin
        CompanyInfoRec.Get;
        ProcessedCounter := 0;

        if (Not CompanyInfoRec."Enable Peg Rate Module") Or (CompanyInfoRec."Exch. Var. Settlement Account" = '') then
            exit(false);

        if GenJnlLines.FindSet() then
            repeat
                Amount := GenJnlLines.Amount;
                AmountLCY := GenJnlLines."Amount (LCY)";
                //RL    06 Apr 2022 - Start
                ExchVariable := GenJnlLines."Exchange Variable" * -1;
                ExchVariableSettle := GenJnlLines."Exchange Variable Settlement" * -1;
                if ExchVariable = 0 then
                    Error('No exchage Variable');
                //RL    06 Apr 2022 - End

                //RL    04 Apr 2022 - Start
                // GenJnlLines.Validate(Amount, Amount - ExchVariable); // YF 08 Dec 2021
                // GenJnlLines.Validate("Amount (LCY)", AmountLCY - ExchVariableSettle); // YF 08 Dec 2021
                // GenJnlLines.Modify(true); // YF 08 Dec 2021
                //RL    04 Apr 2022 - End

                NewGenJnlLine.Init();
                NewGenJnlLine.TransferFields(GenJnlLines);
                NewGenJnlLine.Validate("Line No.", NewGenJnlLine."Line No." + 5000);
                //RL    06 Apr 2022 - Start
                if ExchVariable < 0 then
                    NewGenJnlLine.Validate("Document Type", NewGenJnlLine."Document Type"::"Credit Memo")
                else begin
                    NewGenJnlLine.Validate("Document Type", NewGenJnlLine."Document Type"::Invoice);
                    NewGenJnlLine.Validate("Applies-to Doc. No.", '');
                end;
                //RL    06 Apr 2022 - End
                NewGenJnlLine.Validate("Bal. Account Type", NewGenJnlLine."Bal. Account Type"::"G/L Account");
                NewGenJnlLine.Validate("Bal. Account No.", CompanyInfoRec."Exch. Var. Settlement Account");

                if NewGenJnlLine.Insert(true) then begin
                    NewGenJnlLine.Validate("Currency Code", GenJnlLines."Currency Code");
                    NewGenJnlLine.Validate(Amount, ExchVariable);
                    NewGenJnlLine.Validate("Amount (LCY)", ExchVariableSettle);
                    // NewGenJnlLine.CalculateVNDPaidRate();
                    NewGenJnlLine.Modify();
                    ProcessedCounter += 1;
                end;


            until GenJnlLines.Next() = 0;

        if ProcessedCounter > 0 then
            exit(true);

        exit(false);
    end;
    // Cash Receipt Journal Exchange Settlement // YF 29 Nov 2021

    // YF 08 Dec 2021
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnLookUpAppliesToDocCustOnAfterUpdateDocumentTypeAndAppliesTo', '', false, false)]
    local procedure OnLookUpAppliesToDocCustOnAfterUpdateDocumentTypeAndAppliesTo(var GenJournalLine: Record "Gen. Journal Line"; CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        CompanyInfoRec: Record "Company Information";
    begin
        CompanyInfoRec.Get;

        if CompanyInfoRec."Enable Peg Rate Module" then begin
            // make sure peg rate from invoice is updated
            if GenJournalLine."Peg Rate of Invoice" = 0 then begin
                GenJournalLine."Peg Rate of Invoice" := CustLedgerEntry."Peg Rate";
                if CustLedgerEntry."Peg Rate" = 0 then
                    GenJournalLine."Peg Rate of Invoice" := CustLedgerEntry."Peg Rate of Invoice";
            end;
            // make sure peg rate from invoice is updated

            GenJournalLine.CalculateVNDPaidRate(); // trigger calculations again
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnSetJournalLineFieldsFromApplicationOnAfterFindFirstCustLedgEntryWithAppliesToDocNo', '', false, false)]
    local procedure OnSetJournalLineFieldsFromApplicationOnAfterFindFirstCustLedgEntryWithAppliesToDocNo(var GenJournalLine: Record "Gen. Journal Line"; CustLedgEntry: Record "Cust. Ledger Entry");
    var
        CompanyInfoRec: Record "Company Information";
    begin
        CompanyInfoRec.Get;

        if CompanyInfoRec."Enable Peg Rate Module" then begin
            // make sure peg rate from invoice is updated
            if GenJournalLine."Peg Rate of Invoice" = 0 then begin
                GenJournalLine."Peg Rate of Invoice" := CustLedgEntry."Peg Rate";
                if CustLedgEntry."Peg Rate" = 0 then
                    GenJournalLine."Peg Rate of Invoice" := CustLedgEntry."Peg Rate of Invoice";
            end;
            // make sure peg rate from invoice is updated

            GenJournalLine.CalculateVNDPaidRate(); // trigger calculations again
        end;
    end;
    // YF 08 Dec 2021

    // YF 19 Jan 2022
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean)
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesInvHeader: Record "Sales Invoice Header";
        CompanyInfoRec: Record "Company Information";
        Recompute_VNDAmount: Decimal;
        Recompute_PegSGDAmount: Decimal;
        Recompute_LCYAmount: Decimal;
        Recompute_Adjustment: Decimal;
    begin
        CompanyInfoRec.Get;

        if CompanyInfoRec."Enable Peg Rate Module" then begin

            if SalesInvHeader.Get(SalesInvHdrNo) then begin
                SalesInvHeader.CalcFields(Amount);
                Recompute_VNDAmount := SalesInvHeader.Amount * SalesInvHeader."Peg Rate";
                if SalesInvHeader."VND-LCY Rate" <> 0 then
                    Recompute_PegSGDAmount := Recompute_VNDAmount / SalesInvHeader."VND-LCY Rate";
                if SalesInvHeader."Currency Factor" <> 0 then
                    Recompute_LCYAmount := SalesInvHeader.Amount / SalesInvHeader."Currency Factor"
                else
                    Recompute_LCYAmount := SalesInvHeader.Amount; // YF 14 Apr 2022
                Recompute_Adjustment := Recompute_PegSGDAmount - Recompute_LCYAmount;

                SalesInvHeader."VND Amount" := Recompute_VNDAmount;
                SalesInvHeader."Peg SGD Amount" := Recompute_PegSGDAmount;
                SalesInvHeader."LCY Amount" := Recompute_LCYAmount;
                SalesInvHeader.Adjustment := Recompute_Adjustment;

                SalesInvHeader.Modify(false);
            end;

            if SalesCrMemoHeader.Get(SalesCrMemoHdrNo) then begin
                SalesCrMemoHeader.CalcFields(Amount);
                Recompute_VNDAmount := SalesCrMemoHeader.Amount * SalesCrMemoHeader."Peg Rate";
                if SalesCrMemoHeader."VND-LCY Rate" <> 0 then
                    Recompute_PegSGDAmount := Recompute_VNDAmount / SalesCrMemoHeader."VND-LCY Rate";
                if SalesCrMemoHeader."Currency Factor" <> 0 then
                    Recompute_LCYAmount := SalesCrMemoHeader.Amount / SalesCrMemoHeader."Currency Factor"
                else
                    Recompute_LCYAmount := SalesCrMemoHeader.Amount; // YF 14 Apr 2022
                Recompute_Adjustment := Recompute_PegSGDAmount - Recompute_LCYAmount;

                SalesCrMemoHeader."VND Amount" := Recompute_VNDAmount * -1;
                SalesCrMemoHeader."Peg SGD Amount" := Recompute_PegSGDAmount * -1;
                SalesCrMemoHeader."LCY Amount" := Recompute_LCYAmount * -1;
                SalesCrMemoHeader.Adjustment := (Recompute_PegSGDAmount * -1) - (Recompute_LCYAmount * -1);

                SalesCrMemoHeader.Modify(false);
            end;

        end;
    end;
    // YF 19 Jan 2022

    // YF 14 Feb 2022 // Limited Access
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", 'OnBeforeCode', '', false, false)]
    local procedure OnBeforeCode(var GenJournalLine: Record "Gen. Journal Line"; var HideDialog: Boolean)
    var
        // LimitedAccessQuery: Query "Limited Group List Query"; // YF 14 Oct 2024
        // LimitedAccessFilterString: Text;
        CopyOfGenJnlLineRec: Record "Gen. Journal Line";
        ListofDimValue: List of [Text];
        GotMatch: Boolean;
        DimSetEntryRec: Record "Dimension Set Entry";
    begin
        // filtering for HPPL Limited Access
        Clear(CopyOfGenJnlLineRec);
        // Clear(LimitedAccessQuery); // YF 14 Oct 2024
        Clear(ListofDimValue);
        // Clear(LimitedAccessFilterString);

        // YF 14 Oct 2024
        /*
        CopyOfGenJnlLineRec.Copy(GenJournalLine);

        LimitedAccessQuery.SetRange(User_Name_Filter, UserId);
        LimitedAccessQuery.SetRange(HPPL_Limit_Access_Filter, true);
        LimitedAccessQuery.Open();
        while LimitedAccessQuery.Read() do begin
            ListofDimValue.Add(LimitedAccessQuery.Group_Code);
        end;

        if (CopyOfGenJnlLineRec.FindSet()) And (ListofDimValue.Count > 0) then
            repeat
                // check matching dim 3
                GotMatch := false;
                DimSetEntryRec.Reset;
                DimSetEntryRec.SetRange("Dimension Set ID", CopyOfGenJnlLineRec."Dimension Set ID");
                DimSetEntryRec.SetRange("Global Dimension No.", 3);
                if DimSetEntryRec.FindSet() then
                    repeat
                        if Not GotMatch then
                            GotMatch := ListofDimValue.Contains(DimSetEntryRec."Dimension Value Code");
                    until DimSetEntryRec.Next() = 0;

                if Not GotMatch then
                    Error('Please check Business Unit Dimension Code Value');

            until CopyOfGenJnlLineRec.Next() = 0;
        // filtering for HPPL Limited Access
        */
        // YF 14 Oct 2024
    end;
    // YF 14 Feb 2022 // Limited Access

    // YF 22 Aug 2022
    /*  
        =====================================
        Usage Example
        =====================================
        Clear(TestRecRef);
        SalesHdrRec.Reset;
        if SalesHdrRec.FindFirst() then begin
            TestRecRef.GetTable(SalesHdrRec);
            Message(Format(CUTest.GetVATPercentFromDocument(TestRecRef)));
        end;
        Clear(TestRecRef);
        TestRecRef.Close();
    */
    procedure GetVATPercentFromDocument(var SourceRecRef: RecordRef) VATPercent: Decimal;
    var
        RetVATPercent: Decimal;
        PurchLine: Record "Purchase Line";
        SalesLine: Record "Sales Line";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        ServiceLine: Record "Service Line";
        ServiceInvLine: Record "Service Invoice Line";
        ServiceCrMemoLine: Record "Service Cr.Memo Line";
    begin
        // Message(Format(SourceRecRef.RecordId));
        case SourceRecRef.Number of
            81:
                begin
                    // Gen. Journal Line // "Journal Template Name", "Journal Batch Name", "Line No."
                    /*
                    Message(Format(SourceRecRef.Field(1))); // Journal Template Name
                    Message(Format(SourceRecRef.Field(2))); // Line No
                    Message(Format(SourceRecRef.Field(51))); // Journal Batch Name
                    Message(Format(SourceRecRef.Field(10))); // VAT %
                    */
                    RetVATPercent := SourceRecRef.Field(10).Value;
                end;
            38:
                begin
                    // Purchase Header // Document Type, No.
                    PurchLine.Reset;
                    PurchLine.SetRange("Document Type", SourceRecRef.Field(1).Value);
                    PurchLine.SetRange("Document No.", SourceRecRef.Field(3).Value);
                    PurchLine.SetFilter("VAT %", '<>%1', 0);
                    if PurchLine.FindFirst() then begin
                        RetVATPercent := PurchLine."VAT %";
                    end;
                end;
            36:
                begin
                    // Sales Header / /Document Type, No.
                    SalesLine.Reset;
                    SalesLine.SetRange("Document Type", SourceRecRef.Field(1).Value);
                    SalesLine.SetRange("Document No.", SourceRecRef.Field(3).Value);
                    SalesLine.SetFilter("VAT %", '<>%1', 0);
                    if SalesLine.FindFirst() then begin
                        RetVATPercent := SalesLine."VAT %";
                    end;
                end;
            122:
                begin
                    // Posted Purchase Invoice Header
                    PurchInvLine.Reset;
                    PurchInvLine.SetRange("Document No.", SourceRecRef.Field(3).Value);
                    PurchInvLine.SetFilter("VAT %", '<>%1', 0);
                    PurchInvLine.SetFilter(Quantity, '<>%1', 0);
                    if PurchInvLine.FindFirst() then begin
                        RetVATPercent := PurchInvLine."VAT %";
                    end;
                end;
            124:
                begin
                    // Posted Purchase Credit Memo Header
                    PurchCrMemoLine.Reset;
                    PurchCrMemoLine.SetRange("Document No.", SourceRecRef.Field(3).Value);
                    PurchCrMemoLine.SetFilter("VAT %", '<>%1', 0);
                    PurchCrMemoLine.SetFilter(Quantity, '<>%1', 0);
                    if PurchCrMemoLine.FindFirst() then begin
                        RetVATPercent := PurchCrMemoLine."VAT %";
                    end;
                end;
            112:
                begin
                    // Posted Sales Invoice Header
                    SalesInvLine.Reset;
                    SalesInvLine.SetRange("Document No.", SourceRecRef.Field(3).Value);
                    SalesInvLine.SetFilter("VAT %", '<>%1', 0);
                    SalesInvLine.SetFilter(Quantity, '<>%1', 0);
                    if SalesInvLine.FindFirst() then begin
                        RetVATPercent := SalesInvLine."VAT %";
                    end;
                end;
            114:
                begin
                    // Posted Sales Credit Memo Header
                    SalesCrMemoLine.Reset;
                    SalesCrMemoLine.SetRange("Document No.", SourceRecRef.Field(3).Value);
                    SalesCrMemoLine.SetFilter("VAT %", '<>%1', 0);
                    SalesCrMemoLine.SetFilter(Quantity, '<>%1', 0);
                    if SalesCrMemoLine.FindFirst() then begin
                        RetVATPercent := SalesCrMemoLine."VAT %";
                    end;
                end;
            5900:
                begin
                    // Service Header
                    ServiceLine.Reset;
                    ServiceLine.SetRange("Document Type", SourceRecRef.Field(1).Value);
                    ServiceLine.SetRange("Document No.", SourceRecRef.Field(3).Value);
                    ServiceLine.SetFilter("VAT %", '<>%1', 0);
                    if ServiceLine.FindFirst() then begin
                        RetVATPercent := ServiceLine."VAT %";
                    end;
                end;
            5992:
                begin
                    // Posted Service Invoice Header
                    ServiceInvLine.Reset;
                    ServiceInvLine.SetRange("Document No.", SourceRecRef.Field(3).Value);
                    ServiceInvLine.SetFilter("VAT %", '<>%1', 0);
                    ServiceInvLine.SetFilter(Quantity, '<>%1', 0);
                    if ServiceInvLine.FindFirst() then begin
                        RetVATPercent := ServiceInvLine."VAT %";
                    end;
                end;
            5994:
                begin
                    // Posted Service Credit Memo Header
                    ServiceCrMemoLine.Reset;
                    ServiceCrMemoLine.SetRange("Document No.", SourceRecRef.Field(3).Value);
                    ServiceCrMemoLine.SetFilter("VAT %", '<>%1', 0);
                    ServiceCrMemoLine.SetFilter(Quantity, '<>%1', 0);
                    if ServiceCrMemoLine.FindFirst() then begin
                        RetVATPercent := ServiceCrMemoLine."VAT %";
                    end;
                end;
            else
                RetVATPercent := 0;
        end;

        VATPercent := RetVATPercent;
    end;
    // YF 22 Aug 2022

    [EventSubscriber(ObjectType::Page, Page::"Posted Purch. Invoice - Update", 'OnAfterRecordChanged', '', false, false)]
    local procedure OnAfterRecordChanged(var PurchInvHeader: Record "Purch. Inv. Header"; xPurchInvHeader: Record "Purch. Inv. Header"; var IsChanged: Boolean; xPurchInvHeaderGlobal: Record "Purch. Inv. Header")
    begin
        if IsChanged = false then begin
            IsChanged :=
                (PurchInvHeader."Freight Forwarder" <> xPurchInvHeaderGlobal."Freight Forwarder") or
                (PurchInvHeader."Freight Forwarder Invoice No." <> xPurchInvHeaderGlobal."Freight Forwarder Invoice No.") or
                (PurchInvHeader."Actual ETD" <> xPurchInvHeaderGlobal."Actual ETD") or
                (PurchInvHeader."Actual ETA-Port" <> xPurchInvHeaderGlobal."Actual ETA-Port") or
                (PurchInvHeader."Shipment Temperature Status" <> xPurchInvHeaderGlobal."Shipment Temperature Status");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Inv. Header - Edit", 'OnBeforePurchInvHeaderModify', '', false, false)]
    local procedure OnBeforePurchInvHeaderModify(var PurchInvHeader: Record "Purch. Inv. Header"; PurchInvHeaderRec: Record "Purch. Inv. Header")
    begin
        PurchInvHeader.Validate("Freight Forwarder", PurchInvHeaderRec."Freight Forwarder");
        PurchInvHeader.Validate("Freight Forwarder Invoice No.", PurchInvHeaderRec."Freight Forwarder Invoice No.");
        PurchInvHeader.Validate("Actual ETD", PurchInvHeaderRec."Actual ETD");
        PurchInvHeader.Validate("Actual ETA-Port", PurchInvHeaderRec."Actual ETA-Port");
        PurchInvHeader.Validate("Shipment Temperature Status", PurchInvHeaderRec."Shipment Temperature Status");
    end;

    [EventSubscriber(ObjectType::Page, Page::"Pstd. Sales Cr. Memo - Update", 'OnAfterRecordChanged', '', false, false)]
    local procedure PstdSalesCrMemoUpdate_OnAfterRecordChanged(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; xSalesCrMemoHeader: Record "Sales Cr.Memo Header"; var IsChanged: Boolean)
    begin
        if IsChanged = false then begin
            IsChanged := SalesCrMemoHeader."External Document No." <> xSalesCrMemoHeader."External Document No.";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Credit Memo Hdr. - Edit", 'OnBeforeSalesCrMemoHeaderModify', '', false, false)]
    procedure OnBeforeSalesCrMemoHeaderModify(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; FromSalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        SalesCrMemoHeader."External Document No." := FromSalesCrMemoHeader."External Document No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeValidatePromisedReceiptDate', '', false, false)]
    local procedure OnBeforeValidatePromisedReceiptDate(var PurchaseLine: Record "Purchase Line"; CallingFieldNo: Integer; var IsHandled: Boolean; xPurchaseLine: Record "Purchase Line")
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInitHeaderDefaults', '', false, false)]
    local procedure OnAfterInitHeaderDefaults(var PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header"; var TempPurchLine: record "Purchase Line" temporary)
    begin
        PurchLine."Shipment Method Code" := PurchHeader."Shipment Method Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnUpdatePurchLinesByChangedFieldName', '', false, false)]
    local procedure OnUpdatePurchLinesByChangedFieldName(PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; ChangedFieldName: Text[100]; ChangedFieldNo: Integer; xPurchaseHeader: Record "Purchase Header")
    begin
        if PurchLine."No." <> '' then
            PurchLine.Validate("Shipment Method Code", PurchHeader."Shipment Method Code");
    end;
}