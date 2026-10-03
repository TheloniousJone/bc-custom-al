Report 80139 ProcessAndDataControl
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Process and Data Control';
    ProcessingOnly = true;

    Dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));
            trigger OnAfterGetRecord()
            var
            begin
                case OptionValue of
                    1:
                        PriorityPicking();
                    2:
                        I9G_ThirdPartyLogisticCU.UpdateSpecialOrder();
                    3:
                        I9G_ThirdPartyLogisticCU.InsertAssignmentLedgerEntry();
                    4:
                        I9G_ThirdPartyLogisticCU.UpdateExpirationDate();
                    5:
                        I9G_DimensionSetCleanupCU.BackUpDimensionSetsAsConfigPackage();
                    6:
                        I9G_DimensionSetCleanupCU.CountDimSetRepointImpact();
                    7:
                        I9G_DimensionSetCleanupCU.RepointAndDeleteDuplicateDimensionSets();
                end;
            end;
        }
    }
    Requestpage
    {
        layout
        {
            area(Content)
            {
                group("Data Patching")
                {
                    field(PriorityPicking; '1')
                    {
                        Caption = 'Priority Picking';
                        ApplicationArea = All;
                    }
                    field(UpdateSpeicalOrder; '2')
                    {
                        Caption = 'Update Special Order';
                        ApplicationArea = All;
                    }
                    field(InsertAssignmentLedgerEntry; '3')
                    {
                        Caption = 'Insert Assignment Ledger Entry';
                        ApplicationArea = All;
                    }
                    field(UpdateExpirationDate; '4')
                    {
                        Caption = 'Update Expiration Date';
                        ApplicationArea = All;
                    }
                    field(BackUpDimensionSetsAsConfigPackage; '5')
                    {
                        Caption = 'Back Up Dimension Sets as Config Package';
                        ApplicationArea = All;
                    }
                    field(CountDimSetImpact; '6')
                    {
                        Caption = 'Count Duplicate Dimension Set Impact (read-only)';
                        ApplicationArea = All;
                    }
                    field(RepointAndDeleteDimSets; '7')
                    {
                        Caption = 'Repoint and Delete Duplicate Dimension Sets';
                        ApplicationArea = All;
                    }
                }
                group("Option Values")
                {
                    field(OptionValue; OptionValue)
                    {
                        ApplicationArea = All;
                        Caption = 'Enter the option value :';
                    }
                    field(DocumentNo; DocumentNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Enter the Document No. :';
                    }
                }
            }
        }

        trigger OnOpenPage()
        var
            UserRec: Record User;
        begin
            UserRec.Reset();
            UserRec.SetRange("User Security ID", UserSecurityId());
            if UserRec.FindFirst() then begin
                if UserRec."Authentication Email".Contains('9itgroup') or UserRec."Authentication Email".Contains('Illum (9) Pte Ltd Technician')
                or UserRec."Authentication Email".Contains('bcadmin@pom.com.sg') or UserRec."Authentication Email".Contains('illum9@hyphens.com.sg') then begin
                    Message('Welcome to Admin page.');
                end else begin
                    Error('You do not have the permission to view or execute the current report.');
                end;
            end;
        end;
    }

    var
        OptionValue: Integer;
        DocumentNo: Code[250];
        I9G_ThirdPartyLogisticCU: Codeunit I9G_ThirdPartyLogisticCU;
        I9G_DimensionSetCleanupCU: Codeunit I9G_DimensionSetCleanupCU;

    local procedure PriorityPicking()
    var
        AssignmentLedgerEntryRec: Record "Assignment Ledger Entry";
    begin
        AssignmentLedgerEntryRec.Reset();
        AssignmentLedgerEntryRec.SetRange("Document No.", DocumentNo);
        AssignmentLedgerEntryRec.SetRange("Priority Picking", false);
        if AssignmentLedgerEntryRec.FindFirst() then begin
            AssignmentLedgerEntryRec."Priority Picking" := true;
            AssignmentLedgerEntryRec."Pick Type" := AssignmentLedgerEntryRec."Pick Type"::"Non-Cold";
            AssignmentLedgerEntryRec.Modify();
        end;
    end;
}
