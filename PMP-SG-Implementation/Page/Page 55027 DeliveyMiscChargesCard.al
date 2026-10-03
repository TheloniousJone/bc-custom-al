page 55027 "Delivey Misc Charges Card"
{

    Caption = 'Delivey Misc Charges Card';
    PageType = Card;
    SourceTable = "Delivery Misc Charges";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field';
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field';
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                        CustRec: Record customer;
                    begin
                        if Rec."Customer No." <> xRec."Customer No." then begin
                            if xRec."Customer No." = '' then begin
                                CustRec.reset;
                                CustRec.SetRange("No.", Rec."Customer No.");
                                if CustRec.findfirst then begin
                                    Rec."Vendor No." := '';
                                    Rec.Address := CustRec.Address + ' ' + CustRec."Address 2";
                                    Rec.Branch := CustRec."Branch/Subsidiary";
                                    Rec.Instruction := CustRec."Delivery Instructions";
                                    Rec."Opening Hours" := CustRec."Working Hours";
                                    rec.Modify(FALSE);
                                end;
                            end else
                                if Confirm('Are you sure you wish to change the customer no.?') then begin
                                    CustRec.reset;
                                    CustRec.SetRange("No.", Rec."Customer No.");
                                    if CustRec.findfirst then begin
                                        Rec."Vendor No." := '';
                                        Rec.Address := CustRec.Address + ' ' + CustRec."Address 2";
                                        Rec.Branch := CustRec."Branch/Subsidiary";
                                        Rec.Instruction := CustRec."Delivery Instructions";
                                        Rec."Opening Hours" := CustRec."Working Hours";
                                        rec.Modify(FALSE);
                                    end;
                                end;

                        end;
                    end;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                        VendRec: Record Vendor;
                    begin
                        if Rec."Vendor No." <> xRec."Vendor No." then begin
                            if xRec."Vendor No." = '' then begin
                                VendRec.reset;
                                VendRec.SetRange("No.", Rec."Vendor No.");
                                if VendRec.findfirst then begin
                                    Rec."Customer No." := '';
                                    Rec.Address := VendRec.Address + ' ' + VendRec."Address 2";
                                    Rec.Branch := '';
                                    Rec.Instruction := '';
                                    Rec."Opening Hours" := '';
                                    rec.Modify(FALSE);
                                end;
                            end else
                                if Confirm('Are you sure you wish to change the vendor no.?') then begin
                                    VendRec.reset;
                                    VendRec.SetRange("No.", Rec."Vendor No.");
                                    if VendRec.findfirst then begin
                                        Rec."Customer No." := '';
                                        Rec.Address := VendRec.Address + ' ' + VendRec."Address 2";
                                        Rec.Branch := '';
                                        Rec.Instruction := '';
                                        Rec."Opening Hours" := '';
                                        rec.Modify(FALSE);
                                    end;
                                end;
                        end;
                    end;
                }

                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field';
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field(Branch; Rec.Branch)
                {
                    ToolTip = 'Specifies the value of the Branch field';
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field';
                    ApplicationArea = All;
                }
                field(Ice; Rec.Ice)
                {
                    ToolTip = 'Specifies the value of the Ice field';
                    ApplicationArea = All;
                }
                field("NCNG Amount"; Rec."NCNG Amount")
                {
                    ToolTip = 'Specifies the value of the NCNG Amount field';
                    ApplicationArea = All;
                }
                field("Opening Hours"; Rec."Opening Hours")
                {
                    ToolTip = 'Specifies the value of the Opening Hours field';
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Cheque No And Amt Coll."; Rec."Cheque No And Amt Coll.")
                {
                    ToolTip = 'Specifies the value of the Cheque No And Amt Coll. field';
                    ApplicationArea = All;
                }
                field("COD Amount"; Rec."COD Amount")
                {
                    ToolTip = 'Specifies the value of the COD Amount field';
                    ApplicationArea = All;
                }
                field(Instruction; Rec.Instruction)
                {
                    ToolTip = 'Specifies the value of the Instruction field';
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Delivery Charge"; Rec."Delivery Charge")
                {
                    ToolTip = 'Specifies the value of the Delivey Charge field';
                    ApplicationArea = All;
                }

                field(Driver; Rec.Driver)
                {
                    ToolTip = 'Specifies the value of the Driver field';
                    ApplicationArea = All;
                }

                field("LS Account"; Rec."LS Account")
                {
                    ToolTip = 'Specifies the value of the LS Account field';
                    ApplicationArea = All;
                }
            }
        }
    }

}
