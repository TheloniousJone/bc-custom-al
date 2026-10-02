page 55087 PLCheck
{

    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = integer;
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = true;
    Caption = 'Options';

    layout
    {
        area(content)
        {

            field(ItemEntry; ItemEntry)

            {
                ApplicationArea = all;
                TableRelation = Item."No.";
            }
            //DX        05 Oct 2021
            field(DateRange; DateRange)
            {
                ApplicationArea = all;
            }
            field(EndDate; enddate)
            {
                ApplicationArea = all;
            }
            field(Basket; Basket)
            {
                ApplicationArea = all;
                TableRelation = Basket;
            }
            //DX        05 Oct 2021
        }
    }


    procedure ReturnDate(): Date
    var
        myInt: Integer;
    begin
        exit(DateRange);
    end;


    procedure GetItem(): Code[20]
    var
        myInt: Integer;
    begin
        exit(ItemEntry);

    end;

    procedure GetBasket(): Code[20]
    var
        myInt: Integer;
    begin
        exit(Basket);

    end;

    procedure GetEndDate(): date
    var
        myInt: Integer;
    begin
        exit(enddate);

    end;

    trigger OnInit()
    var
        myInt: Integer;
    begin
        DateRange := today;
        enddate := today;
    end;

    var
        DateRange: Date;
        ItemEntry: Code[20];
        Basket: Code[20];
        enddate: date;
}

