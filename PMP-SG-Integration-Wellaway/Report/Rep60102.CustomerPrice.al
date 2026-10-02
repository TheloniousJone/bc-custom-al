report 60102 CustomerPrice
{
    Caption = 'CustomerPrice';
    ProcessingOnly = true;
    dataset
    {
        dataitem(PHS; "Pharma Sales Price")
        {

            trigger OnPreDataItem()
            begin
                CusPriRec.DeleteAll();
                SetFilter("Sales Type", '%1', phs."Sales Type"::Customer);
            end;

            trigger OnAfterGetRecord()
            begin
                ProductName := '';

                itemrec.SetRange("No.", PHS."Item No.");
                if itemrec.FindFirst() then begin
                    ProductName := itemrec.Description;
                end;

                if phs."Currency Code" = '' then begin
                    CurrencyCode := GLSetupRec."LCY Code";
                end else begin
                    CurrencyCode := PHS."Currency Code";
                end;

                CusPriRec.Init();
                CusPriRec.Currency := CurrencyCode;
                CusPriRec."Customer Group No." := PHS."Sales Code";
                CusPriRec."Item No." := PHS."Item No.";
                CusPriRec."Product Name" := ProductName;
                CusPriRec.UOM := PHS."Unit Of Measure Code";
                CusPriRec.FromDate := PHS."Starting Date";
                CusPriRec.ToDate := PHS."Ending Date";
                CusPriRec.Quantity := PHS."Minimum Quantity";
                CusPriRec.Price := PHS."Unit Price";
                CusPriRec.Insert();


                CusPriRec.Modify();
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    trigger OnInitReport()

    begin

        GLSetupRec.GET();
    end;

    var
        CusPriRec: record CustomerPrice;
        itemrec: Record Item;
        ProductName: Text;
        GLSetupRec: Record "General Ledger Setup";
        CurrencyCode: Text;
}
