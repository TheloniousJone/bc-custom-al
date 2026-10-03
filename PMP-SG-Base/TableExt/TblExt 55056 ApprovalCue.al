tableextension 55056 ApprovalCue extends "Approvals Activities Cue"
{
    fields
    {
        // Add changes to table fields here
        field(55001; "Approved Request"; Integer)

        {
            CalcFormula = Count("Approval Entry" WHERE("Sender ID" = FIELD("User ID Filter"),
                                                        Status = FILTER(Approved),
                                                        "Document Type" = filter(<> " "),
                                                        "Approval Type" = filter("Workflow User Group")));
            Caption = 'Approved Request';
            FieldClass = FlowField;

        }
    }

    var
        myInt: Integer;
}