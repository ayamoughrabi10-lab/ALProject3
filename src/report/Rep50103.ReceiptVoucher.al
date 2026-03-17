// namespace ALProject.ALProject;

// report 50103 "Receipt Voucher"
// {
//     Caption = 'Receipt Voucher';
//     dataset
//     {
//         dataitem(IncomeExpenseJournal; "Income/Expense Journal")
//         {
//             column(PostingDate; "Posting Date")
//             {
//             }
//             column(DocumentNo; "Document No.")
//             {
//             }
//             column(AccountType; "Account Type")
//             {
//             }
//             column(AccountNo; "Account No.")
//             {
//             }
//             column(CurrencyCode; "Currency Code")
//             {
//             }
//             column(Amount; Amount)
//             {
//             }
//             column(AmountLCY; "Amount(LCY)")
//             {
//             }
//             column(BalAccountType; "Bal. Account Type")
//             {
//             }
//             column(BalAccountNo; "Bal. Account No.")
//             {
//             }
//             column(BalCurrencyCode; "Bal. Currency Code")
//             {
//             }
//             column(BalAmount; "Bal. Amount")
//             {
//             }
//             column(JournalType; "Journal Type")
//             {
//             }
//         }
//     }
//     requestpage
//     {
//         layout
//         {
//             area(Content)
//             {
//                 group(GroupName)
//                 {
//                 }
//             }
//         }
//         actions
//         {
//             area(Processing)
//             {
//             }
//         }
//     }
// }

namespace ALProject.ALProject;

report 50103 "Receipt Voucher"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Receipt Voucher';
    DefaultLayout = RDLC;
    RDLCLayout = './ReceiptVoucher.rdl'; // Ensure you create this layout file

    dataset
    {
        dataitem(IncomeExpenseJournal; "Income/Expense Journal")
        {
            // Allows the user to filter by specific document number on the request page
            RequestFilterFields = "Document No.";

            column(PostingDate; "Posting Date") { }
            column(DocumentNo; "Document No.") { }
            column(AccountType; "Account Type") { }
            column(AccountNo; "Account No.") { }
            column(CurrencyCode; "Currency Code") { }
            column(Amount; Amount) { }
            column(AmountLCY; "Amount(LCY)") { }
            column(BalAccountType; "Bal. Account Type") { }
            column(BalAccountNo; "Bal. Account No.") { }
            column(BalCurrencyCode; "Bal. Currency Code") { }
            column(BalAmount; "Bal. Amount") { }
            column(JournalType; "Journal Type") { }

            // Logic to ensure only Receipts are printed
            trigger OnPreDataItem()
            begin
                IncomeExpenseJournal.SetRange("Journal Type", IncomeExpenseJournal."Journal Type"::Receipt);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                // Keeping this empty as standard for simple reports
            }
        }
    }
}