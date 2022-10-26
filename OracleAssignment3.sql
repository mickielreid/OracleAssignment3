/*QUESRION 1:
RESULTS:
CODE:
Q1. Returning a Record
Create a procedure named DDPROJ_SP that retrieves project information for a specific project
based on a project ID. The procedure should have two parameters: one to accept a project ID
value and another to return all data for the specified project. Use a record variable to have the
procedure return all database column values for the selected project. Test the procedure with an
anonymous block.
*/
create or replace procedure DDPROJ_SP  
    (
        Pro_ID IN DD_PROJECT.IDPROJ%type,
       d_project out DD_PROJECT%ROWTYPE
    )
    IS
       
      TYPE PRO IS RECORD(
        IDPROJ DD_PROJECT.IDPROJ%TYPE,
        PROJNAME DD_PROJECT.PROJNAME%TYPE,
        PROJSTARTDATE  DD_PROJECT.PROJSTARTDATE%TYPE,
        PROJENDDATE  DD_PROJECT.PROJENDDATE%TYPE,
        PROJFUNDGOAL  DD_PROJECT.PROJFUNDGOAL%TYPE,
        PROJCOORD  DD_PROJECT.PROJCOORD%TYPE);
        D_PRO PRO;
BEGIN 
   
    SELECT *
    INTO d_project
    FROM DD_PROJECT 
    WHERE IDPROJ = Pro_ID;
        
END DDPROJ_SP ;     

declare 
   -- d_project DD_PROJECT%ROWTYPE;
     TYPE PRO IS RECORD(
        IDPROJ DD_PROJECT.IDPROJ%TYPE,
        PROJNAME DD_PROJECT.PROJNAME%TYPE,
        PROJSTARTDATE  DD_PROJECT.PROJSTARTDATE%TYPE,
        PROJENDDATE  DD_PROJECT.PROJENDDATE%TYPE,
        PROJFUNDGOAL  DD_PROJECT.PROJFUNDGOAL%TYPE,
        PROJCOORD  DD_PROJECT.PROJCOORD%TYPE);
        d_project PRO;
begin

DDPROJ_SP(501 ,  d_project );
DBMS_OUTPUT.PUT_LINE(d_project.IDPROJ);
DBMS_OUTPUT.PUT_LINE(d_project.PROJNAME);
DBMS_OUTPUT.PUT_LINE(d_project.PROJSTARTDATE);
DBMS_OUTPUT.PUT_LINE(d_project.PROJENDDATE);
DBMS_OUTPUT.PUT_LINE(d_project.PROJFUNDGOAL);
DBMS_OUTPUT.PUT_LINE(d_project.PROJCOORD);
end;
/*
QUESTION 2 
RESULTS:
Q2. Creating a Procedure
Create a procedure named DD PAY_ SP that identifies whether a donor currently has an active
pledge with monthly payments. A donor ID is the input to the procedure. Using the donor ID,
the procedure needs to determine whether the donor has any currently active pledges based on
the status field and is on a monthly payment plan. If so, the procedure is to return the Boolean
value TRUE. Otherwise, the value FALSE should be returned. Test the procedure with an
anonymous block.


CODE :*/
create or replace procedure DDPAY_SP 
    (
        P_ID IN NUMBER,
        P_RESP OUT boolean
    )
    IS
       STATUS NUMBER;
       MON_PAY NUMBER;
BEGIN 

    SELECT IDSTATUS, PAYMONTHS
    INTO STATUS, MON_PAY
    FROM DD_PLEDGE 
    WHERE IDPLEDGE = P_ID;

        
        if STATUS != 10 And MON_PAY > 1 THEN
           P_RESP := FALSE ;
       ELSIF STATUS = 10 AND MON_PAY > 0 THEN
           P_RESP := TRUE;
        END IF; 
        
END DDPAY_SP;     

declare 
    P_ID DD_PLEDGE.IDPLEDGE%type := 105;
    P_RESP Boolean;
begin
DDPAY_SP(P_ID, P_RESP) ;

dbms_output.put_line(
   case
      when P_RESP then 'TRUE'
      else 'FALSE'
   end
);
end;





/*


QUESTION 3:
RESULTS:
Q3. Creating a Procedure
Create a procedure named DDCKPAY_SP that confirms whether a monthly pledge payment is
the correct amount. The procedure needs to accept two values as input: a payment amount and a
pledge ID. Based on these inputs, the procedure should confirm that the payment is·the correct
monthly Increment amount, based on pledge data in the database. If It isn't, a custom Oracle error
using error number 20050 and the message "Incorrect payment amount - planned payment =??”
should be raised. The “??” should be replaced by the correct payment amount.
The database query in the procedure should be formulated so that no rows are returned if the
pledge isn't on a monthly payment plan or the pledge isn't found. If the query returns no rows,
the procedure should display the message "No payment Information."
Test the procedure with the pledge ID 104 and the payment amount $25. Then test with the same
pledge ID but the payment amount $20. Finally, test the procedure with a pledge ID for a pledge
that doesn't have monthly payments associated with it

TESTING WITH ID = 104 PAYMENT AMOUNT = $25
 

TEST WITH ID = 104 AND PAYMENT = $20
 
TESTING WITH ID = 100 AND PAYMENT = $23
 

CODE:*/

