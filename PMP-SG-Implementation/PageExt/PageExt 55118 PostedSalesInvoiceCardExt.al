pageextension 55118 PostedSalesInvCardExt extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Shipping Agent Code")
        {
            field("Arrival Port"; Rec."Arrival Port")
            {
                ApplicationArea = All;
            }
            field("Order Taken By"; Rec."Order Taken By")
            {
                ApplicationArea = all;
            }
        }
        addafter(Closed)
        {
            field("Samples SO"; Rec."Samples SO")
            {
                ApplicationArea = All;
            }
            field("Order Status"; Rec."Order Status")
            {
                ApplicationArea = All;
            }
        }
        addlast(General)
        {

            field(I9G_Wellaway_Pick; Rec.I9G_Wellaway_Pick)
            {
                ApplicationArea = all;
            }
            field("I9G Line Export"; Rec."I9G Line Export")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the POM Line Export field.';
            }
            field("Customer Group"; Rec."Customer Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Group field.', Comment = '%';
            }

            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Caption = 'Created At';
                Editable = false;
            }
            field(SystemCreatedBy; Rec.SystemCreatedBy)
            {
                ApplicationArea = All;
                Caption = 'Created By';
                Editable = false;
            }
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                Caption = 'Modified At';
                Editable = false;
            }
            field(SystemModifiedBy; Rec.SystemModifiedBy)
            {
                ApplicationArea = All;
                Caption = 'Modified By';
                Editable = false;
            }

            // Add system last modified at field // Begin
            field("I9G_SystemModifiedAt"; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                Visible = false;
            }
            // Add system last modified at field // End
        }

        addafter("Posting Date")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;

            }
        }

    }
    actions
    {
        addafter(Print)
        {
            action("Print Delivery List")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Report.Run(57101);
                end;
            }
            action("Print LS Delivery List")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Report.Run(57111);
                end;
            }
            action("Print LS Delivery Order")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SIHRec: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SIHRec);
                    Report.Run(57025, true, false, SIHRec);
                    //Report.Run(57101);
                end;
            }
            action("Print Sales Invoice")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SIHRec: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SIHRec);
                    Report.Run(57001, true, false, SIHRec);
                end;
            }
            action("Print Sales GL Invoice")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SIHRec: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SIHRec);
                    Report.Run(57023, true, false, SIHRec);
                end;
            }
            action("Print Rebill Sales Invoice")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SIHRec: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SIHRec);
                    Report.Run(57027, true, false, SIHRec);
                end;
            }
            action("Print Posted Waybill")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SIHRec: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SIHRec);
                    Report.Run(57013, true, false, SIHRec);
                    //Report.Run(57101);
                end;
            }
            action("Reset POM export")
            {
                ApplicationArea = all;
                Image = Export;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PMPCU: Codeunit "PMP-Enhancements";
                begin
                    PMPCU.ResetPOM(Rec."No.");

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin

    end;

    var
        CustRec: Record customer;
        Branch: text[100];


}
