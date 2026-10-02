pageextension 60112 WellSalesInvListPageExt extends "Sales Invoice List"
{
    actions
    {
        addfirst(processing)
        {
            action("Create Wellaway Invs.")
            {
                ApplicationArea = All;
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    myInt: Integer;
                    WellCU: Codeunit "Wellaway CU";
                    CustList: Page "Customer List";
                    CustRec: Record customer;
                    selCustRec: Record customer;

                begin
                    if WellCU.IsPMPCompany() then begin
                        Page.Run(60110);
                    end else
                        Error('Please only execute this function in the PMP Company.');
                end;
            }

        }
    }
}