page 56000 "EPaper Integration Setup"
{
    Caption = 'EPaper Integation Setup';
    PageType = Card;
    SourceTable = "EPaper Integration Setup";
    PromotedActionCategories = 'Actions';
    UsageCategory = Administration; // Searchable Option
    Editable = true;
    AdditionalSearchTerms = 'EPaper Integration Setup,EPaper,ETag,LED,Setup,Config,Configuration';
    ApplicationArea = All;

    layout
    {
        area(content)
        {

            group(General)
            {
                Caption = 'General';

                field("Login API URL"; Rec."Login API URL")
                {
                    ApplicationArea = All;
                }

                field("Turn On LED API URL"; Rec."Turn On LED API URL")
                {
                    ApplicationArea = All;
                }

                field("Turn Off LED API URL"; Rec."Turn Off LED API URL")
                {
                    ApplicationArea = All;
                }

                field("Login ID"; Rec."Login ID")
                {
                    ApplicationArea = All;
                }

                field(Password; Rec.Password)
                {
                    ApplicationArea = All;
                }

                field(Token; Rec.Token)
                {
                    ApplicationArea = All;
                }

                field("Turn On LED Timer in Seconds"; Rec."Turn On LED Timer in Seconds")
                {
                    ApplicationArea = All;
                }

                field("Default Tag Type"; Rec."Default Tag Type")
                {
                    ApplicationArea = All;
                }

                field("Enable Logging"; Rec."Enable Logging")
                {
                    ApplicationArea = All;
                }
                field("Enable Etag LED on Picklist"; Rec."Enable Etag LED on Picklist")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enable to use Etag LED on pick list';
                }


            }

        }
    }

    actions
    {
        area(Processing)
        {
            group(Process)
            {
                action("Test Login Connection")
                {
                    ApplicationArea = all;
                    Caption = 'Test Login Connection';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = TestDatabase;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        IntegrationCU: Codeunit "EPaper Integrations";
                        tokenResult: Text;
                    begin
                        tokenResult := IntegrationCU.Login();
                        if StrLen(tokenResult) > 0 then
                            Message('Token Received. Login Successful. Result - ' + tokenResult)
                        else
                            Message('Login Connection Test Failed');
                    end;
                }

            }

        }
    }

}

