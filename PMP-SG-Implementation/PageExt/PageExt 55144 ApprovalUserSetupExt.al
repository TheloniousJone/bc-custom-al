pageextension 55144 ApprovalUserSetupExt extends "Approval User Setup"
{
    actions
    {
        addafter("&Approval User Setup Test")
        {
            action("Update User Logins")
            {
                ApplicationArea = All;
                Image = Refresh;

                trigger OnAction()
                var
                    UserRec: Record User;
                    UserSetupRec: Record "User Setup";
                begin
                    if UserRec.FindSet() then begin
                        repeat
                            UserSetupRec.Reset();
                            UserSetupRec.SetRange("User ID", UserRec."User Name");
                            if (not UserSetupRec.FindFirst()) and (UserRec.State <> UserRec.State::Disabled) then begin
                                UserSetupRec.Init();
                                UserSetupRec.Validate("User ID", UserRec."User Name");
                                // UserSetupRec.Validate("Approver ID", 'FEIYUEBC_FLOW');
                                UserSetupRec.Validate("E-Mail", UserRec."Authentication Email");
                                /*
                                UserSetupRec."User ID" := UserRec."User Name";
                                UserSetupRec."Approver ID" := 'FEIYUEBC_FLOW';
                                UserSetupRec."E-Mail" := UserRec."Authentication Email";
                                */
                                UserSetupRec.Insert(true);
                            end;
                        until UserRec.Next() = 0;
                    end;

                    if UserRec.FindSet() then
                        SyncUserSetupCrossCompanies();
                end;
            }
        }
    }

    local procedure SyncUserSetupCrossCompanies()
    var
        CompanyRec: Record Company;
        UserRec: Record User;
        UserSetupRec: Record "User Setup";
    begin
        CompanyRec.SetFilter(Name, '<>%1', CompanyName);

        IF CompanyRec.FINDSET THEN BEGIN
            REPEAT

                UserRec.ChangeCompany(CompanyRec.Name);
                UserSetupRec.ChangeCompany(CompanyRec.Name);

                if UserRec.FindSet() then begin
                    repeat
                        UserSetupRec.Reset();
                        UserSetupRec.SetRange("User ID", UserRec."User Name");
                        if (not UserSetupRec.FindFirst()) and (UserRec.State <> UserRec.State::Disabled) then begin
                            UserSetupRec.Init();
                            UserSetupRec.Validate("User ID", UserRec."User Name");
                            // UserSetupRec.Validate("Approver ID", 'FEIYUEBC_FLOW');
                            UserSetupRec.Validate("E-Mail", UserRec."Authentication Email");
                            /*
                            UserSetupRec."User ID" := UserRec."User Name";
                            UserSetupRec."Approver ID" := 'FEIYUEBC_FLOW';
                            UserSetupRec."E-Mail" := UserRec."Authentication Email";
                            */
                            UserSetupRec.Insert(true);
                        end;
                    until UserRec.Next() = 0;
                end;

            UNTIL CompanyRec.NEXT = 0;

            // CurrPage.Update();

            MESSAGE('Replication Completed');
        END
        ELSE
            ERROR('No Company to Replicate');
    end;
}