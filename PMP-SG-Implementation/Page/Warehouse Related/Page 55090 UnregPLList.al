page 55090 UnregPLList
{

    ApplicationArea = All;
    Caption = 'UnregPLList';
    PageType = List;
    SourceTable = "Warehouse Activity Line";
    UsageCategory = History;
    SourceTableView = sorting("Activity Type", "No.", "Line No.") order(descending) where("Action Type" = const(Take), "Activity Type" = const(Pick));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = all;
                    Caption = 'Created Date';
                }
                field(BinCode; BinCode)
                {
                    ApplicationArea = all;
                    Caption = 'Basket Code';
                }
                field(coldBin; coldBin)

                {
                    ApplicationArea = all;
                    Caption = 'Cold Bin';
                }
                field(Created; Created)
                {
                    ApplicationArea = all;
                    Caption = 'Checking Created';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ToolTip = 'Specifies the value of the Bin Code field';
                    ApplicationArea = All;
                }
                field(AssignPicker; AssignPicker)
                {
                    ApplicationArea = all;
                    Caption = 'Picker';

                }
                field("Bin Type Code"; Rec."Bin Type Code")
                {
                    ToolTip = 'Specifies the value of the Bin Type Code field';
                    ApplicationArea = All;
                }
                field("CS Pick Qty"; Rec."CS Pick Qty")
                {
                    ToolTip = 'Specifies the value of the CS Pick Qty field';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field';
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field';
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ToolTip = 'Specifies the value of the Lot No. field';
                    ApplicationArea = All;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ToolTip = 'Specifies the value of the Expiration Date field';
                    ApplicationArea = All;
                }
                field("Qty. (Base)"; Rec."Qty. (Base)")
                {
                    ToolTip = 'Specifies the value of the Qty. (Base) field';
                    ApplicationArea = All;
                }
                field("Qty. Handled"; Rec."Qty. Handled")
                {
                    ToolTip = 'Specifies the value of the Qty. Handled field';
                    ApplicationArea = All;
                }
                field("Qty. Handled (Base)"; Rec."Qty. Handled (Base)")
                {
                    ToolTip = 'Specifies the value of the Qty. Handled (Base) field';
                    ApplicationArea = All;
                }
                field("Source Document"; Rec."Source Document")
                {
                    ToolTip = 'Specifies the value of the Source Document field';
                    ApplicationArea = All;
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the value of the Source No. field';
                    ApplicationArea = All;
                }
                field("Zone Code"; Rec."Zone Code")
                {
                    ToolTip = 'Specifies the value of the Zone Code field';
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure Code field';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        AssignPicker := '';

        ALERec.reset;
        ALERec.SetRange("Picking Doc No.", Rec."No.");
        if ALERec.FindFirst() then begin
            BinCode := ALERec.Basket;
            coldBin := ALERec."2nd Basket Code";
            AssignPicker := ALERec.Picker;
            if ALERec."Checking Doc No." = '' then
                Created := false
            else
                Created := true;

        end;
    end;

    var
        coldBin: Code[20];
        ALERec: Record "Assignment Ledger Entry";
        Bincode: Code[20];
        Created: Boolean;
        AssignPicker: text[50];
        WHRec: Record "Warehouse Activity Header";
}
