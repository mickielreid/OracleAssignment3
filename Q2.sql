CREATE OR REPLACE PROCEDURE DDPAY_SP(
    paymentID IN NUMBER,
    paymentResponse OUT boolean)
    IS
    paymentStatus  NUMBER;
    monthlyPayment NUMBER;
BEGIN
    SELECT IDSTATUS, PAYMONTHS
    INTO paymentStatus, monthlyPayment
    FROM DD_PLEDGE
    WHERE IDPLEDGE = paymentID;

    if paymentStatus = 20 And monthlyPayment = 0 THEN
        paymentResponse := FALSE ;
    ELSIF paymentStatus = 10 AND monthlyPayment > 0 THEN
        paymentResponse := TRUE;
    END IF;
END DDPAY_SP;

DECLARE
    paymentID       DD_PLEDGE.IDPLEDGE%type := 106;
    paymentResponse Boolean;
BEGIN
    DDPAY_SP(paymentID, paymentResponse);

    dbms_output.put_line(
            case
                when paymentResponse then 'TRUE'
                else 'FALSE'
                end);
END;