table 55046 RoleCentreCues
{
    Caption = 'RoleCentreCues';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PrimaryKey; Code[250])
        {
            Caption = 'PrimaryKey';
            DataClassification = ToBeClassified;
        }
        field(10; UnprintedTBADel; Integer)
        {
            Caption = 'Unprinted TBA Deliveries';

            FieldClass = FlowField;
            CalcFormula = count("TBA Ledger Entry" where("Entry Type" = filter(Delivery), "TBA Printed" = const(false)));
        }
        //DX        18 Sept 2021
        field(20; UnpickedPL; Integer)
        {
            Caption = 'Unpicked Pick Lists';
            FieldClass = FlowField;
            CalcFormula = count("Assignment Ledger Entry" where(Status = const(Processing)));
        }
        field(30; "Wellaway TO"; Integer)
        {
            Caption = 'Unprocessed Wellaway TOs';
            FieldClass = FlowField;
            CalcFormula = count("Transfer Header" where("Transfer-to Code" = const('WELLAWAY'), "Completely Shipped" = const(false)));
        }
        field(40; "SRO Returns for Rebill"; Integer)
        {
            Caption = 'Unprocessed SRO for Checker';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Document Type" = const("Return Order"), "Return Status" = filter('Checker to verify'), Rebill = const(true)));
        }
        //DX        18 Sept 2021

        //DX        06 Oct 2021
        field(50; "Pending Wellaway TO to receive"; Integer)
        {
            Caption = 'Unprocessed Wellaway TOs';
            FieldClass = FlowField;
            CalcFormula = count("Transfer Header" where("Transfer-to Code" = const('WELLAWAY'), "Completely Shipped" = const(true)));
        }
        //DX        06 Oct 2021

        // YF        14 Oct 2021
        field(60; "SO Lines without Stock"; Integer)
        {
            Caption = 'No. of Sales Lines without Stock';
            FieldClass = FlowField;
            CalcFormula = count("Sales Line" where("Document Type" = const("Order"), "Type" = const("Item"), "Out of Stock" = const(true)));
        }

        field(70; "SO Lines to Replenish"; Integer)
        {
            Caption = 'No. of Sales Lines to Replenish';
            FieldClass = FlowField;
            CalcFormula = count("Sales Line" where("Document Type" = const("Order"), "Type" = const("Item"), "Out of Stock" = const(false), "Insufficient Stocks in Pick" = const(true)));
        }
        // YF        14 Oct 2021
        //DX        17 Oct 2021
        field(80; "Unapproved PMP SOs"; Integer)
        {
            Caption = 'Unapproved PMP SOs';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Document Type" = const(Order), "Logistics Service" = const(false), Archived = const(false), Status = const(Open), "Order Status" = const(Open)));
        }
        field(90; "Approved PMP SOs"; Integer)
        {
            Caption = 'Approved PMP SOs to process';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Document Type" = const(Order), "Logistics Service" = const(false), Archived = const(false), Status = const(Released), "Order Status" = const(open)));
        }

        field(100; "Released SOs For Picking"; Integer)
        {
            Caption = 'Rel. SOs for Picking';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Document Type" = const(Order), "Logistics Service" = const(false), Archived = const(false), Status = const(Released), "Order Status" = const(processing)));
        }
        //DX        17 Oct 2021
        //RL        03 Nov 2021
        field(110; "Partial Delivered SO"; Integer)
        {
            Caption = 'Partial Delivered SO';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Document Type" = const(Order), "Logistics Service" = const(false), Archived = const(false), "Chain Pharmacy" = const(false), Ship = const(true)));
        }

        //RL        08 Jun 2022
        field(120; "STO Replenished"; Integer)
        {
            Caption = 'STO Replenished';
            FieldClass = FlowField;
            CalcFormula = count("Sales Line" where("Document Type" = const(Order), "Out of Stock" = const(false), "Insufficient Stocks in Pick" = const(false), "I9G Item Status" = filter('SPECIAL-TO-ORDER'), "Outstanding Quantity" = filter(<> 0)));
        }

        //RL        01 Feb 2023
        field(130; "Unarchived SO OOS"; Integer)
        {
            Caption = 'No. of Unarchived SO OOS';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Document Type" = const("Order"), Archived = filter('No'), "Out of Stock" = const(true), "Logistics Service" = filter('No')));
        }

        //RL        06 Feb 2023
        field(140; "Unapproved PMP SOs no Chain"; Integer)
        {
            Caption = 'Unapproved PMP SOs Without Chain';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Document Type" = const(Order), "Logistics Service" = const(false), Archived = const(false), Status = const(Open), "Order Status" = const(Open), "Chain Pharmacy" = const(false)));
        }
        //RL        06 Feb 2023
        field(150; "Open Transfer Order"; Integer)
        {
            Caption = 'Open Transfer Order';
            FieldClass = FlowField;
            CalcFormula = count("Transfer Header" where(Status = const(Open)));
        }
        field(160; "Released Transfer Order"; Integer)
        {
            Caption = 'Released Transfer Order';
            FieldClass = FlowField;
            CalcFormula = count("Transfer Header" where(Status = const(Released)));
        }
        field(170; "Sales Return Orders"; Integer)
        {
            Caption = 'Sales Return Orders';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Document Type" = const("Return Order")));
        }
        //SJ        20 Dec 2023
        field(180; "Ongoing HQ Orders"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = const(Order),
                                                             "Order Status" = filter(Open | Processing),
                                                             "Sell-to Customer No." = filter('G035HQ' | 'W003888' | 'N043HQ' | 'N043JKC' | 'N043JOO' | 'W084YUS' | 'W003828' | 'N105PRXJ'),
                                                             Archived = const(false)));
            Caption = 'Ongoing HQ Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(190; "Ongoing Priority Orders"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = const(Order),
                                                            "Priority Picking" = const(true),
                                                            "Order Status" = const(Processing),
                                                            Archived = const(false)));
            Caption = 'Ongoing Priority Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        //SJ        20 Dec 2023
    }
    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }

}
