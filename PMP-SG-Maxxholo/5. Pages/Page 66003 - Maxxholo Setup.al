page 66003 "Maxxholo Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = MaxxholoSetup;
    DeleteAllowed = false;
    InsertAllowed = false;


    layout
    {
        area(Content)
        {
            group(General)
            {
                field(I9G_MaxxholoNos; Rec.I9G_MaxxholoNos)
                {
                    ApplicationArea = All;
                }
                field(I9G_MerchantID; Rec.I9G_MerchantID)
                {
                    ApplicationArea = All;
                }
                field(I9G_URL; Rec.I9G_URL)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the URL field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

}