// codeunit 50101 "Cashier Utility"
// {
//     procedure ChangeStatus(var PayOrder: Record "Payment Order"; NewStatus: Option Processing,"Waiting Approval",Approved,Rejected,Finalized)
//     begin
//         case NewStatus of
//             PayOrder.Status::"Waiting Approval":
//                 CheckAccountantRole();
//             PayOrder.Status::Approved, PayOrder.Status::Rejected:
//                 CheckManagerRole();
//         end;

//         PayOrder.Validate(Status, NewStatus);
//         PayOrder."Last Date Modified " := Today;
//         PayOrder.Modify(true);
//     end;

//     local procedure CheckAccountantRole()
//     var
//         UserSetup: Record "User Setup";
//     begin
//         // Get the current user's record from the extended User Setup table
//         if UserSetup.Get(UserId) then
//             if UserSetup."Is Accountant" or UserSetup."Is Manager" then
//                 exit; // Access granted

//         Error('Access Denied: Only users marked as "Is Accountant" in User Setup can send orders for approval.');
//     end;

//     local procedure CheckManagerRole()
//     var
//         UserSetup: Record "User Setup";
//     begin
//         if UserSetup.Get(UserId) then
//             if UserSetup."Is Manager" then
//                 exit; // Access granted

//         Error('Access Denied: Only users marked as "Is Manager" in User Setup can Approve or Reject orders.');
//     end;

//     procedure SetSecurityFilter(var PayOrder: Record "Payment Order")
//     var
//         UserSetup: Record "User Setup";
//     begin
//         if not UserSetup.Get(UserId) then exit;

//         PayOrder.FilterGroup(2);

//         // Priority: Managers see everything
//         if UserSetup."Is Manager" then
//             PayOrder.Reset()
//         else if UserSetup."Is Cashier" then
//             PayOrder.SetFilter(Status, '%1|%2', PayOrder.Status::Approved, PayOrder.Status::Finalized)
//         else if UserSetup."Is Accountant" then
//             PayOrder.SetFilter(Status, '%1|%2|%3', PayOrder.Status::Processing, PayOrder.Status::Rejected, PayOrder.Status::Finalized);

//         PayOrder.FilterGroup(0);
//     end;

//     procedure PostVoucher(var IncomeExpJnl: Record "Income/Expense Journal")
//     var
//         GenJnlLine: Record "Gen. Journal Line";
//         GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
//         LineNo: Integer;
//     begin
//         // Clear any existing lines in the temporary posting batch
//         GenJnlLine.SetRange("Journal Template Name", 'GENERAL');
//         GenJnlLine.SetRange("Journal Batch Name", 'CASHIER');
//         GenJnlLine.DeleteAll();

//         // --- Line 1: The Account Side ---
//         LineNo := 10000;
//         GenJnlLine.Init();
//         GenJnlLine."Journal Template Name" := 'GENERAL';
//         GenJnlLine."Journal Batch Name" := 'CASHIER';
//         GenJnlLine."Line No." := LineNo;
//         GenJnlLine."Posting Date" := IncomeExpJnl."Posting Date";
//         GenJnlLine."Document No." := IncomeExpJnl."Document No.";
//         GenJnlLine.Validate("Account Type", IncomeExpJnl."Account Type");
//         GenJnlLine.Validate("Account No.", IncomeExpJnl."Account No.");

//         // Logic: Receipts are Debit (+), Payments are Credit (-)
//         if IncomeExpJnl."Journal Type" = IncomeExpJnl."Journal Type"::Receipt then
//             GenJnlLine.Validate(Amount, IncomeExpJnl.Amount)
//         else
//             GenJnlLine.Validate(Amount, -IncomeExpJnl.Amount);

//         GenJnlLine.Insert(true);

//         // --- Line 2: The Balancing (Bank/GL) Side ---
//         LineNo += 10000;
//         GenJnlLine.Init();
//         GenJnlLine."Journal Template Name" := 'GENERAL';
//         GenJnlLine."Journal Batch Name" := 'CASHIER';
//         GenJnlLine."Line No." := LineNo;
//         GenJnlLine."Posting Date" := IncomeExpJnl."Posting Date";
//         GenJnlLine."Document No." := IncomeExpJnl."Document No.";
//         GenJnlLine.Validate("Account Type", IncomeExpJnl."Bal. Account Type");
//         GenJnlLine.Validate("Account No.", IncomeExpJnl."Bal. Account No.");

//         // Logic: Reverse of Line 1
//         if IncomeExpJnl."Journal Type" = IncomeExpJnl."Journal Type"::Receipt then
//             GenJnlLine.Validate(Amount, -IncomeExpJnl.Amount)
//         else
//             GenJnlLine.Validate(Amount, IncomeExpJnl.Amount);

