CREATE OR REPLACE PROCEDURE DDPROJ_SP(
    projectID IN DD_PROJECT.IDPROJ%type,
    projectResponse out DD_PROJECT%ROWTYPE)
    IS
    TYPE PRO IS RECORD
                (
                    IDPROJ        DD_PROJECT.IDPROJ%TYPE,
                    PROJNAME      DD_PROJECT.PROJNAME%TYPE,
                    PROJSTARTDATE DD_PROJECT.PROJSTARTDATE%TYPE,
                    PROJENDDATE   DD_PROJECT.PROJENDDATE%TYPE,
                    PROJFUNDGOAL  DD_PROJECT.PROJFUNDGOAL%TYPE,
                    PROJCOORD     DD_PROJECT.PROJCOORD%TYPE
                );
BEGIN
    SELECT *
    INTO projectResponse
    FROM DD_PROJECT
    WHERE IDPROJ = projectID;
END DDPROJ_SP ;

DECLARE
    projectIDInput NUMBER := 500;
    TYPE recordResponse IS RECORD
                           (
                               IDPROJ        DD_PROJECT.IDPROJ%TYPE,
                               PROJNAME      DD_PROJECT.PROJNAME%TYPE,
                               PROJSTARTDATE DD_PROJECT.PROJSTARTDATE%TYPE,
                               PROJENDDATE   DD_PROJECT.PROJENDDATE%TYPE,
                               PROJFUNDGOAL  DD_PROJECT.PROJFUNDGOAL%TYPE,
                               PROJCOORD     DD_PROJECT.PROJCOORD%TYPE
                           );
    d_project recordResponse;
BEGIN
    DDPROJ_SP(projectIDInput, d_project);

    DBMS_OUTPUT.PUT_LINE(d_project.IDPROJ);
    DBMS_OUTPUT.PUT_LINE(d_project.PROJNAME);
    DBMS_OUTPUT.PUT_LINE(d_project.PROJSTARTDATE);
    DBMS_OUTPUT.PUT_LINE(d_project.PROJENDDATE);
    DBMS_OUTPUT.PUT_LINE(d_project.PROJFUNDGOAL);
    DBMS_OUTPUT.PUT_LINE(d_project.PROJCOORD);
END;