report 57105 "Import WH Item Track OB"
{
    Permissions = TableData 6550 = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Excel Buffer"; "Excel Buffer")
        {

            trigger OnPostDataItem()
            begin
                MESSAGE('%1 Lines Created', CountLine);
            end;

            trigger OnPreDataItem()
            begin
                "Excel Buffer".LOCKTABLE;
                // "Excel Buffer".OpenBook(ServerFIleNmae, SheetName);
                "Excel Buffer".OpenBookStream(ImportStream, Sheetname);
                "Excel Buffer".ReadSheet;
                GetLastRowAndColumn();
                FOR i := 2 TO TotalRows DO
                    InsertData(i);

                "Excel Buffer".DELETEALL;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            UploadIntoStream(UploadExcelMsg, '', '', FromFile, ImportStream);

            IF CloseAction = ACTION::OK THEN BEGIN
                // ServerFIleNmae := FileManagement.UploadFile('Choose File', 'File');
                ServerFIleNmae := FileManagement.GetFileName(Fromfile);
                IF ServerFIleNmae = '' THEN
                    EXIT;
                // SheetName := "Excel Buffer".SelectSheetsName(ServerFIleNmae);
                SheetName := "Excel Buffer".SelectSheetsNameStream(ImportStream);
                IF SheetName = '' THEN
                    EXIT(TRUE);
            END;
        end;
    }

    labels
    {
    }

    var
        "RowNo.": Integer;
        i: Integer;
        CustRec: Record 18;
        ServerFIleNmae: Text;
        SheetName: Text;
        FileManagement: Codeunit 419;
        TotalColumns: Integer;
        TotalRows: Integer;
        ProdHeader: Record 99000771;
        ProdVer: Record 99000779;
        WhTrack: Record 6550;
        WhJnl: Record 7311;
        LineNo: Integer;
        DateVal: Date;
        Dec: Decimal;
        CountLine: Integer;
        ImportStream: InStream;
        FromFile: text[100];
        UploadExcelMsg: Label 'Please Choose the Excel file.';

    local procedure InsertData(RowNo: Integer)
    begin
        /*
          MESSAGE(GetValueAtCell(RowNo,2));
        ProdHeader.RESET;
        ProdHeader.INIT;
        ProdHeader.SETRANGE("No.",GetValueAtCell(RowNo,1));
        IF ProdHeader.FINDSET THEN REPEAT
        EVALUATE(ProdHeader."Prod - Instructions Text",GetValueAtCell(RowNo,2));
        ProdHeader.MODIFY(TRUE);
        UNTIL ProdHeader.NEXT=0;



        ProdVer.RESET;
        ProdVer.SETRANGE("Production BOM No." ,GetValueAtCell(RowNo,1));
        ProdVer.SETRANGE("Version Code",GetValueAtCell(RowNo,3));
        IF ProdVer.FINDSET THEN REPEAT
        EVALUATE(ProdVer."Prod - Instructions Text",GetValueAtCell(RowNo,2));
          MESSAGE(GetValueAtCell(RowNo,2));
        ProdVer.MODIFY(TRUE);
        UNTIL ProdVer.NEXT=0;
        */
        //EVALUATE(LineNo,GetValueAtCell(RowNo,1));
        WhTrack.RESET;
        IF WhTrack.FINDLAST THEN
            LineNo := WhTrack."Entry No." + 1
        ELSE
            LineNo := 1;


        WhTrack.RESET;
        WhTrack.INIT;
        WhTrack.VALIDATE("Entry No.", LineNo);
        WhTrack.VALIDATE("Item No.", GetValueAtCell(RowNo, 2));
        WhTrack.VALIDATE("Location Code", GetValueAtCell(RowNo, 3));
        EVALUATE(Dec, GetValueAtCell(RowNo, 4));
        WhTrack.VALIDATE("Quantity (Base)", Dec);
        WhTrack.VALIDATE("Source Type", 7311);
        WhTrack.VALIDATE("Source ID", 'DEFAULT');
        WhTrack.VALIDATE("Source Batch Name", 'ADJMT');
        EVALUATE(Dec, GetValueAtCell(RowNo, 5));
        WhTrack.VALIDATE("Source Ref. No.", Dec);
        //EVALUATE(Dec,GetValueAtCell(RowNo,6));
        //WhTrack.VALIDATE("Qty. per Unit of Measure",Dec);
        EVALUATE(Dec, GetValueAtCell(RowNo, 7));
        WhTrack.VALIDATE("Qty. to Handle (Base)", Dec);
        EVALUATE(Dec, GetValueAtCell(RowNo, 8));
        WhTrack.VALIDATE("Qty. to Handle", Dec);
        WhTrack.VALIDATE("Lot No.", GetValueAtCell(RowNo, 9));
        EVALUATE(DateVal, GetValueAtCell(RowNo, 6));
        WhTrack.VALIDATE("Expiration Date", DateVal);
        WhTrack.VALIDATE("New Expiration Date", DateVal);
        //EVALUATE(Dec, GetValueAtCell(RowNo, 10));
        // WhTrack.VALIDATE("Conversion Ratio", Dec);

        WhTrack.INSERT(TRUE);
        CountLine += 1;

    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer) Text: Text
    begin
        IF "Excel Buffer".GET(RowNo, ColNo) THEN
            EXIT("Excel Buffer"."Cell Value as Text");
    end;

    local procedure GetLastRowAndColumn()
    begin
        "Excel Buffer".SETRANGE("Excel Buffer"."Row No.", 1);
        TotalColumns := "Excel Buffer".COUNT;
        "Excel Buffer".RESET;
        IF "Excel Buffer".FINDLAST THEN
            TotalRows := "Excel Buffer"."Row No.";
    end;
}

