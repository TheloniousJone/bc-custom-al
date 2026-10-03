pageextension 50009 HyphensSalesShipmentPageExt extends "Posted Sales Shipment"
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
        addafter("&Print")
        {
            action("Print Delivery Order")
            {
                ApplicationArea = All;
                Caption = 'Print Delivery Order';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    SalesShipmentHeader: Record "Sales Shipment Header";
                begin
                    CurrPage.SetSelectionFilter(SalesShipmentHeader);

                    Report.RunModal(Report::"Hyphens Posted Delivery Order", true, false, SalesShipmentHeader);
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