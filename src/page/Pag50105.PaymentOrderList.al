namespace ALProject.ALProject;
using System.Security.User;

page 50105 "Payment Order List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists; // This is what people search for
    SourceTable = "Payment Order";
    CardPageId = "Payment Order"; // Links to your Document Page 50103
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

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId) then exit;

        // Restriction Logic
        if UserSetup."Is Cashier" and not UserSetup."Is Manager" then
            Rec.SetFilter(Status, '%1|%2', Rec.Status::Approved, Rec.Status::Finalaized);

        if UserSetup."Is Accountant" and not UserSetup."Is Manager" then
            Rec.SetFilter(Status, '%1|%2|%3', Rec.Status::Processing, Rec.Status::Rejected, Rec.Status::Finalaized);

        // Managers see everything, so no filter is applied.
    end;
}
