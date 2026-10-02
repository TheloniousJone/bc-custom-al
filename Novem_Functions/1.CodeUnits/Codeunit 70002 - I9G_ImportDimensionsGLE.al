codeunit 70002 I9G_ImportDimensionsGLE
{
    Description = 'Function - Import Dimensions for General Ledger Entry and update Dimension Set ID';
    Permissions = tabledata "G/L Entry" = rimd, tabledata "Item Application Entry" = rimd;

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
        GLEntryRec: Record "G/L Entry";
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
            GLEntryRec.Reset();
            GLEntryRec.SetRange("Entry No.", EntryNo);
            if GLEntryRec.FindFirst() then begin
                GLEntryRec."Global Dimension 1 Code" := GetValueAtCell(StartFromRow, 2);
                GLEntryRec."Global Dimension 2 Code" := GetValueAtCell(StartFromRow, 3);
                GLEntryRec."Shortcut Dimension 3 Code" := GetValueAtCell(StartFromRow, 4);
                DimensionManagementCodeUnit.ValidateShortcutDimValues(3, GLEntryRec."Shortcut Dimension 3 Code", GLEntryRec."Dimension Set ID");
                GLEntryRec."Shortcut Dimension 4 Code" := GetValueAtCell(StartFromRow, 5);
                DimensionManagementCodeUnit.ValidateShortcutDimValues(4, GLEntryRec."Shortcut Dimension 4 Code", GLEntryRec."Dimension Set ID");
                GLEntryRec."Shortcut Dimension 5 Code" := GetValueAtCell(StartFromRow, 6);
                DimensionManagementCodeUnit.ValidateShortcutDimValues(5, GLEntryRec."Shortcut Dimension 5 Code", GLEntryRec."Dimension Set ID");
                GLEntryRec."Shortcut Dimension 6 Code" := GetValueAtCell(StartFromRow, 7);
                DimensionManagementCodeUnit.ValidateShortcutDimValues(6, GLEntryRec."Shortcut Dimension 6 Code", GLEntryRec."Dimension Set ID");
                GLEntryRec."Shortcut Dimension 7 Code" := GetValueAtCell(StartFromRow, 8);
                DimensionManagementCodeUnit.ValidateShortcutDimValues(7, GLEntryRec."Shortcut Dimension 7 Code", GLEntryRec."Dimension Set ID");
                GLEntryRec."Shortcut Dimension 8 Code" := GetValueAtCell(StartFromRow, 9);
                DimensionManagementCodeUnit.ValidateShortcutDimValues(8, GLEntryRec."Shortcut Dimension 8 Code", GLEntryRec."Dimension Set ID");
                updateDimensionSetIDEntry(GLEntryRec);
                GLEntryRec.Modify();
            end;
        end;
        Message(ExcelImportSucess);
    end;

    procedure updateDimensionSetIDEntry(var par_GLEntryRec: Record "G/L Entry")
    var
        GLSetup: Record "General Ledger Setup";
        DimensionManagementCodeUnit: Codeunit DimensionManagement;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        if TempDimSetEntry.IsTemporary then
            TempDimSetEntry.DeleteAll();

        GLSetup.Get();
        if par_GLEntryRec."Global Dimension 1 Code" <> '' then begin
            DimensionManagementCodeUnit.GetDimensionSet(TempDimSetEntry, 0);
            TempDimSetEntry.Init;
            TempDimSetEntry.Validate("Dimension Code", GLSetup."Shortcut Dimension 1 Code");
            TempDimSetEntry.Validate("Dimension Value Code", par_GLEntryRec."Global Dimension 1 Code");
            if not TempDimSetEntry.Insert then
                TempDimSetEntry.Modify;
            par_GLEntryRec.Validate("Dimension Set ID", DimensionManagementCodeUnit.GetDimensionSetID(TempDimSetEntry));
        end;
        if par_GLEntryRec."Global Dimension 2 Code" <> '' then begin
            DimensionManagementCodeUnit.GetDimensionSet(TempDimSetEntry, par_GLEntryRec."Dimension Set ID");
            TempDimSetEntry.Init;
            TempDimSetEntry.Validate("Dimension Code", GLSetup."Shortcut Dimension 2 Code");
            TempDimSetEntry.Validate("Dimension Value Code", par_GLEntryRec."Global Dimension 2 Code");
            if not TempDimSetEntry.Insert then
                TempDimSetEntry.Modify;
            par_GLEntryRec.Validate("Dimension Set ID", DimensionManagementCodeUnit.GetDimensionSetID(TempDimSetEntry));
        end;
        if par_GLEntryRec."Shortcut Dimension 3 Code" <> '' then begin
            DimensionManagementCodeUnit.GetDimensionSet(TempDimSetEntry, par_GLEntryRec."Dimension Set ID");
            TempDimSetEntry.Init;
            TempDimSetEntry.Validate("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
            TempDimSetEntry.Validate("Dimension Value Code", par_GLEntryRec."Shortcut Dimension 3 Code");
            if not TempDimSetEntry.Insert then
                TempDimSetEntry.Modify;
            par_GLEntryRec.Validate("Dimension Set ID", DimensionManagementCodeUnit.GetDimensionSetID(TempDimSetEntry));
        end;
        if par_GLEntryRec."Shortcut Dimension 4 Code" <> '' then begin
            DimensionManagementCodeUnit.GetDimensionSet(TempDimSetEntry, par_GLEntryRec."Dimension Set ID");
            TempDimSetEntry.Init;
            TempDimSetEntry.Validate("Dimension Code", GLSetup."Shortcut Dimension 4 Code");
            TempDimSetEntry.Validate("Dimension Value Code", par_GLEntryRec."Shortcut Dimension 4 Code");
            if not TempDimSetEntry.Insert then
                TempDimSetEntry.Modify;
            par_GLEntryRec.Validate("Dimension Set ID", DimensionManagementCodeUnit.GetDimensionSetID(TempDimSetEntry));
        end;
        if par_GLEntryRec."Shortcut Dimension 5 Code" <> '' then begin
            DimensionManagementCodeUnit.GetDimensionSet(TempDimSetEntry, par_GLEntryRec."Dimension Set ID");
            TempDimSetEntry.Init;
            TempDimSetEntry.Validate("Dimension Code", GLSetup."Shortcut Dimension 5 Code");
            TempDimSetEntry.Validate("Dimension Value Code", par_GLEntryRec."Shortcut Dimension 5 Code");
            if not TempDimSetEntry.Insert then
                TempDimSetEntry.Modify;
            par_GLEntryRec.Validate("Dimension Set ID", DimensionManagementCodeUnit.GetDimensionSetID(TempDimSetEntry));
        end;
        if par_GLEntryRec."Shortcut Dimension 6 Code" <> '' then begin
            DimensionManagementCodeUnit.GetDimensionSet(TempDimSetEntry, par_GLEntryRec."Dimension Set ID");
            TempDimSetEntry.Init;
            TempDimSetEntry.Validate("Dimension Code", GLSetup."Shortcut Dimension 6 Code");
            TempDimSetEntry.Validate("Dimension Value Code", par_GLEntryRec."Shortcut Dimension 6 Code");
            if not TempDimSetEntry.Insert then
                TempDimSetEntry.Modify;
            par_GLEntryRec.Validate("Dimension Set ID", DimensionManagementCodeUnit.GetDimensionSetID(TempDimSetEntry));
        end;
        if par_GLEntryRec."Shortcut Dimension 7 Code" <> '' then begin
            DimensionManagementCodeUnit.GetDimensionSet(TempDimSetEntry, par_GLEntryRec."Dimension Set ID");
            TempDimSetEntry.Init;
            TempDimSetEntry.Validate("Dimension Code", GLSetup."Shortcut Dimension 7 Code");
            TempDimSetEntry.Validate("Dimension Value Code", par_GLEntryRec."Shortcut Dimension 7 Code");
            if not TempDimSetEntry.Insert then
                TempDimSetEntry.Modify;
            par_GLEntryRec.Validate("Dimension Set ID", DimensionManagementCodeUnit.GetDimensionSetID(TempDimSetEntry));
        end;
        if par_GLEntryRec."Shortcut Dimension 8 Code" <> '' then begin
            DimensionManagementCodeUnit.GetDimensionSet(TempDimSetEntry, par_GLEntryRec."Dimension Set ID");
            TempDimSetEntry.Init;
            TempDimSetEntry.Validate("Dimension Code", GLSetup."Shortcut Dimension 8 Code");
            TempDimSetEntry.Validate("Dimension Value Code", par_GLEntryRec."Shortcut Dimension 8 Code");
            if not TempDimSetEntry.Insert then
                TempDimSetEntry.Modify;
            par_GLEntryRec.Validate("Dimension Set ID", DimensionManagementCodeUnit.GetDimensionSetID(TempDimSetEntry));
        end;
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
}