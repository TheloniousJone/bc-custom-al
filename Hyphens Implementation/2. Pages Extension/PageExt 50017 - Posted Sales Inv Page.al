pageextension 50017 HyphensPostedSalesInvPageExt extends "Posted Sales Invoice"
{
    layout
    {

        addlast(General)
        {
            field(I9_ContractDate; Rec.I9_ContractDate)
            {
                ApplicationArea = All;
                Importance = Promoted;
            }

            field(I9_ContractNo; Rec.I9_ContractNo)
            {
                ApplicationArea = All;
                Importance = Promoted;
            }

            field(I9_ContractAmount; Rec.I9_ContractAmount)
            {
                ApplicationArea = All;
                Importance = Promoted;
            }
            group("Peg Data")
            {
                Visible = ShowPegFeature;

                field("Peg Rate"; Rec."Peg Rate")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = ShowPegFeature;
                }

                field("VND Amount"; Rec."VND Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = ShowPegFeature;
                }

                field("VND-LCY Rate"; Rec."VND-LCY Rate")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = ShowPegFeature;
                }

                field("Peg SGD Amount"; Rec."Peg SGD Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = ShowPegFeature;
                }

                field("FCY-LCY Rate"; Rec."FCY-LCY Rate")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = ShowPegFeature;
                }

                field("LCY Amount"; Rec."LCY Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = ShowPegFeature;
                }

                field(Adjustment; Rec.Adjustment)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = ShowPegFeature;
                }
            }

        }
    }
    actions
    {
        addafter(Print)
        {
            action(PackingList)
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Caption = 'Print Packing List';
                trigger OnAction()
                var
                    SIHRec: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SIHRec);
                    Report.Run(50016, true, false, SIHRec);
                end;
            }
            action(VNInvoice)
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Caption = 'Print VN Invoice';
                trigger OnAction()
                var
                    SIHRec: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SIHRec);
                    Report.Run(50020, true, false, SIHRec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        CompanyInfoRec: Record "Company Information";
    begin
        CompanyInfoRec.Get;
        ShowPegFeature := CompanyInfoRec."Enable Peg Rate Module";
    end;

    var
        ShowPegFeature: Boolean;

}