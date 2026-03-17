pageextension 50101 "Purchase Order LBP Ext" extends "Purchase Order"
{
    layout
    {
        addlast(Content)
        {
            field("Subtotal Incl. VAT (LBP)"; SubtotalLBP)
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Subtotal including VAT converted to LBP using BC exchange rates.';
            }
        }
    }

    var
        SubtotalLBP: Decimal;

    trigger OnAfterGetRecord()
    begin
        CalculateSubtotalLBP();
    end;

    local procedure CalculateSubtotalLBP()
    var
        PurchOrder: Record "Purchase Header";
        CurrExchRate: Record "Currency Exchange Rate";
        ExchangeRate: Decimal;
        TotalUSD: Decimal;
    begin
        SubtotalLBP := 0;
        TotalUSD := 0;
        ExchangeRate := 0;

        // Get LBP exchange rate (latest valid rate)
        CurrExchRate.Reset();
        CurrExchRate.SetRange("Currency Code", 'LBP');
        //  CurrExchRate.SetFilter("Starting Date", '..%1', WorkDate);

        if CurrExchRate.FindFirst() then
            ExchangeRate := CurrExchRate."Exchange Rate Amount";

        if ExchangeRate = 0 then
            exit;

        PurchOrder.Reset();
        PurchOrder.SetRange("No.", rec."No.");
        if PurchOrder.FindFirst() then begin
            PurchOrder.CalcFields(Amount);
            TotalUSD := PurchOrder.Amount;
            SubtotalLBP := TotalUSD * ExchangeRate;

        end;



        // Convert to LBP
    end;
}