CREATE OR REPLACE PROCEDURE DDCKPAY_SP(DD_ID IN NUMBER,
                                       DD_AMT IN NUMBER,
                                       OUTPUT OUT VARCHAR2)
    IS

    LV_ROW      DD_PLEDGE%ROWTYPE;
    FINAL_PRICE NUMBER;
    INCORRECT EXCEPTION;
BEGIN
    SELECT *
    INTO LV_ROW
    FROM DD_PLEDGE
    WHERE IDPLEDGE = DD_ID;


    IF LV_ROW.PAYMONTHS = 0 THEN
        RAISE INCORRECT;
    END IF;

    FINAL_PRICE := LV_ROW.PLEDGEAMT / LV_ROW.PAYMONTHS;

    IF DD_AMT = FINAL_PRICE THEN
        OUTPUT := 'THE PAYMENT IS CORRECT';
    ELSIF DD_AMT != FINAL_PRICE THEN
        RAISE_APPLICATION_ERROR(-20050, 'Incorrect payment amount - planned payment = ' || FINAL_PRICE);
    END IF;

EXCEPTION
    WHEN INCORRECT THEN
        DBMS_OUTPUT.PUT_LINE('No payment information');
END DDCKPAY_SP;

DECLARE
    OUTPUT VARCHAR2(242);
BEGIN
    DDCKPAY_SP(104, 20, OUTPUT);
    DBMS_OUTPUT.PUT_LINE(OUTPUT);
END;

/*

QUESTION 4:
RESULT
 Q4. Creating a Procedure
Create a procedure named DDCXBAL_SP that verifies pledge payment information. The
procedure should accept a pledge ID as input and return three values for the specified pledge:
pledge amount, payment total to date, and remaining balance. Test the procedure with an
anonymous block.
To submit: Copy the code of each question associated with a screen shot of the related output into
a MS-word file and submit into E-Centennial by due date.
Good Luck
CODE:*/
CREATE OR REPLACE PROCEDURE DDCKBAL_SP
  (p_pledgeid IN dd_pledge.idpledge%TYPE,
  p_pledgeamt OUT dd_pledge.pledgeamt%TYPE,
  p_TOTAL OUT dd_payment.payamt%TYPE,
  p_REMAIN OUT dd_payment.payamt%TYPE ) 
IS
  Z_MPMT dd_pledge.pledgeamt%TYPE;
  Z_PID dd_pledge.idpledge%TYPE;
  Z_PMT dd_pledge.pledgeamt%TYPE;
 Z_MON DD_PLEDGE.IDSTATUS%TYPE;
  TOTALP NUMBER;
  
BEGIN

  SELECT MT.PAYAMT , PL.IDPLEDGE , PL.PLEDGEAMT, PL.IDSTATUS , COUNT(MT.PAYAMT)
  INTO  Z_MPMT , Z_PID , Z_PMT ,  Z_MON, TOTALP
  FROM DD_PLEDGE PL JOIN DD_PAYMENT MT 
  ON PL.IDPLEDGE = MT.IDPLEDGE
  WHERE MT.IDPLEDGE = p_pledgeid
  GROUP BY MT.PAYAMT , PL.IDPLEDGE , PL.PLEDGEAMT , PL.IDSTATUS  ;
  
  IF Z_MON = 10 THEN
     p_pledgeamt :=  Z_MPMT;
   /* p_pledgeamt :=  1;*/
     p_TOTAL  := TOTALP * Z_MPMT;
     p_REMAIN :=  Z_PMT - p_TOTAL;
  ELSE
   p_pledgeamt :=  Z_MON;
      DBMS_OUTPUT.PUT_LINE('NODATA FOUND FOR YOU');
  END IF;
  
  
END DDCKBAL_SP;

DECLARE 
  AMT NUMBER(30);
  TATAL NUMBER(30);
  REMAIN NUMBER(30);
BEGIN
  DDCKBAL_SP('110' , AMT ,TATAL , REMAIN);
  DBMS_OUTPUT.PUT_LINE('PAYMENT PER MONTH IS ' || AMT);
  DBMS_OUTPUT.PUT_LINE('TOTAL PAYMENT TO DATE IS IS ' || TATAL);
  DBMS_OUTPUT.PUT_LINE('REMAINING BAL IS ' || REMAIN);
END;


