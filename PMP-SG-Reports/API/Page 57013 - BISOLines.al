page 57013 BISOLines
{
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type" = filter('Order'));
    APIGroup = 'Sales';
    APIPublisher = 'publisherName';
    APIVersion = 'v2.0';
    Caption = 'BISOLines';
    DelayedInsert = true;
    EntityName = 'BISOLines';
    EntitySetName = 'BISOLines';
    PageType = API;

    layout
    {
        //PO#, invoice#(blank), qty, price, amount, GRN#(blank) 
        area(content)
        {
            repeater(General)
            {
                field(MODIFIEDDATE; Rec.SystemModifiedAt) { }
                field(CREATEDDATE; Rec.SystemCreatedAt) { }
                field("SONO"; Rec."Document No.")
                {

                }

                field("CUSTOMERACCOUNTNO"; Rec."Sell-to Customer No.") { }
                field("ProductID"; Rec."No.") { }
                field(DELIVERYDATE; Rec."Requested Delivery Date") { }
                field("Currency"; CurrCode) { }
                field(Quantity; Rec.Quantity - Rec."Quantity Shipped")
                {

                }
                field(UOM; Rec."Unit of Measure Code")
                {

                }
                field(QtyBASE; Rec."Quantity (Base)" - Rec."Qty. Shipped (Base)") { }
                field(Price; Rec."Unit Price") { }
                field("SOAmount"; Rec."Line Amount")
                {
                }
                field(ExchangeRate; CurrFactor) { }
                field(SOAMOUNTSGD; Rec."Line Amount" * CurrFactor) { }
                field(COMPANY; CompanyName) { }
                field(DISTRIBUTORID; Rec."Transaction Type") { }

                field(POREF; Rec."Purchase Order No.")
                {
                    Caption = 'POREF#';
                }
                //DX        14 Dec 2024
                field(customer_guid; custGuid)
                {

                }
                //DX        14 Dec 2024




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

            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        GLSetup: Record "General Ledger Setup";
        SHRec: Record "Sales Header";
        CustRec: Record customer;
    begin
        GLSetup.Get();
        SHRec.Reset();
        Clear(Pool);
        CurrFactor := 1;
        CurrCode := '';
        SHRec.SetCurrentKey("No.");
        SHRec.SetLoadFields("No.", "Currency Code", "Currency Factor", "Sell-to Customer No.");
        SHRec.SetRange("No.", Rec."Document No.");
        if SHRec.FindFirst() then begin
            // Pool := PHRec."Transaction Type";
            CurrCode := SHRec."Currency Code";
            if CurrCode = '' then
                CurrCode := GLSetup."LCY Code";
            if SHRec."Currency Factor" <> 0 then
                CurrFactor := 1 / SHRec."Currency Factor";
            //Dx        14 Dec 24
            CustRec.reset;
            CustRec.SetLoadFields(SystemId);
            CustRec.SetRange("No.", SHRec."Sell-to Customer No.");
            if CustRec.FindFirst() then begin
                custGuid := format(CustRec.SystemId);
            end;
            //Dx        14 Dec 24
        end;

    end;

    var
        CurrCode: Code[20];
        TAXGroup: code[20];
        RPMPEnhance: Codeunit "PMP-Enhancements";
        Pool: Code[10];
        CurrFactor: Decimal;
        custGuid: text[100];

}
