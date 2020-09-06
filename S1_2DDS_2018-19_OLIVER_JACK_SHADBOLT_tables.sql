
REM S1 2DDS 2018-19 Tables
REM **********************

/*  GROUP NO.:  6
    MEMBERS:    Oliver Prior
                Nathan Booker
                Oliver Shadbolt

*/

CREATE TABLE emp
(
    empno
        NUMBER(4)
        CONSTRAINT pk_empno PRIMARY KEY
        CONSTRAINT pos_empno CHECK (empno > 0)
    ,
    empname
        VARCHAR2(32)
        CONSTRAINT nn_empname NOT NULL
        CONSTRAINT upper_empname CHECK (empname = UPPER(empname))
    ,
    houseno
        NUMBER(4)
        CONSTRAINT nn_houseno NOT NULL
        CONSTRAINT pos_houseno CHECK (houseno > 0)
    ,
    houserd
        VARCHAR2(32)
        CONSTRAINT nn_houserd NOT NULL
        CONSTRAINT upper_houserd CHECK (houserd = UPPER(houserd))
    ,
    postcode
        VARCHAR2(8)
        CONSTRAINT nn_postcode NOT NULL
        CONSTRAINT chk_postcode CHECK -- UK POSTCODE CONSTRAINT CHECK
            (
                (SUBSTR(postcode, 1, 1) BETWEEN 'A' AND 'Z')
                AND
                (SUBSTR(postcode, 1, 1) NOT IN ('Q', 'V', 'X'))
                AND
                (
                    (
                        (LENGTH(postcode) = 6)
                        AND
                        (SUBSTR(postcode, 2, 1) BETWEEN '0' AND '9')
                    )
                    OR
                    (
                        (LENGTH(postcode) = 7)
                        AND
                        (
                            (
                                (SUBSTR(postcode, 2, 1) BETWEEN 'A' AND 'Z')
                                AND
                                (
                                    (SUBSTR(postcode, 3, 1) BETWEEN '0' AND '9')
                                    OR
                                    (SUBSTR(postcode, 3, 1) IN ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'S', 'T', 'U', 'W'))
                                )
                            )
                            OR
                            (
                                (SUBSTR(postcode, 2, 1) BETWEEN '0' AND '9')
                                AND
                                (
                                    (SUBSTR(postcode, 3, 1) BETWEEN 'A' AND 'Z')
                                    OR
                                    (SUBSTR(postcode, 3, 1) BETWEEN '0' AND '9')
                                )
                            )
                        )
                    )
                    OR
                    (
                        (LENGTH(postcode) = 8)
                        AND
                        (SUBSTR(postcode, 2, 1) BETWEEN 'A' AND 'Z')
                        AND
                        (SUBSTR(postcode, 3, 1) BETWEEN '0' AND '9')
                        AND
                        (
                            (SUBSTR(postcode, 4, 1) BETWEEN 'A' AND 'Z')
                            OR
                            (SUBSTR(postcode, 4, 1) BETWEEN '0' AND '9')
                        )
                    )
                )
                AND
                (SUBSTR(postcode, 2, 1) NOT IN ('I', 'J', 'Z'))
                AND
                (SUBSTR(postcode, -4, 1) = ' ')
                AND
                (SUBSTR(postcode, -3, 1) BETWEEN '0' AND '9')
                AND
                (SUBSTR(postcode, -2, 1) BETWEEN 'A' AND 'Z')
                AND
                (SUBSTR(postcode, -2, 1) NOT IN ('C', 'I', 'K', 'M', 'O', 'V'))
                AND
                (SUBSTR(postcode, -1, 1) BETWEEN 'A' AND 'Z')
                AND
                (SUBSTR(postcode, -1, 1) NOT IN ('C', 'I', 'K', 'M', 'O', 'V'))
            )
    ,
    dob
        DATE
        CONSTRAINT nn_dob NOT NULL
        CONSTRAINT chk_dob CHECK (dob > '01-JAN-1900')
    ,
    status
        CHAR(1)
        DEFAULT 'C'
        CONSTRAINT nn_status NOT NULL
        CONSTRAINT chk_status CHECK (status in ('P', 'N', 'C'))
    ,
    nino
        CHAR(9)
        CONSTRAINT nn_nino NOT NULL
        CONSTRAINT unq_nino UNIQUE
        CONSTRAINT chk_nino CHECK -- UK NATIONAL INSURANCE NUMBER CONSTRAINT CHECK
            (
                (SUBSTR(nino, 1, 1) BETWEEN 'A' AND 'Z')
                AND
                (SUBSTR(nino, 1, 1) NOT IN ('D', 'F', 'I', 'Q', 'U', 'V'))
                AND
                (SUBSTR(nino, 2, 1) BETWEEN 'A' AND 'Z')
                AND
                (SUBSTR(nino, 2, 1) NOT IN ('D', 'F', 'I', 'Q', 'U', 'V', 'O'))
                AND
                (SUBSTR(nino, 1, 2) NOT IN ('BG', 'GB', 'NK', 'KN', 'TN', 'NT', 'ZZ'))
                AND
                (SUBSTR(nino, 3, 1) BETWEEN '0' AND '9')
                AND
                (SUBSTR(nino, 4, 1) BETWEEN '0' AND '9')
                AND
                (SUBSTR(nino, 5, 1) BETWEEN '0' AND '9')
                AND
                (SUBSTR(nino, 6, 1) BETWEEN '0' AND '9')
                AND
                (SUBSTR(nino, 7, 1) BETWEEN '0' AND '9')
                AND
                (SUBSTR(nino, 8, 1) BETWEEN '0' AND '9')
                AND
                (
                    (SUBSTR(nino, 9, 1) BETWEEN 'A' AND 'D')
                    OR
                    (SUBSTR(nino, 9, 1) = ' ')
                )
            )
    ,
    sal
        NUMBER(6, 2)
        DEFAULT NULL
        CONSTRAINT pos_sal CHECK (sal > 0)
    ,
    offno
        NUMBER(4)
        DEFAULT NULL
        CONSTRAINT pos_offno CHECK (offno > 0)
    ,
    pen
        NUMBER(6, 2)
        DEFAULT NULL
        CONSTRAINT pos_pen CHECK (pen > 0)
    ,
    leavedate
        DATE
        DEFAULT NULL
        CONSTRAINT chk_leavedate CHECK (leavedate > '01-JAN-1900')
    ,
    CONSTRAINT chk_emp CHECK -- ENSURE VALUES CORRECT BASED ON STATUS
        (
            (
                (
                    (status = 'C')
                    AND
                    (sal IS NOT NULL)
                    AND
                    (offno IS NOT NULL)
                    AND
                    (leavedate IS NULL)
                )
                OR
                (
                    (status != 'C')
                    AND
                    (sal IS NULL)
                    AND
                    (offno IS NULL)
                    AND
                    (leavedate IS NOT NULL)
                )
            )
            AND
            (
                (
                    (status = 'P')
                    AND
                    (pen IS NOT NULL)
                )
                OR
                (
                    (status != 'P')
                    AND
                    (pen IS NULL)
                )
            )
        )
)
/

