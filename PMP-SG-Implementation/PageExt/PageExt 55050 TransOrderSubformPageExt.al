pageextension 55050 TransOrderSubformPageExt extends "Transfer Order Subform"
{
    layout
    {
        addafter("Shipment Date")
        {
            //LK231123
            field("I9G QC/QA Comments"; rec."I9G QC/QA Comments")
            {
                ApplicationArea = all;

            }
            //LK231123
        }
        addafter("Item No.")
        {
            field(ExprDate; ExprDate)
            {
                ApplicationArea = all;
                Caption = 'Expiration Date';
                Editable = false;
                Style = Attention;
            }
        }

        addafter(Quantity)
        {
            field("Line Remarks"; Rec."Line Remarks")
            {
                ApplicationArea = All;
            }
            field("No. of Carton"; Rec."No. of Carton")
            {
                ApplicationArea = All;
            }
        }


        modify("Transfer-from Bin Code")
        {
            Visible = true;
            ApplicationArea = All;
        }

        modify("Transfer-To Bin Code")
        {
            Visible = true;
            ApplicationArea = All;
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        ExprDate := '';
        if Rec."Item No." <> '' then begin
            ExprDate := format(PMPCU.GetItemEarliestExpiration(Rec."Item No.", Rec."Transfer-from Code"));
        end else
            ExprDate := '';
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        TransferHeaderRec: Record "Transfer Header";
    begin
        ExprDate := '';
        if Rec."Item No." <> '' then begin
            ExprDate := format(PMPCU.GetItemEarliestExpiration(Rec."Item No.", Rec."Transfer-from Code"));
        end else
            ExprDate := '';

        // YF 28 Jan 2022 // To resolve item tracking issue
        if TransferHeaderRec.Get(Rec."Document No.") then begin
            Rec."Transfer-to Code" := TransferHeaderRec."Transfer-to Code";
            Rec."Transfer-To Bin Code" := TransferHeaderRec."Transfer-To Bin Code";
        end;
        /*
        // use header transfer to bin code by default // YF 16 Sep 2021 Issue #257        
        if TransferHeaderRec.Get(Rec."Document No.") then begin
            Rec.Validate("Transfer-to Code", TransferHeaderRec."Transfer-to Code");
            Rec.Validate("Transfer-To Bin Code", TransferHeaderRec."Transfer-To Bin Code");
        end;
        // use header transfer to bin code by default // YF 16 Sep 2021 Issue #257
        */
        // YF 28 Jan 2022 // To resolve item tracking issue
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        TransferHeaderRec: Record "Transfer Header";
    begin
        ExprDate := '';
        if Rec."Item No." <> '' then begin
            ExprDate := format(PMPCU.GetItemEarliestExpiration(Rec."Item No.", Rec."Transfer-from Code"));
        end else
            ExprDate := '';

        // use header transfer to bin code by default // YF 16 Sep 2021 Issue #257
        if TransferHeaderRec.Get(Rec."Document No.") then begin
            Rec."Transfer-to Code" := TransferHeaderRec."Transfer-to Code";
            Rec."Transfer-To Bin Code" := TransferHeaderRec."Transfer-To Bin Code";
        end;
        // use header transfer to bin code by default // YF 16 Sep 2021 Issue #257

    end;

    var
        ExprDate: Text;
        PMPCU: Codeunit "PMP-Enhancements";
}

