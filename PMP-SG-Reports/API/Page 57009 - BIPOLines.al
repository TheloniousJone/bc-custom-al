page 57009 BIPOLines
{
    SourceTable = "Purchase Line";
    SourceTableView = where("Document Type" = filter('Order'));
    APIGroup = 'Purchase';
    APIPublisher = 'publisherName';
    APIVersion = 'v2.0';
    Caption = 'BIPOLines';
    DelayedInsert = true;
    EntityName = 'BIPOLines';
    EntitySetName = 'BIPOLines';
    PageType = API;

    layout
    {
        //PO#, invoice#(blank), qty, price, amount, GRN#(blank) 
        area(content)
        {
            repeater(General)
            {
                field(MODIFIEDDATE; Rec.SystemModifiedAt) { }
                field("PO"; Rec."Document No.")
                {
                    Caption = 'PO#';
                }
                field(CREATEDDATE; Rec.SystemCreatedAt) { }
                field("VENDORACCOUNT"; Rec."Buy-from Vendor No.") { }
                field("ProductID"; Rec."No.") { }
                field(Description; Rec.Description) { }
                field(LINESTATUS; '') { }
                field(INVOICEDATE; '') { }
                field(GRN; '')
                {
                    Caption = 'GRN#';
                }
                field(DELIVERYDATE; Rec."Expected Receipt Date") { }

                field(UOM; Rec."Unit of Measure Code")
                {

                }
                field("Currency"; CurrCode) { }

                field(Quantity; Rec.Quantity - Rec."Quantity Received")
                {

                }
                field("LineAmount"; Rec."Line Amount")
                {
                }
                field(ExchangeRate; CurrFactor) { }
                field(POAMOUNTSGD; Rec."Line Amount" * CurrFactor) { }
                field(BATCH; '') { }
                field("DIM1"; Rec."Shortcut Dimension 1 Code") { }
                field(Price; Rec."Direct Unit Cost") { }

                // field(InvoiceNo; '')
                // {
                //     Caption = 'Invoice#';
                // }


                // field("QtytoReceive"; Rec."Qty. to Receive")
                // {

                // }
                // field("QtytoInvoice"; Rec."Qty. to Invoice")
                // {

                // }
                // field("QuantityReceived"; Rec."Quantity Received")
                // {

                // }
                // field("QuantityInvoiced"; Rec."Quantity Invoiced")
                // {

                // }
                // field("DirectUnitCost"; Rec."Direct Unit Cost")
                // {

                // }


                field(Pool; Pool)
                {

                }
                field(QtyBASE; Rec."Quantity (Base)" - Rec."Qty. Received (Base)") { }
                field(SONo; Rec."Special Order Sales No.") { }




            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        GLSetup: Record "General Ledger Setup";
        PHRec: Record "Purchase Header";
    begin
        GLSetup.Get();
        PHRec.Reset();
        Clear(Pool);
        CurrFactor := 1;
        CurrCode := '';
        PHRec.SetLoadFields("No.", "Transaction Type", "Currency Code", "Currency Factor");
        PHRec.SetRange("No.", Rec."Document No.");
        if PHRec.FindFirst() then begin
            Pool := PHRec."Transaction Type";
            CurrCode := PHRec."Currency Code";
            if CurrCode = '' then
                CurrCode := GLSetup."LCY Code";
            if PHRec."Currency Factor" <> 0 then
                CurrFactor := 1 / PHRec."Currency Factor";
        end;
    end;

    var
        CurrCode: Code[20];
        TAXGroup: code[20];
        RPMPEnhance: Codeunit "PMP-Enhancements";
        Pool: Code[10];
        CurrFactor: Decimal;
}
