/*
#001RL - 16 Sep 2022 Added Batch and SONo

*/

page 57010 BIGRNLines
{
    SourceTable = "Item Ledger Entry";
    SourceTableView = where("Document Type" = filter("Purchase Receipt"), "Invoiced Quantity" = filter(0));
    APIGroup = 'Purchase';
    APIPublisher = 'publisherName';
    APIVersion = 'v2.0';
    Caption = 'BIGRNLines';
    DelayedInsert = true;
    EntityName = 'BIGRNLines';
    EntitySetName = 'BIGRNLines';
    PageType = API;

    layout
    {
        //PO#, invoice#(blank), qty, price, amount, GRN#(blank) 
        area(content)
        {
            repeater(General)
            {
                field(MODIFIEDDATE; Rec.SystemModifiedAt) { }
                field(PONo; PONo)
                {
                    Caption = 'PO#';
                }
                field(CREATEDDATE; Rec.SystemCreatedAt) { }
                field("VENDORACCOUNT"; Rec."Source No.") { }
                field("ProductID"; Rec."Item No.") { }
                field(Description; Rec.Description) { }
                field(LINESTATUS; '') { }
                field(INVOICEDATE; '') { }
                field(GRNNo; Rec."Document No.")
                {
                    Caption = 'GRN#';
                }

                field(DELIVERYDATE; Rec."Posting Date") { }

                field(UOM; Rec."Unit of Measure Code")
                {

                }
                field("Currency"; CurrCode) { }

                field(Quantity; PurQty)
                {

                }
                field("LineAmount"; Rec."Cost Amount (Actual)" / CurrFactor)
                {
                }
                field(ExchangeRate; CurrFactor) { }
                field(POAMOUNTSGD; Rec."Cost Amount (Actual)") { }
                field(BATCH; rec."Lot No.") { }
                field("DIM1"; Rec."Global Dimension 1 Code") { }
                field(Price; UnitPrice) { }
                field(Pool; Pool)
                {

                }
                field(QtyBASE; Rec.Quantity) { }
                field(SONo; SONo) { }//#001RL

            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        GLSetup: Record "General Ledger Setup";
        PHRec: Record "Purch. Rcpt. Header";
        VLERec: Record "Value Entry";
        PRLRec: Record "Purch. Rcpt. Line";
    begin
        GLESetup.Get();
        PONo := '';
        CurrFactor := 1;
        CurrCode := '';
        PHRec.reset;
        PHRec.SetLoadFields("No.", "Order No.", "Transaction Type", "Currency Code", "Currency Factor");
        PHRec.SetRange("No.", Rec."Document No.");
        if PHRec.FindFirst() then begin
            PONo := PHRec."Order No.";
            Pool := PHRec."Transaction Type";
            CurrCode := PHRec."Currency Code";
            if CurrCode = '' then
                CurrCode := GLSetup."LCY Code";
            if PHRec."Currency Factor" <> 0 then
                CurrFactor := 1 / PHRec."Currency Factor";
        end;
        Rec.CalcFields("Cost Amount (Actual)");
        if (Rec.Quantity <> 0) AND (Rec."Cost Amount (Actual)" <> 0) then
            UnitPrice := Round((Rec."Cost Amount (Actual)" / CurrFactor) / rec.Quantity, 2, '=');

        Invno := '';
        VLERec.reset;
        VLERec.SetLoadFields("Item Ledger Entry No.", "Document Type", "Entry Type", "Document No.");
        VLERec.SetRange("Item Ledger Entry No.", Rec."Entry No.");
        VLERec.SetRange("Document Type", VLERec."Document Type"::"Purchase Invoice");
        VLERec.SetRange("Entry Type", VLERec."Entry Type"::"Direct Cost");
        if VLERec.FindFirst() then
            Invno := VLERec."Document No.";
        if Rec."Qty. per Unit of Measure" <> 0 then
            PurQty := Rec.Quantity / Rec."Qty. per Unit of Measure"
        else
            PurQty := Rec.Quantity;


        //#001RL - Start
        PRLRec.Reset();
        SONo := '';
        PRLRec.SetLoadFields("Document No.", "Line No.", "Special Order Sales No.");
        PRLRec.SetRange("Document No.", Rec."Document No.");
        PRLRec.SetRange("Line No.", Rec."Document Line No.");
        if PRLRec.FindFirst() then
            SONo := PRLRec."Special Order Sales No.";
        //#001RL - End
    end;



    var
        CurrCode: Code[20];
        TAXGroup: code[20];
        RPMPEnhance: Codeunit "PMP-Enhancements";
        PONo: Code[20];
        UnitPrice: Decimal;
        Invno: Code[20];
        CurrFactor: Decimal;
        GLESetup: Record "General Ledger Setup";
        Pool: Code[10];
        PurQty: Decimal;
        SONo: Code[20];//#001RL
}
