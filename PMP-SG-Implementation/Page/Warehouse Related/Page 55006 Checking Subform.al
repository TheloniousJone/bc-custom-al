page 55006 "Checking Subform"
{
    PageType = ListPart;
    //ApplicationArea = All;
    //UsageCategory = Lists;
    SourceTable = "Checking Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    layout
    {
        area(Content)
        {
            repeater(Details)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Cold Room Item"; Rec."Cold Room Item")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                //PK19022024
                field(VarMinShelf; VarMinShelf)
                {
                    Caption = 'Min Shelf Life';
                    ApplicationArea = All;
                    Editable = false;
                    Style = Favorable;
                }
                //PK19022024

                field(OrgPickQty; OrgPickQty)
                {
                    Caption = 'Original Order Qty.';
                    ApplicationArea = all;
                    StyleExpr = FieldStyle;
                    Editable = false;
                    DecimalPlaces = 0 : 5;
                    //Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    StyleExpr = FieldStyle;
                    Editable = false;
                    DecimalPlaces = 0 : 5;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    StyleExpr = FieldStyle;
                    Editable = false;
                }
                //DX        13 Aug 2021 
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                //LK281123
                field("Number Of Month"; NoMth)
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = NoMthStyle;

                }
                //LK281123
                //DX        13 Aug 2021 
                field("Shipping Packages"; Rec."Shipping Packacges")
                {
                    ApplicationArea = all;
                    Visible = false;
                    Caption = 'Shipping Packages';
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        CurrPage.Update(true);
                    end;
                }


            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        //DX        01 Jun 2021
        OrgPickQty := CheckCU.GetOrgQty(Rec);

        if Rec.Quantity <> OrgPickQty then
            FieldStyle := 'Attention'
        else
            if
           Rec.Quantity = OrgPickQty then
                FieldStyle := 'Favorable';
        //DX        01 Jun 2021
        //LK231123
        clear(NoMth);
        if Rec."Expiration Date" <> 0D then
            NoMth := CalculateMonthBetweenTwoDate(Today, Rec."Expiration Date");
        if (NoMth < 3) then
            NoMthStyle := 'Attention'
        else
            NoMthStyle := 'Standard';
        //LK231123

        Clear(VarMinShelf);

        CheckingHdr.Reset();
        CheckingHdr.SetRange("No.", Rec."Doc No.");

        if CheckingHdr.FindFirst() then begin
            Cust.Reset();
            Cust.SetRange("No.", CheckingHdr."Customer No.");
            if Cust.FindFirst() then begin
                MiniShelf.Reset();
                MiniShelf.SetRange("No.", Rec."Item No.");
                MiniShelf.SetRange(Code, Cust."Customer Price Group");
                if MiniShelf.FindFirst() then begin
                    VarMinShelf := CalcDate(MiniShelf.MinShelf, CheckingHdr."Posting Date");
                end;

            end;

        end;

    end;

    var
        FieldStyle: Text[50];
        VarMinShelf: Date;
        OrgPickQty: Decimal;
        CheckCU: Codeunit "WH-Checking";
        NoMthStyle: Text[50];
        NoMth: Integer;
        Cust: Record "Customer";
        CheckingHdr: Record "Checking Header";
        MiniShelf: Record "MinimumShelf";


    local procedure CalculateMonthBetweenTwoDate(StartDate: Date; EndDate: Date): Integer
    var
        NoOfYears: Integer;
        NoOfMonths: Integer;
        NoOfDays: Integer;
    begin

        NoOfYears := DATE2DMY(EndDate, 3) - DATE2DMY(StartDate, 3);
        NoOfMonths := DATE2DMY(EndDate, 2) - DATE2DMY(StartDate, 2);
        NoOfDays := DATE2DMY(EndDate, 1) - DATE2DMY(StartDate, 1);
        if NoOfDays >= -1 then
            exit(12 * NoOfYears + NoOfMonths)
        else
            exit(12 * NoOfYears + NoOfMonths - 1);
    end;
}

