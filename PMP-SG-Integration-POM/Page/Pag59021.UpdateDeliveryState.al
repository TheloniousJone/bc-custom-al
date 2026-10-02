page 59021 "POM Update Delivery State"
{

    ApplicationArea = All;
    Caption = 'POM Update Delivery State';
    PageType = Card;
    SourceTable = "POM Delivery State Buffer";
    UsageCategory = Lists;
    SourceTableTemporary = true;

    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;

    Permissions = tabledata "Sales Invoice Header" = rimd;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("POMReferenceID"; Rec."POM Reference No.")
                {
                    ApplicationArea = All;
                }

                field(Processed; Rec.Processed)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        PostedSalesInvHdrRec: Record "Sales Invoice Header";
                    begin
                        PostedSalesInvHdrRec.Reset();
                        PostedSalesInvHdrRec.SetRange("Your Reference", Rec."POM Reference No.");
                        PostedSalesInvHdrRec.SetRange("Order Status", PostedSalesInvHdrRec."Order Status"::Completed);
                        PostedSalesInvHdrRec.ModifyAll("Processed by POM", Rec.Processed, false);
                    end;
                }
            }
        }
    }

}
