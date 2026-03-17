namespace ALProject.ALProject;

using System.Security.User;

codeunit 50101 "Cashier Utility"
{
    TableNo = "Payment Order";

    trigger OnRun()
    begin
        // Standard OnRun logic if needed
    end;

    procedure SetStatusToWaitingApproval(var PayOrder: Record "Payment Order")
    var
        UserSetup: Record "User Setup";
        NoPermissionErr: Label 'Only Accountants can set the status to "Waiting Approval".';
    begin
        // 1. Get current user's permissions
        if UserSetup.Get(UserId) then begin
            // 2. Restriction: Only Accountants
            if not UserSetup."Is Accountant" then
                Error(NoPermissionErr);

            // 3. Update Status
            PayOrder.Status := PayOrder.Status::"Waiting Approval";
            PayOrder.Modify(true);
        end;
    end;

    procedure SetStatusToApproved(var PayOrder: Record "Payment Order")
    var
        UserSetup: Record "User Setup";
        NoPermissionErr: Label 'Only Managers can set the status to "Approved".';
    begin
        if UserSetup.Get(UserId) then begin
            // Restriction: Only Managers
            if not UserSetup."Is Manager" then
                Error(NoPermissionErr);

            PayOrder.Status := PayOrder.Status::Approved;
            PayOrder.Modify(true);
        end;
    end;

    procedure SetStatusToRejected(var PayOrder: Record "Payment Order")
    var
        UserSetup: Record "User Setup";
        NoPermissionErr: Label 'Only Managers can set the status to "Rejected".';
    begin
        if UserSetup.Get(UserId) then begin
            // Restriction: Only Managers
            if not UserSetup."Is Manager" then
                Error(NoPermissionErr);

            PayOrder.Status := PayOrder.Status::Rejected;
            PayOrder.Modify(true);
        end;
    end;

    // procedure CreateVoucher(var PayOrder: Record "Payment Order")
    // var
    //     JournalLine: Record "Income/Expense Journal";
    //     LastLineNo: Integer;
    // begin
    //     // 1. Find the next Line No.
    //     JournalLine.Reset();
    //     if JournalLine.FindLast() then
    //         LastLineNo := JournalLine."Line No." + 1
    //     else
    //         LastLineNo := 10000;

    //     // 2. Map fields from Order to Journal
    //     JournalLine.Init();
    //     JournalLine."Line No." := LastLineNo;
    //     JournalLine."Posting Date" := PayOrder."Posting Date";
    //     JournalLine."Document No." := PayOrder."Payment No.";
    //     JournalLine."Account Type" := PayOrder."Account Type";
    //     JournalLine."Account No." := PayOrder."Account No.";
    //     JournalLine."Currency Code" := PayOrder."Currency Code";
    //     JournalLine.Amount := PayOrder.Amount;
    //     JournalLine."Bal. Account Type" := PayOrder."Bal. Account Type";
    //     JournalLine."Bal. Account No." := PayOrder."Bal. Account No.";
    //     JournalLine."Bal. Currency Code" := PayOrder."Bal. Currency Code";
    //     JournalLine."Bal. Amount" := PayOrder."Bal. Amount";

    //     // Convert Option (Receipt-Payment) to Journal Type
    //     if PayOrder."Payment Type" = PayOrder."Payment Type"::Receipt then
    //         JournalLine."Journal Type" := JournalLine."Journal Type"::Receipt
    //     else
    //         JournalLine."Journal Type" := JournalLine."Journal Type"::Payment;

    //     JournalLine.Insert();

    //     // 3. Open the specific page based on Type
    //     if JournalLine."Journal Type" = JournalLine."Journal Type"::Receipt then
    //         Page.Run(Page::"Receipt Voucher Card", JournalLine)
    //     else
    //         Page.Run(Page::"Payment Voucher Card", JournalLine);
    // end;

}