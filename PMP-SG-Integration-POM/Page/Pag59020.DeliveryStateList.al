page 59020 "POM Delivery State List"
{

    ApplicationArea = All;
    Caption = 'POM Delivery State List';
    PageType = List;
    SourceTable = "POM Delivery State Buffer";
    UsageCategory = Lists;
    SourceTableTemporary = true;
    /*
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    */

    Permissions = tabledata "Sales Invoice Header" = rimd;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }

                field("POM Reference No."; Rec."POM Reference No.")
                {
                    ApplicationArea = All;
                }

                field("SO Count"; Rec."SO Count")
                {
                    ApplicationArea = All;
                }

                field("Posted Inv. Count"; Rec."Posted Inv. Count")
                {
                    ApplicationArea = All;
                }

                field("Posted Inv. to Process Count"; Rec."Posted Inv. to Process Count")
                {
                    ApplicationArea = All;
                }

                /*
                field("Good To Process"; Rec."Good To Process")
                {
                    ApplicationArea = All;
                }
                */

                field(Processed; Rec.Processed)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        PostedSalesInvHdrRec: Record "Sales Invoice Header";
                    begin
                        if Rec.Processed then begin
                            PostedSalesInvHdrRec.Reset();
                            PostedSalesInvHdrRec.SetRange("Your Reference", Rec."POM Reference No.");
                            PostedSalesInvHdrRec.SetRange("Order Status", PostedSalesInvHdrRec."Order Status"::Completed);
                            PostedSalesInvHdrRec.ModifyAll("Processed by POM", true, false);
                        end;
                    end;
                }

            }
        }
    }

    trigger OnOpenPage()
    begin
        GetDataFromQuery();
    end;

    local procedure GetDataFromQuery()
    var
        EntryNo: Integer;
        POMRefDistinctQuery: Query "POM Ref Distinct Query";
    begin
        EntryNo := 1;
        POMRefDistinctQuery.SetFilter(Posting_Date_Filter, '>=01072022');
        // POMRefDistinctQuery.SetRange(Your_Reference_Filter, 'P3-RETAIL-STAFF-29948');

        if POMRefDistinctQuery.Open() then begin
            while POMRefDistinctQuery.Read() do begin
                // EntryNo += 1;
                Rec.Reset();
                Rec.Init();
                Rec."Entry No." := EntryNo;
                Rec."POM Reference No." := POMRefDistinctQuery.Your_Reference;
                Rec."Posted Inv. Count" := POMRefDistinctQuery.Count;
                if Rec.Insert(false) then
                    EntryNo += 1;
            end;
        end;
        POMRefDistinctQuery.Close();
    end;
}
