pageextension 50021 HyphensPurchOrderPageExt extends "Purchase Order"
{
    layout
    {
        addlast(General)
        {
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
    actions
    {
        addafter(Print)
        {

            action("Print PO with Assembly")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category10;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    PORec: Record "Purchase Header";
                begin
                    CurrPage.SetSelectionFilter(PORec);
                    Report.Run(50019, true, false, PORec);
                end;
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
