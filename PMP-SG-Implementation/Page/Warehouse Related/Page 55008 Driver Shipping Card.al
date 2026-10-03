page 55008 "Driver Shipping Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Driver Shipping Header";

    layout
    {
        area(Content)
        {
            group(Details)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shipping Bin"; Rec."Shipping Bin")
                {
                    ApplicationArea = All;
                    Caption = 'Delivery Zone';
                    trigger OnValidate()
                    begin


                        if Rec."Shipping Bin" <> '' then begin
                            if DriverCU.CountInvoicesInCage(Rec."Shipping Bin") then begin
                                Rec."Start Time" := CreateDateTime(today, time);
                                rec."Posting Date" := today;
                                CurrPage.Update(true);
                                DriverCU.CreateDriverCard(Rec);
                            end else begin
                                Message('No invoices in shipping cage, please recheck.');
                                rec."Shipping Bin" := '';
                            end;

                        end;
                    end;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Shipping Packages"; Rec."Shipping Packages")
                {

                    ApplicationArea = all;
                    Editable = false;
                }

            }
            part(Subform; "Driver Shipping Subform")
            {
                SubPageLink = "Driver Doc No." = field("No.");
                UpdatePropagation = Both;
                ApplicationArea = all;
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("Add Exchange")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = New;
                Image = Add;
                trigger OnAction();
                var
                    ExchangePage: page "Add Driver Exchange";
                begin
                    if Confirm('Are you sure you wish ot create an exchange line for Driver?') then begin
                        ExchangePage.SetDocNo(Rec."No.");
                        ExchangePage.RunModal();
                        Message('Exchange item added.');
                    end
                end;
            }
        }
    }

    var
        DriverCU: codeunit "Driver CU";
}