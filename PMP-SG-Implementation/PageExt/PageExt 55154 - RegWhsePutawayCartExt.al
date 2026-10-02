pageextension 55154 RegWhsePutawayCardExt extends "Registered Put-away"
{
    layout
    {
        // layout changes here
        addlast(General)
        {
            field(SystemCreatedAt;Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Caption = 'Created At';
                    Editable = false;
                }
                field(SystemCreatedBy;Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                    Caption = 'Created By';
                    Editable = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    Caption = 'Modified At';
                    Editable = false;
                }
                field(SystemModifiedBy;Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                    Caption = 'Modified By';
                    Editable = false;
                }
        }

    }

    actions
    {
        // action changes here
    }

}
