report 57104 "Import WH OB Lines"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Excel Buffer"; "Excel Buffer")
        {

            trigger OnPostDataItem()
            begin
                MESSAGE('%1 Lines Imported', CountLine);
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
        WhTrack: Record 6550;
        WhJnl: Record 7311;
        LineNo: Integer;
        DateVal: Date;
        Dec: Decimal;
        CountLine: Integer;
        LocRec: Record 14;
        BinRec: Record 7354;
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

        EVALUATE(LineNo, GetValueAtCell(RowNo, 3));
        EVALUATE(DateVal, GetValueAtCell(RowNo, 4));
        EVALUATE(Dec, GetValueAtCell(RowNo, 7));
        WhJnl.RESET;
        WhJnl.INIT;
        WhJnl.VALIDATE("Journal Template Name", GetValueAtCell(RowNo, 1));
        WhJnl.VALIDATE("Journal Batch Name", GetValueAtCell(RowNo, 2));
        WhJnl.VALIDATE("Line No.", LineNo);
        WhJnl.VALIDATE("Registering Date", DateVal);
        WhJnl.VALIDATE("Location Code", GetValueAtCell(RowNo, 5));
        LocRec.RESET;
        LocRec.SETRANGE(Code, GetValueAtCell(RowNo, 5));
        IF LocRec.FINDFIRST THEN BEGIN
            BinRec.RESET;
            BinRec.SETRANGE(Code, LocRec."Adjustment Bin Code");
            IF BinRec.FINDFIRST THEN BEGIN
                WhJnl.VALIDATE("From Zone Code", BinRec."Zone Code");
                WhJnl.VALIDATE("From Bin Type Code", BinRec."Bin Type Code");
                WhJnl."From Bin Code" := LocRec."Adjustment Bin Code";
            END;
        END;
        WhJnl.VALIDATE("Item No.", GetValueAtCell(RowNo, 6));
        WhJnl.VALIDATE(Quantity, Dec);
        WhJnl.VALIDATE("Unit of Measure Code", GetValueAtCell(RowNo, 11));
        WhJnl.VALIDATE("Zone Code", GetValueAtCell(RowNo, 8));
        WhJnl.VALIDATE("Bin Code", GetValueAtCell(RowNo, 9));
        WhJnl.VALIDATE("Source Code", 'WHITEM');
        WhJnl.VALIDATE("To Zone Code", GetValueAtCell(RowNo, 8));
        WhJnl.VALIDATE("To Bin Code", GetValueAtCell(RowNo, 9));
        WhJnl.VALIDATE("Whse. Document No.", GetValueAtCell(RowNo, 10));
        WhJnl.VALIDATE("Whse. Document Type", WhJnl."Whse. Document Type"::"Whse. Journal");
        WhJnl.VALIDATE("Entry Type", WhJnl."Entry Type"::"Positive Adjmt.");
        WhJnl.INSERT(TRUE);

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

