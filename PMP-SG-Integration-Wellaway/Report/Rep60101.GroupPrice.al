report 60101 GroupPrice
{
    Caption = 'GroupPrice';
    ProcessingOnly = true;
    dataset
    {
        dataitem(PHS; "Pharma Sales Price")
        {

            trigger OnPreDataItem()
            begin
                GroupPriceRec.DeleteAll();
                SetFilter("Sales Type", '%1', phs."Sales Type"::"Customer Price Group");
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

                GroupPriceRec.Init();
                GroupPriceRec.Currency := CurrencyCode;
                GroupPriceRec."Customer Group No." := PHS."Sales Code";
                GroupPriceRec."Item No." := PHS."Item No.";
                GroupPriceRec."Product Name" := ProductName;
                GroupPriceRec.UOM := PHS."Unit Of Measure Code";
                GroupPriceRec.FromDate := PHS."Starting Date";
                GroupPriceRec.ToDate := PHS."Ending Date";
                GroupPriceRec.Quantity := PHS."Minimum Quantity";
                GroupPriceRec.Price := PHS."Unit Price";
                GroupPriceRec.Insert();


                GroupPriceRec.Modify();
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
        GroupPriceRec: record GroupPrice;
        itemrec: Record Item;
        ProductName: Text;
        GLSetupRec: Record "General Ledger Setup";
        CurrencyCode: Text;
}
