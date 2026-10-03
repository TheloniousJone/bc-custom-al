page 60106 GroupPricePage
{

    ApplicationArea = All;
    Caption = 'GroupPricePage';
    PageType = List;
    //SourceTable = GroupPrice;
    SourceTable = "Pharma Sales Price";
    UsageCategory = Lists;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Currency; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency field';
                    ApplicationArea = All;
                }
                field("Customer Group No."; Rec."Sales Code")
                {
                    ToolTip = 'Specifies the value of the Customer Group No. field';
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field';
                    ApplicationArea = All;
                }
                field("Product Name"; Desc)
                {
                    ToolTip = 'Specifies the value of the Product Name field';
                    ApplicationArea = All;
                }
                field(UOM; Rec."Unit Of Measure Code")
                {
                    ToolTip = 'Specifies the value of the UOM field';
                    ApplicationArea = All;
                }
                field(FromDate; FORMAT(rec."Starting Date", 0, '<Year4>/<Month,2>/<Day,2>'))
                {
                    ToolTip = 'Specifies the value of the FromDate field';
                    ApplicationArea = All;
                }
                field(ToDate; FORMAT(rec."Ending Date", 0, '<Year4>/<Month,2>/<Day,2>'))
                {
                    ToolTip = 'Specifies the value of the ToDate field';
                    ApplicationArea = All;
                }
                field(Quantity; Rec."Minimum Quantity")
                {
                    ToolTip = 'Specifies the value of the Quantity field';
                    ApplicationArea = All;
                }
                field(Price; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Price field';
                    ApplicationArea = All;
                }
                field("Rec ID"; rec.RecRefID)
                {
                    ToolTip = 'Specifies the value of the Rec ID field';
                    ApplicationArea = All;
                }
                field("Have Bonus"; HaveBonus)
                {
                    ToolTip = 'Specifies the value of the Have Bonus field';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        LoadData();
    end;

    local procedure LoadData()
    var
        myInt: Integer;
        ItemRec: Record item;
        IntLeadTime: Integer;
        SalesTrade: Record "Pharma Sales Price";
        ItemUOM: Record "Item Unit of Measure";
    begin
        salestrade.reset;
        SalesTrade.SetRange("Sales Type", SalesTrade."Sales Type"::"Customer Price Group");
        SalesTrade.SetRange("Sales Code", 'C2');
        SalesTrade.SetRange(Status, SalesTrade.Status::Active); //RL 10 Oct 2022
        SalesTrade.SetFilter("TA Type", '%1|%2', SalesTrade."TA Type"::All, SalesTrade."TA Type"::Wellaway); //RL   21Mar2022   Add TA Type Filter
        if SalesTrade.FindSet() then
            repeat
                ItemRec.reset;
                ItemRec.SetRange("Wellaway Item", true);
                ItemRec.SetRange("No.", SalesTrade."Item No.");
                if ItemRec.FindFirst()
                    then begin
                    //DX        30 Sept 2021
                    ItemUOM.reset;
                    ItemUOM.SetCurrentKey("Item No.", "Qty. per Unit of Measure"); //remove dtd 151021 wx
                    ItemUOM.SetAscending(ItemUOM."Qty. per Unit of Measure", true); //remove dtd 151021 wx
                    ItemUOM.SetRange("Item No.", ItemRec."No."); //remove dtd 151021 wx
                    // //DX        30 Sept 2021 
                    if ItemUOM.FindFirst() then begin //remove dtd 151021 wx
                        if SalesTrade."Unit Of Measure Code" = ItemUOM.Code then begin
                            if SalesTrade."Ending Date" <> 0D then begin
                                clear(Rec);
                                Rec."Currency Code" := 'SGD';
                                rec."Sales Type" := Rec."Sales Type"::"Customer Price Group";
                                rec."Sales Code" := 'C2';
                                Rec."Item No." := ItemRec."No.";
                                //Rec. := ItemRec.Description;
                                Rec."Unit Of Measure Code" := SalesTrade."Unit Of Measure Code";

                                //wx dtd 141021
                                /*
                                                        if SalesTrade."Ending Date" >= 21001231D then begin
                                                            rec."Starting Date" := 0D;
                                                            rec."Ending Date" := 0D;
                                                        end else begin
                                                            rec."Starting Date" := SalesTrade."Starting Date";
                                                            rec."Ending Date" := SalesTrade."Ending Date";
                                                        end;

                                                        if (SalesTrade."Starting Date" <= 20201231D) and (SalesTrade."Ending Date" >= 21001231D) then begin
                                                            rec."Starting Date" := SalesTrade."Starting Date";
                                                            rec."Ending Date" := SalesTrade."Ending Date";
                                                        end;*/
                                Rec."Starting Date" := SalesTrade."Starting Date";
                                Rec."Ending Date" := SalesTrade."Ending Date";
                                if (SalesTrade."Starting Date" = 20210101D) and (SalesTrade."Ending Date" = 21001231D) then begin
                                    rec."Starting Date" := 0D;
                                    Rec."Ending Date" := 0D;
                                end;
                                //wx dtd 141021

                                // Rec."Starting Date" := SalesTrade."Starting Date";
                                // Rec."Ending Date" := SalesTrade."Ending Date";
                                Rec."Minimum Quantity" := SalesTrade."Minimum Quantity";
                                Rec."Unit Price" := SalesTrade."Unit Price";
                                rec.RecRefID := SalesTrade.RecRefID;
                                //Rec."Have Bonus" := false;
                                Rec.Insert(false);
                            end;
                        end;
                    end;
                    //end;
                end;
            // end; //remove dtd 151021 wx
            until SalesTrade.next = 0;


    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        ItemRec: Record item;
        ItemUOM: Record "Item Unit of Measure";
    begin
        if Rec."Item No." <> '' then begin
            ItemRec.reset;
            ItemRec.get(Rec."Item No.");

            //CustGroup := 'C2';
            if Rec."Unit Of Measure Code" <> ItemRec."Base Unit of Measure" then begin
                ItemUOM.reset;
                ItemUOM.SetRange("Item No.", Rec."Item No.");
                ItemUOM.SetRange(Code, Rec."Unit Of Measure Code");
                if ItemUOM.FindFirst() then begin
                    if ItemUOM."Alternate Description" <> '' then begin
                        Desc := ItemUOM."Alternate Description"
                    end else
                        desc := ItemRec.Description;
                end;
            end else begin
                Desc := ItemRec.Description;
            end;

            HaveBonus := 'N';
        end;
    end;

    var
        HaveBonus: Text;
        CurrencyCode: Code[20];
        CustGroup: Code[20];
        Desc: Text[100];
        StartDate: Date;
        EndDate: Date;

}
