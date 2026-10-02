pageextension 52150 PaymentJnlPageExtCiti extends "Payment Journal"
{
    layout
    {
        addafter("Bal. Account No.")
        {
            field("Citibank Product Type"; Rec."Citibank Product Type")
            {
                ApplicationArea = All;
            }

            // YF 24 Aug 2022
            field("Citibank Charge Indicator"; Rec."Citibank Charge Indicator")
            {
                ApplicationArea = All;
            }
            // YF 24 Aug 2022
        }
    }

    actions
    {
        addafter("F&unctions")
        {
            action("Export Citibank Local Payment")
            {
                Caption = 'Export Citibank Local Payment';
                ApplicationArea = All;
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(PaytJnlRec);
                    Xmlport.Run(52150, false, false, PaytJnlRec);
                end;
            }

            action("Export Citibank Foreign Payment")
            {
                Caption = 'Export Citibank Foreign Payment';
                ApplicationArea = All;
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(PaytJnlRec);
                    Xmlport.Run(52151, false, false, PaytJnlRec);
                end;
            }

            action("Export Citibank Local Payment Extended")
            {
                Caption = 'Export Citibank Local Payment File';
                ApplicationArea = All;
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(PaytJnlRec);
                    Xmlport.Run(52153, false, false, PaytJnlRec);
                end;
            }

            action("Export Citibank Foreign Payment Extended")
            {
                Caption = 'Export Citibank Foreign Payment File';
                ApplicationArea = All;
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(PaytJnlRec);
                    Xmlport.Run(52154, false, false, PaytJnlRec);
                end;
            }
        }
    }

    var
        PaytJnlRec: Record "Gen. Journal Line";
}