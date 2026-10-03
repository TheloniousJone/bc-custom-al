page 59000 SPCustomer
{

    ApplicationArea = All;
    Caption = 'SPCustomer';
    PageType = List;
    SourceTable = Customer;
    UsageCategory = History;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field';
                    ApplicationArea = All;
                }
                field("POM No."; Rec."POM No.")
                {
                    ToolTip = 'Specifies the value of the POM No. field';
                    ApplicationArea = All;
                }
                field("POM Customer"; Rec."POM Customer")
                {
                    ToolTip = 'Specifies the value of the POM Customer field';
                    ApplicationArea = All;
                }
                field("Name 2"; Rec."Name 2")
                {
                    ToolTip = 'Specifies the value of the Name 2 field';
                    ApplicationArea = All;
                }
                field("Corporate  Sales Rep (HB)"; Rec."Corporate  Sales Rep (HB)")
                {
                    ToolTip = 'Specifies the value of the Corporate  Sales Rep (HB) field';
                    ApplicationArea = All;
                }
                field("Corporate  Sales Rep (HYP)"; Rec."Corporate  Sales Rep (HYP)")
                {
                    ToolTip = 'Specifies the value of the Corporate  Sales Rep (HYP) field';
                    ApplicationArea = All;
                }
                field("Corporate  Sales Rep (WS)"; Rec."Corporate  Sales Rep (WS)")
                {
                    ToolTip = 'Specifies the value of the Corporate  Sales Rep (WS) field';
                    ApplicationArea = All;
                }
                field("Corporate  Sales Rep (4)"; Rec."Corporate  Sales Rep (4)")
                {
                    ToolTip = 'Specifies the value of the Corporate  Sales Rep (4) field';
                    ApplicationArea = All;
                }
                field("Corporate  Sales Rep (5)"; Rec."Corporate  Sales Rep (5)")
                {
                    ToolTip = 'Specifies the value of the Corporate  Sales Rep (5) field';
                    ApplicationArea = All;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ToolTip = 'Specifies the value of the Salesperson Code field';
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field';
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ToolTip = 'Specifies the value of the Address 2 field';
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Country/Region Code field';
                    ApplicationArea = All;
                }
                field("Customer Status"; Rec."Customer Status")
                {
                    ToolTip = 'Specifies the value of the Customer Status field';
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the value of the Email field';
                    ApplicationArea = All;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ToolTip = 'Specifies the value of the Fax No. field';
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'Specifies the value of the Mobile Phone No. field';
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        SPFilter: Code[50];

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        SPFilter := Rec.GetFilter("Name");
        if SPFilter <> '' then begin
            SetPageData(SPFilter);
        end;

    end;

    procedure SetPageData(SPCode: Code[50])
    var
        myInt: Integer;
        CustRec: Record customer;
        TempRec: Record Customer temporary;
    begin
        CustRec.reset;
        CustRec.SetRange("Corporate  Sales Rep (HB)", SPCode);
        if CustRec.FindSet() then
            repeat
                TempRec.reset;
                TempRec.SetRange("No.", CustRec."No.");
                if not (TempRec.FindFirst()) then begin
                    Rec.Init();
                    Rec.copy(CustRec);
                    Rec.Insert(false);
                    TempRec.copy(Rec);
                    TempRec.Insert(false);
                    myInt += 1;
                end;
            until CustRec.next = 0;


        CustRec.reset;
        CustRec.SetRange("Corporate  Sales Rep (HYP)", SPCode);
        if CustRec.FindSet() then
            repeat
                TempRec.reset;
                TempRec.SetRange("No.", CustRec."No.");
                if not (TempRec.FindFirst()) then begin
                    Rec.Init();
                    Rec.copy(CustRec);
                    Rec.Insert(false);
                    TempRec.copy(Rec);
                    TempRec.Insert(false);
                    myInt += 1;
                end;
            until CustRec.next = 0;


        CustRec.reset;
        CustRec.SetRange("Corporate  Sales Rep (WS)", SPCode);
        if CustRec.FindSet() then
            repeat
                TempRec.reset;
                TempRec.SetRange("No.", CustRec."No.");
                if not (TempRec.FindFirst()) then begin
                    Rec.Init();
                    Rec.copy(CustRec);
                    Rec.Insert(false);
                    TempRec.copy(Rec);
                    TempRec.Insert(false);
                    myInt += 1;
                end;
            until CustRec.next = 0;


        CustRec.reset;
        CustRec.SetRange("Corporate  Sales Rep (4)", SPCode);
        if CustRec.FindSet() then
            repeat
                TempRec.reset;
                TempRec.SetRange("No.", CustRec."No.");
                if not (TempRec.FindFirst()) then begin
                    Rec.Init();
                    Rec.copy(CustRec);
                    Rec.Insert(false);
                    TempRec.copy(Rec);
                    TempRec.Insert(false);
                    myInt += 1;
                end;
            until CustRec.next = 0;

        CustRec.reset;
        CustRec.SetRange("Corporate  Sales Rep (5)", SPCode);
        if CustRec.FindSet() then
            repeat
                TempRec.reset;
                TempRec.SetRange("No.", CustRec."No.");
                if not (TempRec.FindFirst()) then begin
                    Rec.reset;
                    Rec.Init();
                    Rec.copy(CustRec);
                    Rec.Insert(false);
                    TempRec.reset;
                    TempRec.copy(Rec);
                    TempRec.Insert(false);
                    myInt += 1;
                end;
            until CustRec.next = 0;


        Rec.reset;
        rec."No." := 'TOTALREC';
        Rec.Name := format(myInt);
        Rec.Insert(FALSE);

    end;

}
