namespace ALProject.ALProject;
page 50105 "Payment Order List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Payment Order";
    CardPageId = "Payment Order Card"; // Links to the Card for editing
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Payment No."; Rec."Payment No.") { ApplicationArea = All; }
                field("Account No."; Rec."Account No.") { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PrintOrder)
            {
                Caption = 'Print Payment Order';
                ApplicationArea = All;
                Image = Print;

                trigger OnAction()
                var
                    PayOrderHeader: Record "Payment Order";
                begin
                    PayOrderHeader.SetRange("Payment No.", Rec."Payment No.");
                    Report.Run(Report::"Payment Order Report", true, false, PayOrderHeader);
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        CashierUtils: Codeunit "Cashier Utility";
    begin
        CashierUtils.SetSecurityFilter(Rec);
    end;

}