//         GenJnlLine.Insert(true);

//         // --- Execute Posting ---
//         if Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJnlLine) then begin
//             // Run Report (You'll need to define "Voucher Report")
//             // Report.Run(Report::"Voucher Report", true, false, IncomeExpJnl);

//             // Delete the record as per requirement
//             IncomeExpJnl.Delete();
//             Message('Voucher Posted and cleared.');
//         end;
//     end;
//     //     procedure CreateVoucherFromOrder(var PayOrder: Record "Payment Order")
//     // var
//     //     IncomeExpJnl: Record "Income/Expense Journal";
//     //     LineNo: Integer;
//     // begin
//     //     // 1. Get the next Line No.
//     //     IncomeExpJnl.Reset();
//     //     if IncomeExpJnl.FindLast() then
//     //         LineNo := IncomeExpJnl."Line No." + 10000
//     //     else
//     //         LineNo := 10000;

//     //     // 2. Map Account Side (Debit/Credit side based on Journal Type)
//     //     IncomeExpJnl.Init();
//     //     IncomeExpJnl."Line No." := LineNo;
//     //     IncomeExpJnl."Posting Date" := Today;
//     //     IncomeExpJnl."Document No." := PayOrder."Payment No.";

//     //     IncomeExpJnl.Validate("Account Type", PayOrder."Account Type");
//     //     IncomeExpJnl.Validate("Account No.", PayOrder."Account No.");
//     //     IncomeExpJnl.Validate("Currency Code", PayOrder."Currency Code");
//     //     IncomeExpJnl.Validate(Amount, PayOrder.Amount);

//     //     // 3. Map Balancing Side (Bank/Cash side)
//     //     IncomeExpJnl.Validate("Bal. Account Type", PayOrder."Bal. Account Type");
//     //     IncomeExpJnl.Validate("Bal. Account No.", PayOrder."Bal. Account No.");

//     //     // Transferring the specific Balance fields you requested
//     //     IncomeExpJnl."Bal. Currency Code" := PayOrder."Bal. Currency Code";
//     //     IncomeExpJnl."Bal. Amount" := PayOrder."Bal. Amount"; 

//     //     IncomeExpJnl."Journal Type" := PayOrder."Payment Type";

//     //     IncomeExpJnl.Insert(true);

//     //     // 4. Open the correct Page and close the Card
//     //     OpenVoucherPage(IncomeExpJnl);
//     // end;

//     // local procedure OpenVoucherPage(var IncomeExpJnl: Record "Income/Expense Journal")
//     // begin
//     //     Commit(); // Commit before opening page
//     //     if IncomeExpJnl."Journal Type" = IncomeExpJnl."Journal Type"::Receipt then
//     //         Page.Run(Page::"Receipt Voucher Card", IncomeExpJnl)
//     //     else
//     //         Page.Run(Page::"Payment Voucher Card", IncomeExpJnl);
//     // end;


// }