CREATE TABLE job
(
    empno
        NUMBER(4)
        CONSTRAINT fk_empno_job REFERENCES emp(empno) ON DELETE CASCADE
    ,
    jobcode
        CHAR(2)
        CONSTRAINT chk_jobcode CHECK
            (
                (SUBSTR(jobcode, 1, 1) BETWEEN 'A' AND 'X')
                AND
                (SUBSTR(jobcode, 1, 1) NOT IN ('I', 'O', 'Q', 'V'))
                AND
                (SUBSTR(jobcode, 2, 1) BETWEEN '0' AND '9')
            )
    ,
    appdate
        DATE
        CONSTRAINT nn_appdate NOT NULL
        CONSTRAINT chk_appdate CHECK (appdate > '01-JAN-1900')
    ,
    CONSTRAINT pk_job PRIMARY KEY (empno, jobcode)
)
/

CREATE TABLE proj
(
    projno
        NUMBER(4)
        CONSTRAINT pk_projno PRIMARY KEY
        CONSTRAINT pos_projno CHECK (projno > 0)
    ,
    projcode
        CHAR(6)
        CONSTRAINT nn_projcode NOT NULL
        CONSTRAINT chk_projcode CHECK
            (
                (SUBSTR(projcode, 1, 3) = 'GBR')
                AND
                (SUBSTR(projcode, 4, 1) BETWEEN '0' AND '9')
                AND
                (SUBSTR(projcode, 5, 1) BETWEEN '0' AND '9')
                AND
                (SUBSTR(projcode, 6, 1) BETWEEN '0' AND '9')
            )
    ,
    projname
        VARCHAR2(32)
        CONSTRAINT nn_projname NOT NULL
        CONSTRAINT upper_projname CHECK (projname = UPPER(projname))
    ,
    targdate
        DATE
        CONSTRAINT nn_targdate NOT NULL
        CONSTRAINT chk_targdate CHECK (targdate > '01-JAN-1900')
    ,
    budghrs
        NUMBER(6, 2)
        DEFAULT 0
        CONSTRAINT nn_budghrs NOT NULL
        CONSTRAINT pos_budghrs CHECK (budghrs >= 0)
    ,
    compdate
        DATE
        DEFAULT NULL
        CONSTRAINT chk_compdate CHECK (compdate > '01-JAN-1900')
)
/

