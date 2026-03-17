// namespace ALProject.ALProject;

// report 50102 "Payment Voucher"
// {
//     Caption = 'Payment Voucher';
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

report 50102 "Payment Voucher"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Payment Voucher';
    DefaultLayout = RDLC;
    // This tells the system where to save the visual design file
    RDLCLayout = './PaymentVoucher.rdl';

    dataset
    {
        dataitem(IncomeExpenseJournal; "Income/Expense Journal")
        {
            // IMPORTANT: Filter so it ONLY prints Payments
            // DataItemTableFilter = "Journal Type" = const(Payment);
            RequestFilterFields = "Document No.";
            column(PostingDate; "Posting Date") { }
            column(DocumentNo; "Document No.") { }
            column(AccountType; "Account Type") { }
            column(AccountNo; "Account No.") { }
            column(CurrencyCode; "Currency Code") { }
            column(Amount; Amount) { }
            // Note: Ensure your field name in the table is exactly "Amount (LCY)" 
            // If you used "Amount(LCY)" in the table, keep it as is below.
            column(AmountLCY; "Amount(LCY)") { }
            column(BalAccountType; "Bal. Account Type") { }
            column(BalAccountNo; "Bal. Account No.") { }
            column(BalCurrencyCode; "Bal. Currency Code") { }
            column(BalAmount; "Bal. Amount") { }
            column(JournalType; "Journal Type") { }


            // Pro-tip: Add Company Name so the voucher looks official
            column(CompanyName; COMPANYPROPERTY.DisplayName()) { }
            trigger OnPreDataItem()
            begin
                // This is the "Context" fix. 
                // It hard-codes this report to ONLY show Payments.
                IncomeExpenseJournal.SetRange("Journal Type", IncomeExpenseJournal."Journal Type"::Payment);
            end;
        }
    }

    // You can leave the RequestPage as is or remove the empty group
    requestpage
    {
        layout
        {
            area(Content)
            {
            }
        }
    }
}