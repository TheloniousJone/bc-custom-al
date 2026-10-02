page 55089 RegWHLinesList
{

    ApplicationArea = All;
    Caption = 'RegWHLinesList';
    PageType = List;
    SourceTable = "Registered Whse. Activity Line";
    //SourceTableTemporary = true;
    SourceTableView = sorting("Activity Type", "No.", "Line No.") order(descending) where("Action Type" = const(Take), "Activity Type" = const(Pick));

    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = all;
                    Caption = 'Registered Date';
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
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
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
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Qty. per Unit of Measure field';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field';
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

            }
        }
    }


    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        AssignPicker := '';


        UnRegPLNo := '';
        WHRec.reset;
        WHRec.SetRange("No.", Rec."No.");
        if WHRec.findfirst then begin
            ALERec.reset;
            ALERec.SetRange("Picking Doc No.", WHRec."Whse. Activity No.");
            if ALERec.FindFirst() then begin
                UnRegPLNo := ALERec."Picking Doc No.";
                BinCode := ALERec.Basket;
                coldBin := ALERec."2nd Basket Code";
                AssignPicker := ALERec.Picker;
                if ALERec."Checking Doc No." = '' then
                    Created := false
                else
                    Created := true;

            end;
        end;

    end;

    var

        coldBin: Code[20];
        ALERec: Record "Assignment Ledger Entry";
        BinCode: Code[20];
        Created: Boolean;
        AssignPicker: text[50];
        WHRec: Record "Registered Whse. Activity Hdr.";
        UnRegPLNo: Code[20];
}