CREATE TABLE subproj
(
    projno
        NUMBER(4)
        CONSTRAINT fk_projno REFERENCES proj(projno) ON DELETE CASCADE
    ,
    subprojno
        NUMBER(2)
    ,
    subprojname
        VARCHAR2(32)
        CONSTRAINT nn_subprojname NOT NULL
        CONSTRAINT upper_subprojname CHECK (subprojname = UPPER(subprojname))
    ,
    CONSTRAINT pk_subproj PRIMARY KEY (projno, subprojno)
)
/

CREATE TABLE ass
(
    projno
        NUMBER(4)
    ,
    subprojno
        NUMBER(2)
    ,
    empno
        NUMBER(4)
        CONSTRAINT fk_empno_ass REFERENCES emp(empno) ON DELETE CASCADE
    ,
    descr
        VARCHAR2(512)
        CONSTRAINT nn_descr NOT NULL
        CONSTRAINT upper_descr CHECK (descr = UPPER(descr))
    ,
    tothrs
        NUMBER(6, 2)
        DEFAULT 0
        CONSTRAINT nn_tothrs NOT NULL
        CONSTRAINT pos_tothrs CHECK (tothrs >= 0)
    ,
    sdate
        DATE
        DEFAULT NULL
        CONSTRAINT chk_sdate CHECK (sdate > '01-JAN-1900')
    ,
    fdate
        DATE
        DEFAULT NULL
        CONSTRAINT chk_fdate CHECK (fdate > '01-JAN-1900')
    ,
    CONSTRAINT fk_ass FOREIGN KEY (projno, subprojno) REFERENCES subproj(projno, subprojno) ON DELETE CASCADE
    ,
    CONSTRAINT pk_ass PRIMARY KEY (projno, subprojno, empno)
    ,
    CONSTRAINT chk_dates CHECK -- ENSURE SDATE EXISTS IF FDATE EXISTS
        (
            (sdate <= fdate)
            AND
            (
                (
                    (fdate IS NOT NULL)
                    AND
                    (sdate IS NOT NULL)
                )
                OR
                (fdate IS NULL)
            )
        )
)
/
