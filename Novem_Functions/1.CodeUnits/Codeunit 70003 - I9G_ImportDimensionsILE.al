codeunit 70003 I9G_ImportDimensionsILE
{
    Description = 'Function - Import Dimensions for General Ledger Entry and update Dimension Set ID';
    Permissions = tabledata "Item Ledger Entry" = rm, tabledata "G/L Entry" = rm, tabledata "Value Entry" = rm, tabledata "Item Application Entry" = rm;

    procedure GetValueAtCell(StartFromRow: Integer; StartFromCol: Integer): Text
    begin
        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(StartFromRow, StartFromCol) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    procedure ImportExcel()
    var
        ImportFileName: Text;
        ImportStream: InStream;
        Sheetname: Text;
        StartFromRow: Integer;
        StartFromCol: Integer;
        TotalRows: Integer;
        FirstColumnText: Text;
        EntryNo: Integer;
        FromFile: Text[250];
        FileName: Text[250];
        FileMgt: Codeunit "File Management";
        ILERec: Record "Item Ledger Entry";
        ValueEntryRec: Record "Value Entry";
        GLEntryRec: Record "G/L Entry";
        GLItemLedgerRelationRec: Record "G/L - Item Ledger Relation";
        DimensionManagementCodeUnit: Codeunit DimensionManagement;
        UploadExcelMsg: Label 'Please Choose the Excel file...';
        NoFileFoundMsg: Label 'No Excel file found!';
        ExcelImportSucess: Label 'Excel is successfully imported.';
    begin
        TempExcelBuffer.DeleteAll();
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, ImportStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            Sheetname := TempExcelBuffer.SelectSheetsNameStream(ImportStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.OpenBookStream(ImportStream, Sheetname);
        TempExcelBuffer.ReadSheet();
        if TempExcelBuffer.FindLast() then
            TotalRows := TempExcelBuffer."Row No.";

        for StartFromRow := 2 to TotalRows do begin
            Clear(EntryNo);
            Evaluate(EntryNo, GetValueAtCell(StartFromRow, 1));
            ILERec.Reset();
            ILERec.SetRange("Entry No.", EntryNo);
            if ILERec.FindFirst() then begin
                ILERec."Global Dimension 1 Code" := GetValueAtCell(StartFromRow, 2);
                ILERec."Global Dimension 2 Code" := GetValueAtCell(StartFromRow, 3);
                ILERec."Shortcut Dimension 3 Code" := GetValueAtCell(StartFromRow, 4);
                DimensionManagementCodeUnit.ValidateShortcutDimValues(3, ILERec."Shortcut Dimension 3 Code", ILERec."Dimension Set ID");
                ILERec."Shortcut Dimension 4 Code" := GetValueAtCell(StartFromRow, 5);
                DimensionManagementCodeUnit.ValidateShortcutDimValues(4, ILERec."Shortcut Dimension 4 Code", ILERec."Dimension Set ID");
                ILERec."Shortcut Dimension 5 Code" := GetValueAtCell(StartFromRow, 6);
                DimensionManagementCodeUnit.ValidateShortcutDimValues(5, ILERec."Shortcut Dimension 5 Code", ILERec."Dimension Set ID");
                ILERec."Shortcut Dimension 6 Code" := GetValueAtCell(StartFromRow, 7);
                DimensionManagementCodeUnit.ValidateShortcutDimValues(6, ILERec."Shortcut Dimension 6 Code", ILERec."Dimension Set ID");
                ILERec."Shortcut Dimension 7 Code" := GetValueAtCell(StartFromRow, 8);
                DimensionManagementCodeUnit.ValidateShortcutDimValues(7, ILERec."Shortcut Dimension 7 Code", ILERec."Dimension Set ID");
                ILERec."Shortcut Dimension 8 Code" := GetValueAtCell(StartFromRow, 9);
                DimensionManagementCodeUnit.ValidateShortcutDimValues(8, ILERec."Shortcut Dimension 8 Code", ILERec."Dimension Set ID");
                updateDimensionSetIDEntry(ILERec);
                ILERec.Modify();

                ValueEntryRec.Reset();
                ValueEntryRec.SetRange("Item Ledger Entry Type", ILERec."Entry Type");
                ValueEntryRec.SetRange("Item Ledger Entry No.", ILERec."Entry No.");
                if ValueEntryRec.FindSet() then begin
                    repeat
                        ValueEntryRec."Global Dimension 1 Code" := ILERec."Global Dimension 1 Code";
                        ValueEntryRec."Global Dimension 2 Code" := ILERec."Global Dimension 2 Code";
                        ValueEntryRec."Shortcut Dimension 3 Code" := ILERec."Shortcut Dimension 3 Code";
                        ValueEntryRec."Shortcut Dimension 4 Code" := ILERec."Shortcut Dimension 4 Code";
                        ValueEntryRec."Shortcut Dimension 5 Code" := ILERec."Shortcut Dimension 5 Code";
                        ValueEntryRec."Shortcut Dimension 6 Code" := ILERec."Shortcut Dimension 6 Code";
                        ValueEntryRec."Shortcut Dimension 7 Code" := ILERec."Shortcut Dimension 7 Code";
                        ValueEntryRec."Shortcut Dimension 8 Code" := ILERec."Shortcut Dimension 8 Code";
                        ValueEntryRec.Validate("Dimension Set ID", ILERec."Dimension Set ID");
                        ValueEntryRec.Modify();
                        GLItemLedgerRelationRec.Reset();
                        GLEntryRec.Reset();
                        GLItemLedgerRelationRec.SetRange("Value Entry No.", ValueEntryRec."Entry No.");
                        if GLItemLedgerRelationRec.FindSet() then
                            repeat
                                GLEntryRec.SetRange("Entry No.", GLItemLedgerRelationRec."G/L Entry No.");
                                if GLEntryRec.FindFirst() then begin
                                    GLEntryRec."Global Dimension 1 Code" := ValueEntryRec."Global Dimension 1 Code";
                                    GLEntryRec."Global Dimension 2 Code" := ValueEntryRec."Global Dimension 2 Code";
                                    GLEntryRec."Shortcut Dimension 3 Code" := ValueEntryRec."Shortcut Dimension 3 Code";
                                    GLEntryRec."Shortcut Dimension 4 Code" := ValueEntryRec."Shortcut Dimension 4 Code";
                                    GLEntryRec."Shortcut Dimension 5 Code" := ValueEntryRec."Shortcut Dimension 5 Code";
                                    GLEntryRec."Shortcut Dimension 6 Code" := ValueEntryRec."Shortcut Dimension 6 Code";
                                    GLEntryRec."Shortcut Dimension 7 Code" := ValueEntryRec."Shortcut Dimension 7 Code";
                                    GLEntryRec."Shortcut Dimension 8 Code" := ValueEntryRec."Shortcut Dimension 8 Code";
                                    GLEntryRec.Validate("Dimension Set ID", ValueEntryRec."Dimension Set ID");
                                    GLEntryRec.Modify();
                                end;
                            until GLItemLedgerRelationRec.Next() = 0;
                    until ValueEntryRec.Next() = 0;
                end;
            end;
        end;
        Message(ExcelImportSucess);
    end;

    procedure updateDimensionSetIDEntry(var par_ILERec: Record "Item Ledger Entry")
    var
        GLSetup: Record "General Ledger Setup";
        DimensionManagementCodeUnit: Codeunit DimensionManagement;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        if TempDimSetEntry.IsTemporary then
            TempDimSetEntry.DeleteAll();

        GLSetup.Get();
        if par_ILERec."Global Dimension 1 Code" <> '' then begin
            DimensionManagementCodeUnit.GetDimensionSet(TempDimSetEntry, 0);
            TempDimSetEntry.Init;
            TempDimSetEntry.Validate("Dimension Code", GLSetup."Shortcut Dimension 1 Code");
            TempDimSetEntry.Validate("Dimension Value Code", par_ILERec."Global Dimension 1 Code");
            if not TempDimSetEntry.Insert then
                TempDimSetEntry.Modify;
            par_ILERec.Validate("Dimension Set ID", DimensionManagementCodeUnit.GetDimensionSetID(TempDimSetEntry));
        end;
        if par_ILERec."Global Dimension 2 Code" <> '' then begin
            DimensionManagementCodeUnit.GetDimensionSet(TempDimSetEntry, par_ILERec."Dimension Set ID");
            TempDimSetEntry.Init;
            TempDimSetEntry.Validate("Dimension Code", GLSetup."Shortcut Dimension 2 Code");
            TempDimSetEntry.Validate("Dimension Value Code", par_ILERec."Global Dimension 2 Code");
            if not TempDimSetEntry.Insert then
                TempDimSetEntry.Modify;
            par_ILERec.Validate("Dimension Set ID", DimensionManagementCodeUnit.GetDimensionSetID(TempDimSetEntry));
        end;
        if par_ILERec."Shortcut Dimension 3 Code" <> '' then begin
            DimensionManagementCodeUnit.GetDimensionSet(TempDimSetEntry, par_ILERec."Dimension Set ID");
            TempDimSetEntry.Init;
            TempDimSetEntry.Validate("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
            TempDimSetEntry.Validate("Dimension Value Code", par_ILERec."Shortcut Dimension 3 Code");
            if not TempDimSetEntry.Insert then
                TempDimSetEntry.Modify;
            par_ILERec.Validate("Dimension Set ID", DimensionManagementCodeUnit.GetDimensionSetID(TempDimSetEntry));
        end;
        if par_ILERec."Shortcut Dimension 4 Code" <> '' then begin
            DimensionManagementCodeUnit.GetDimensionSet(TempDimSetEntry, par_ILERec."Dimension Set ID");
            TempDimSetEntry.Init;
            TempDimSetEntry.Validate("Dimension Code", GLSetup."Shortcut Dimension 4 Code");
            TempDimSetEntry.Validate("Dimension Value Code", par_ILERec."Shortcut Dimension 4 Code");
            if not TempDimSetEntry.Insert then
                TempDimSetEntry.Modify;
            par_ILERec.Validate("Dimension Set ID", DimensionManagementCodeUnit.GetDimensionSetID(TempDimSetEntry));
        end;
        if par_ILERec."Shortcut Dimension 5 Code" <> '' then begin
            DimensionManagementCodeUnit.GetDimensionSet(TempDimSetEntry, par_ILERec."Dimension Set ID");
            TempDimSetEntry.Init;
            TempDimSetEntry.Validate("Dimension Code", GLSetup."Shortcut Dimension 5 Code");
            TempDimSetEntry.Validate("Dimension Value Code", par_ILERec."Shortcut Dimension 5 Code");
            if not TempDimSetEntry.Insert then
                TempDimSetEntry.Modify;
            par_ILERec.Validate("Dimension Set ID", DimensionManagementCodeUnit.GetDimensionSetID(TempDimSetEntry));
        end;
        if par_ILERec."Shortcut Dimension 6 Code" <> '' then begin
            DimensionManagementCodeUnit.GetDimensionSet(TempDimSetEntry, par_ILERec."Dimension Set ID");
            TempDimSetEntry.Init;
            TempDimSetEntry.Validate("Dimension Code", GLSetup."Shortcut Dimension 6 Code");
            TempDimSetEntry.Validate("Dimension Value Code", par_ILERec."Shortcut Dimension 6 Code");
            if not TempDimSetEntry.Insert then
                TempDimSetEntry.Modify;
            par_ILERec.Validate("Dimension Set ID", DimensionManagementCodeUnit.GetDimensionSetID(TempDimSetEntry));
        end;
        if par_ILERec."Shortcut Dimension 7 Code" <> '' then begin
            DimensionManagementCodeUnit.GetDimensionSet(TempDimSetEntry, par_ILERec."Dimension Set ID");
            TempDimSetEntry.Init;
            TempDimSetEntry.Validate("Dimension Code", GLSetup."Shortcut Dimension 7 Code");
            TempDimSetEntry.Validate("Dimension Value Code", par_ILERec."Shortcut Dimension 7 Code");
            if not TempDimSetEntry.Insert then
                TempDimSetEntry.Modify;
            par_ILERec.Validate("Dimension Set ID", DimensionManagementCodeUnit.GetDimensionSetID(TempDimSetEntry));
        end;
        if par_ILERec."Shortcut Dimension 8 Code" <> '' then begin
            DimensionManagementCodeUnit.GetDimensionSet(TempDimSetEntry, par_ILERec."Dimension Set ID");
            TempDimSetEntry.Init;
            TempDimSetEntry.Validate("Dimension Code", GLSetup."Shortcut Dimension 8 Code");
            TempDimSetEntry.Validate("Dimension Value Code", par_ILERec."Shortcut Dimension 8 Code");
            if not TempDimSetEntry.Insert then
                TempDimSetEntry.Modify;
            par_ILERec.Validate("Dimension Set ID", DimensionManagementCodeUnit.GetDimensionSetID(TempDimSetEntry));
        end;
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
}