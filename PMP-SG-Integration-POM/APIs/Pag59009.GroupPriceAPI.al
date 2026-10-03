page 59009 "GP API"
{

    ApplicationArea = All;
    Caption = 'GP API';
    PageType = List;
    SourceTable = "Temp Sales Price";
    Permissions = TableData "Temp Sales Price" = rimd;
    AccessByPermission = tabledata "Temp Sales Price" = rimd;
    // SourceTableTemporary = true;
    UsageCategory = Lists;
    PopulateAllFields = true;

    layout
    {

        area(content)
        {
            repeater(General)
            {
                field(CurrCode; rec."Currency Code")
                {
                    ApplicationArea = All;
                }

                field(Customer; rec."Sales Code")
                {
                    ApplicationArea = all;
                }

                field("Item No."; rec."Item No.")
                {
                    ApplicationArea = All;
                }

                field("Product Description"; rec.Description)
                {
                    ApplicationArea = All;
                }

                field(UOM; rec."Unit Of Measure Code")
                {
                    ApplicationArea = All;
                }

                field("From Date"; format(rec."Start Date", 0, '<Closing><Year4>/<Month,2>/<Day,2>'))
                {
                    ApplicationArea = All;
                }

                field("To Date"; format(rec."End Date", 0, '<Closing><Year4>/<Month,2>/<Day,2>'))
                {
                    ApplicationArea = All;
                }

                field("Qty"; rec."Minimum Quantity")
                {
                    ApplicationArea = All;

                }

                field("Price"; rec."Unit Price")
                {
                    ApplicationArea = All;
                }

                field(RecId; rec.RecRefID)
                {
                    ApplicationArea = All;
                }

                field("Have Bonus"; rec."Have Bonus")
                {
                    ApplicationArea = All;
                }

                // field("Qty Per Measure"; rec."Qty Per Measure")
                // {
                //     ApplicationArea = All;
                // }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = all;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = all;
                }


            }

        }

    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        ItemRec: Record Item;
        UOMRec: Record "Item Unit of Measure";
    begin

        // // if Rec."Currency Code" = '' then
        // //     CurrCode := 'SGD'
        // // else
        // //     CurrCode := Rec."Currency Code";

        // ItemRec.reset;
        // ItemRec.SetRange("No.", Rec."Item No.");
        // if ItemRec.FindFirst() then begin
        //     Desc := ItemRec.Description;
        // end;

        // if rec."FOC Qty" > 0 then begin
        //     HaveBonus := 'Y';
        // end else begin
        //     HaveBonus := 'N';
        // end;

        // //store temp
        // UOMRec.Reset();
        // UOMRec.SetRange("Item No.", rec."Item No.");
        // UOMRec.SetRange(Code, rec."Unit Of Measure Code");
        // if uomrec.findfirst then begin
        //     QtyUOM := UOMRec."Qty. per Unit of Measure";
        // end;
        // //store temp
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        // SetPageData();
        rec.SetFilter("Qty Per Measure", '>=1');
        rec.setfilter("Sales Type", '=%1', rec."Sales Type"::"Customer Price Group");

        //rec.SetFilter("Sales Code", 'C2|D|PH|H2|CORPORATE');      //DX        05 Apr 2023
        rec.SetFilter("Sales Code", 'C2|D|PH|H2|CORPORATE|H2PRIV');
        rec.SetFilter(RecRefID, '<>%1', '');
    end;

    // local procedure SetPageData()
    // var
    //     myInt: Integer;
    //     GPRec: Record "Pharma Sales Price";
    // begin
    //     GPRec.reset;
    //     GPRec.setfilter("Sales Type", '=%1', GPRec."Sales Type"::"Customer Price Group");
    //     GPRec.SetFilter("Sales Code", 'C2|D|PH');
    //     GPRec.SetFilter(RecRefID, '<>%1', '');

    //     if GPRec.FindSet() then
    //         repeat
    //             rec."Sales Code" := GPRec."Sales Code";
    //             Rec."Item No." := GPRec."Item No.";
    //             rec."Unit Of Measure Code" := GPRec."Unit Of Measure Code";
    //             // rec."Starting Date" := GPRec."Starting Date";
    //             // rec."Ending Date" := GPRec."Ending Date";

    //             if GPRec."Ending Date" >= 21001231D then begin
    //                 rec."Starting Date" := 0D;
    //                 rec."Ending Date" := 0D;
    //             end else begin
    //                 rec."Starting Date" := GPRec."Starting Date";
    //                 rec."Ending Date" := GPRec."Ending Date";
    //             end;
    //             rec."Minimum Quantity" := GPRec."Minimum Quantity";
    //             rec."Unit Price" := GPRec."Unit Price";
    //             if GPRec."Currency Code" = '' then
    //                 rec."Currency Code" := 'SGD'
    //             else
    //                 rec."Currency Code" := Rec."Currency Code";
    //             rec.RecRefID := GPRec.RecRefID;
    //             Rec.insert(FALSE);
    //         until GPRec.next = 0;
    // end;

    var
        Addr: Text[1000];

        Desc: Text[100];
        CurrCode: Code[20];
        HaveBonus: code[10];
        QtyUOM: Decimal;
    //Customer account	Customer name	Branch/subsidiary	Fax	Telephone	E-mail	Contact person	Street name	ZIP code	Customer status	Corporate sales rep (PMP)		

}
