pageextension 50026 HyphensPostedPurchCrMemoPage extends "Posted Purchase Credit Memo"
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
