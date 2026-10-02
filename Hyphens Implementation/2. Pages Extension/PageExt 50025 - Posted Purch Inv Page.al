pageextension 50025 HyphensPostedPurchInvPageExt extends "Posted Purchase Invoice"
{
    layout
    {
        addlast(General)
        {
            field("Freight Forwarder"; Rec."Freight Forwarder")
            {
                ApplicationArea = All;
            }
            field("Freight Forwarder Invoice No."; Rec."Freight Forwarder Invoice No.")
            {
                ApplicationArea = All;
            }
            field("Shipment Temperature Status"; Rec."Shipment Temperature Status")
            {
                ApplicationArea = All;
            }
            field("Actual ETD"; Rec."Actual ETD")
            {
                ApplicationArea = All;
            }
            field("Actual ETA-Port"; Rec."Actual ETA-Port")
            {
                ApplicationArea = All;
            }
            group("Requirements")
            {
                Visible = ShowReqTemplateFeature;

                field("Template Code"; Rec."Template Code")
                {
                    ApplicationArea = All;
                    Caption = 'Requirement Template Code';
                    Visible = ShowReqTemplateFeature;
                }

                field("Shelf Life Requirement"; Rec."Shelf Life Requirement")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    Visible = ShowReqTemplateFeature;
                }

                field("Marking Requirement"; Rec."Marking Requirement")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    Visible = ShowReqTemplateFeature;
                }

                field("Packing Requirement"; Rec."Packing Requirement")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    Visible = ShowReqTemplateFeature;
                }

                field("Document Requirement"; Rec."Document Requirement")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    Visible = ShowReqTemplateFeature;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field(Shipment_Remarks; Rec."Shipment Remarks")
                {
                    ApplicationArea = All;
                }
            }

        }
    }

    trigger OnOpenPage()
    var
        CompanyInfoRec: Record "Company Information";
    begin
        CompanyInfoRec.Get;
        ShowReqTemplateFeature := CompanyInfoRec."Enable Purch. Req. Template";
    end;

    var
        ShowReqTemplateFeature: Boolean;
}
