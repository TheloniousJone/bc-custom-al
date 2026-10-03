page 55107 APIPharmaSalesPriceList
{

    //SourceTableTemporary = true;

    APIGroup = 'apiGroup';
    APIPublisher = '9ITGroup';
    APIVersion = 'v2.0';
    Caption = 'API Sales Trade Agreements';
    DelayedInsert = true;
    EntityName = 'SalesTradeAgtAPI';
    EntitySetName = 'SalesTradeAgtAPI';
    PageType = API;
    SourceTable = "Pharma Sales Price";

    /*
    ApplicationArea = All;
    Caption = 'API Sales Trade Agreements';
    PageType = List;
    SourceTable = "Pharma Sales Price";
    UsageCategory = Lists;
    SourceTableTemporary = true;
    */

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(SalesType; Rec."Sales Type")
                {
                    ToolTip = 'Specifies the value of the Sales Type field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field(SalesCode; Rec."Sales Code")
                {
                    ToolTip = 'Specifies the value of the Sales Code field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field(ItemNo; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field(ItemDesc; ItemDesc)
                {
                    ApplicationArea = all;
                    Caption = 'Description';
                    Editable = false;
                    Visible = true;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field(UOMCode; Rec."Unit Of Measure Code")
                {
                    ToolTip = 'Specifies the value of the Unit Of Measure Code field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field(VariantCode; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                    Visible = false;
                }
                field(MinimumQuantity; Rec."Minimum Quantity")
                {
                    ToolTip = 'Specifies the value of the Minimum Quantity field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field(FOCQty; Rec."FOC Qty")
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the value of the Starting Date field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field(EndingDate; Rec."Ending Date")
                {
                    ToolTip = 'Specifies the value of the Ending Date field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field(PriceIncludesVAT; Rec."Price Includes VAT")
                {
                    ToolTip = 'Specifies the value of the Price Includes VAT field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field(LineDiscountPercent; Rec."Line Discount %")
                {
                    ToolTip = 'Specifies the value of the Line Discount % field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field(AllowLineDisc; Rec."Allow Line Disc.")
                {
                    ToolTip = 'Specifies the value of the Allow Line Disc. field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field(AllowInvoiceDisc; Rec."Allow Invoice Disc.")
                {
                    ToolTip = 'Specifies the value of the Allow Invoice Disc field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field(VATBusPostingGrpPrice; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Gr. (Price) field';
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = gFieldStyle;

                    trigger OnValidate()
                    begin
                        if Rec.Status = Rec.Status::Active then
                            gFieldStyle := ''
                        else
                            gFieldStyle := 'Attention';
                    end;
                }

                field(RecRefId; Rec.RecRefID)
                {
                    ApplicationArea = all;
                }

                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = all;
                }
                field(itemuomConv; itemuomConv)
                {
                    ApplicationArea = all;
                }

                // YF 18 Mar 2022
                field(TAType; Rec."TA Type")
                {
                    ApplicationArea = All;
                }

                field(FindNext; Rec."Find Next")
                {
                    ApplicationArea = All;
                }
                // YF 18 Mar 2022
            }
        }
    }

    var
        gFieldStyle: Text[50];
        ItemRec: Record item;
        ItemDesc: Text[100];

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        LoadData();
    end;


    local procedure LoadData()
    var
        myInt: Integer;
        pharmaRec: Record "Pharma Sales Price";
        ItemUOM: Record "Item Unit of Measure";
        StartDate: Date;
        EndDate: Date;
        modDate: DateTime;
        SalesCode: Code[50];
        salesType: Text;
        ItemNo: Code[20];
        FOCQty: Decimal;
        filText: Text;
        UnitPrice: Decimal;
    begin
        /*
            "ItemNo": "3M01Z",
            "SalesType": "Customer",
            "SalesCode": "N037HQ",
            "StartingDate": "2021-01-01",
            "EndingDate": "2022-12-31",
            "UnitPrice": 40,
            "FOCQty": 0,
                "SystemModifiedAt": "2021-11-03T02:01:52.49Z"
        
        pharmaRec.reset;
        if Rec.GetFilter(Rec."Item No.") <> '' then begin
            pharmaRec.SetFilter("Item No.", '%1', Rec.GetFilter(Rec."Item No."));
        end else
            pharmaRec.SetFilter("Item No.", '<>%1', '');

        if Rec.GetFilter("Starting Date") <> '' then begin
            Evaluate(StartDate, Rec.GetFilter("Starting Date"));
            pharmaRec.SetFilter("Starting Date", '%1', StartDate);
        end;

        if Rec.GetFilter(Rec."Ending Date") <> '' then begin
            Evaluate(EndDate, Rec.GetFilter("Ending Date"));
            pharmaRec.SetFilter("Ending Date", '%1', EndDate);
        end;

        if Rec.GetFilter(Rec."Sales Type") = 'All Customers' then
            pharmaRec.SetRange("Sales Type", Rec."Sales Type"::"All Customers");
        if Rec.GetFilter(Rec."Sales Type") = 'Customer' then
            pharmaRec.SetRange("Sales Type", Rec."Sales Type"::Customer);
        if Rec.GetFilter(Rec."Sales Type") = 'Customer Price Group' then
            pharmaRec.SetRange("Sales Type", Rec."Sales Type"::"Customer Price Group");
        if Rec.GetFilter(Rec."Sales Type") = 'Campaign' then
            pharmaRec.SetRange("Sales Type", Rec."Sales Type"::Campaign);


        if
        (Rec.GetFilter(Rec."Unit Price") <> '') then begin
            Evaluate(UnitPrice, Rec.GetFilter(Rec."Unit Price"));
            pharmaRec.SetFilter("Unit Price", '%1', UnitPrice);
        end;
        if
        (Rec.GetFilter(Rec."FOC Qty") <> '') then begin
            Evaluate(FOCQty, Rec.GetFilter(Rec."FOC Qty"));
            pharmaRec.SetFilter("FOC Qty", '%1', Rec.GetFilter(Rec."FOC Qty"));
        end;

        if (Rec.GetFilter(Rec.SystemModifiedAt) <> '') then begin
            pharmaRec.SetFilter(SystemModifiedAt, '%1', Rec.SystemModifiedAt);
        end;


        if pharmaRec.FindSet() then
            repeat
                ItemUOM.reset;
                ItemUOM.SetRange(Code, pharmaRec."Unit Of Measure Code");
                ItemUOM.SetRange("Item No.", pharmaRec."Item No.");
                ItemUOM.SetFilter("Qty. per Unit of Measure", '>=1');
                if ItemUOM.FindFirst() then begin
                    rec.reset;
                    Rec.copy(pharmaRec);
                    Rec.Insert(FALSE);
                end;
            until pharmaRec.next = 0;
            */

    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec.Status = Rec.Status::Active then
            gFieldStyle := ''
        else
            gFieldStyle := 'Attention';
    end;

    trigger OnAfterGetRecord()
    var
        ItemUOM: Record "Item Unit of Measure";
    begin
        if Rec.Status = Rec.Status::Active then
            gFieldStyle := ''
        else
            gFieldStyle := 'Attention';
        ItemDesc := '';
        if Rec."Item No." <> '' then begin
            ItemRec.reset;
            ItemRec.SetRange("No.", Rec."Item No.");
            if ItemRec.FindFirst() then begin
                ItemDesc := ItemRec.Description;
            end else
                ItemDesc := '';
        end;
        itemuomConv := 0;
        ItemUOM.reset;
        ItemUOM.SetRange(Code, Rec."Unit Of Measure Code");
        ItemUOM.SetRange("Item No.", Rec."Item No.");
        if ItemUOM.FindFirst() then begin
            ItemUOMConv := ItemUOM."Qty. per Unit of Measure";
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Status := Rec.Status::Active;
    end;

    var
        itemuomConv: Decimal;
}