codeunit 50101 "Cashier Utility"
{
    // --- 1. Status & Role Logic ---
    procedure ChangeStatus(var PayOrder: Record "Payment Order"; NewStatus: Option Processing,"Waiting Approval",Approved,Rejected,Finalized)
    begin
        case NewStatus of
            PayOrder.Status::"Waiting Approval":
                CheckAccountantRole();
            PayOrder.Status::Approved, PayOrder.Status::Rejected:
                CheckManagerRole();
        end;
        PayOrder.Status := NewStatus;
        PayOrder."Last Date Modified " := Today;
        PayOrder.Modify(true);
    end;

    local procedure CheckAccountantRole()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Is Accountant" or UserSetup."Is Manager" then exit;
        Error('Access Denied: Only Accountants/Managers can send for approval.');
    end;

    local procedure CheckManagerRole()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            if UserSetup."Is Manager" then exit;
        Error('Access Denied: Only Managers can Approve/Reject.');
    end;

    // --- 2. Security Filtering ---
    procedure SetSecurityFilter(var PayOrder: Record "Payment Order")
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId) then exit;
        PayOrder.FilterGroup(2);
        if UserSetup."Is Manager" then
            PayOrder.Reset()
        else if UserSetup."Is Cashier" then
            PayOrder.SetFilter(Status, '%1|%2', PayOrder.Status::Approved, PayOrder.Status::Finalized)
        else if UserSetup."Is Accountant" then
            PayOrder.SetFilter(Status, '%1|%2|%3', PayOrder.Status::Processing, PayOrder.Status::Rejected, PayOrder.Status::Finalized);
        PayOrder.FilterGroup(0);
    end;

    // --- 3. Create Voucher (Order -> Journal) ---
    procedure CreateVoucherFromOrder(var PayOrder: Record "Payment Order")
    var
        IncomeExpJnl: Record "Income/Expense Journal";
        UserSetup: Record "User Setup";
        NextLineNo: Integer;
    begin
        if UserSetup.Get(UserId) then
            if not UserSetup."Is Cashier" then Error('Only Cashiers can create vouchers.');

        IncomeExpJnl.Reset();
        if IncomeExpJnl.FindLast() then NextLineNo := IncomeExpJnl."Line No." + 1 else NextLineNo := 1;

        IncomeExpJnl.Init();
        IncomeExpJnl."Line No." := NextLineNo;
        IncomeExpJnl."Posting Date" := PayOrder."Posting Date";
        IncomeExpJnl."Document No." := PayOrder."Payment No.";
        IncomeExpJnl."Account Type" := PayOrder."Account Type";
        IncomeExpJnl."Account No." := PayOrder."Account No.";
        IncomeExpJnl.Amount := PayOrder.Amount;
        IncomeExpJnl."Amount(LCY)" := PayOrder."Amount(LCY)";
        IncomeExpJnl."Currency Code" := PayOrder."Currency Code";
        IncomeExpJnl."Bal. Account Type" := PayOrder."Bal. Account Type";
        IncomeExpJnl."Bal. Account No." := PayOrder."Bal. Account No.";
        IncomeExpJnl."Bal. Currency Code" := PayOrder."Bal. Currency Code";
        IncomeExpJnl."Bal. Amount" := PayOrder."Bal. Amount";
        IncomeExpJnl."Journal Type" := PayOrder."Payment Type";
        IncomeExpJnl.Insert(true);

        PayOrder.Status := PayOrder.Status::Finalized;
        PayOrder.Modify();

        Commit();
        if IncomeExpJnl."Journal Type" = IncomeExpJnl."Journal Type"::Receipt then
            Page.Run(Page::"Receipt Voucher Card", IncomeExpJnl)
        else
            Page.Run(Page::"Payment Voucher Card", IncomeExpJnl);


    end;

    // --- 4. Post Voucher (Journal -> General Ledger) ---
    // THIS IS THE PROCEDURE YOUR PAGES WERE MISSING
    procedure PostVoucher(var IncomeExpJnl: Record "Income/Expense Journal")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        DocNo: Code[20];
        LineNo: Integer;
    begin
        // 1. Setup Header Info
        DocNo := IncomeExpJnl."Document No.";
        LineNo := 10000;

        // 2. Clear the Batch 'CASHIER' to ensure a clean posting
        GenJnlLine.SetRange("Journal Template Name", 'GENERAL');
        GenJnlLine.SetRange("Journal Batch Name", 'CASHIER');
        GenJnlLine.DeleteAll();

        // --- SIDE 1: Account Side ---
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := 'GENERAL';
        GenJnlLine."Journal Batch Name" := 'CASHIER';
        GenJnlLine."Line No." := LineNo;

        GenJnlLine.Validate("Posting Date", IncomeExpJnl."Posting Date");
        GenJnlLine."Document No." := DocNo;

        // CRITICAL: Validate Type THEN No. to avoid the G/L Error
        GenJnlLine.Validate("Account Type", IncomeExpJnl."Account Type");
        GenJnlLine.Validate("Account No.", IncomeExpJnl."Account No.");

        // Receipt = Positive, Payment = Negative
        if IncomeExpJnl."Journal Type" = IncomeExpJnl."Journal Type"::Receipt then
            GenJnlLine.Validate(Amount, IncomeExpJnl.Amount)
        else
            GenJnlLine.Validate(Amount, -IncomeExpJnl.Amount);

        GenJnlLine.Insert(true);

        // --- SIDE 2: Balancing Side ---
        LineNo += 10000;
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := 'GENERAL';
        GenJnlLine."Journal Batch Name" := 'CASHIER';
        GenJnlLine."Line No." := LineNo;

        GenJnlLine.Validate("Posting Date", IncomeExpJnl."Posting Date");
        GenJnlLine."Document No." := DocNo;

        // CRITICAL: Validate Type THEN No.
        GenJnlLine.Validate("Account Type", IncomeExpJnl."Bal. Account Type");
        GenJnlLine.Validate("Account No.", IncomeExpJnl."Bal. Account No.");

        // Reverse the amount of Side 1
        if IncomeExpJnl."Journal Type" = IncomeExpJnl."Journal Type"::Receipt then
            GenJnlLine.Validate(Amount, -IncomeExpJnl.Amount)
        else
            GenJnlLine.Validate(Amount, IncomeExpJnl.Amount);

        GenJnlLine.Insert(true);

        // 3. Post using Codeunit 11 (Standard Post)
        if Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJnlLine) then begin
            // 4. Delete from your table after successful post
            IncomeExpJnl.Delete();
            Message('Voucher %1 posted and cleared.', DocNo);
        end;
    end;
}