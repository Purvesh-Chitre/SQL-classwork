USE H_accounting;

/*
For understanding and exploring data we used the * (tilde) and join the various
tables after finding what each table has
*/

SELECT     *
FROM       journal_entry_line_item AS jeli
INNER JOIN journal_entry           AS je
        ON jeli.company_id = je.company_id
INNER JOIN `account`               AS a
        ON a.company_id = jeli.company_id
INNER JOIN statement_section       AS ss
        ON a.company_id = ss.company_id
ORDER BY   a.account_id ASC
        ;

/*-- Here we run the basic query by filtering the coulumns we 
need for understanding the data more
-- Basic 
*/

SELECT     jeli.account_id            AS 'account_id', 
           ss.statement_section_code  AS 'statement_section_code',
           a.account                  AS 'account',
           ROUND(jeli.credit, 2)      AS 'credit',
		   ROUND(jeli.debit, 2)       AS 'debit',
           je.entry_date              AS 'entry_date',
           a.last_modified            AS 'last_modified'
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_type               AS jt
        ON jt.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jt.company_id
     WHERE is_balance_sheet_section = 1
       AND jt.company_id NOT LIKE '-1'
	   AND YEAR(entry_date) = 2015
       AND (credit != 0
        OR debit != 0)
GROUP BY   account_id, entry_date, credit, debit, statement_section_code
ORDER BY   entry_date ASC
;


--



/*
Now we try to find the assets which are a part of the balance sheet
*/

-- Assets

SELECT     YEAR(entry_date)           AS 'year',
           jeli.account_id            AS 'account_id', 
           ss.statement_section_code  AS 'statement_section_code',
           je.journal_entry_code           AS 'journal_entry_code',
           ROUND(jeli.credit, 2)      AS 'credit',
           ROUND(jeli.debit, 2)       AS 'debit'
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_type               AS jt
        ON jt.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jt.company_id
     WHERE is_balance_sheet_section = 1
       AND jt.company_id NOT LIKE '-1'
       AND ss.statement_section_id IN (61, 62, 63)
	   AND YEAR(entry_date) = 2015
       AND (credit != 0
        OR debit != 0)
GROUP BY   journal_entry_code, account_id, credit, debit, statement_section_code, year 
ORDER BY   account_id ASC
;

/*
Now we try to find the liabilities which are a part of the balance sheet
*/

--
-- Liabilities

SELECT     YEAR(entry_date)           AS 'year',
           jeli.account_id            AS 'account_id', 
           ss.statement_section_code  AS 'statement_section_code',
           je.journal_entry_code      AS 'journal_entry_code',
           ROUND(jeli.credit, 2)      AS 'credit',
           ROUND(jeli.debit, 2)       AS 'debit'
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_type               AS jt
        ON jt.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jt.company_id
     WHERE is_balance_sheet_section = 1
       AND jt.company_id NOT LIKE '-1'
       AND ss.statement_section_id IN (64, 65, 66)
	   AND YEAR(entry_date) = 2015
       AND (credit != 0
        OR debit != 0)
GROUP BY   journal_entry_code, account_id, credit, debit, statement_section_code, year 
ORDER BY   account_id ASC
;

/*
Now we try to find the shareholder equity or equity which are a part of the balance sheet
*/

-- shareholder equity

SELECT     YEAR(entry_date)           AS 'year',
           jeli.account_id            AS 'account_id', 
           ss.statement_section_code  AS 'statement_section_code',
           je.journal_entry_code      AS 'journal_entry_code',
           ROUND(jeli.credit, 2)      AS 'credit',
           ROUND(jeli.debit, 2)       AS 'debit'
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_type               AS jt
        ON jt.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jt.company_id
     WHERE is_balance_sheet_section = 1
       AND jt.company_id NOT LIKE '-1'
       AND ss.statement_section_id = 67
	   AND YEAR(entry_date) = 2015
       AND (credit != 0
        OR debit != 0)
GROUP BY   journal_entry_code, account_id, credit, debit, statement_section_code, year 
ORDER BY   account_id ASC
;

--
/*
Now we try to find out how we can get sum of values 
in the given database and if it is balancing in the 
credit and debit statement
*/

--

SELECT    SUM(debit), 
          SUM(credit)
FROM      journal_entry AS je
LEFT JOIN journal_entry_line_item AS jeli
       ON je.journal_entry_id = jeli.journal_entry_id
    WHERE YEAR(entry_date) = 2016;


--
-- does not allow to create table
--
--
SELECT COUNT(DISTINCT journal_entry_id)
FROM journal_entry;
-- 
-- 

-- total assets

SELECT     SUM(ROUND(debit, 2))      AS Assets
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_type               AS jt
        ON jt.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jt.company_id
     WHERE is_balance_sheet_section = 1
       AND jt.company_id NOT LIKE '-1'
       AND ss.statement_section_id IN (61, 62, 63)
	   AND YEAR(entry_date) = 2015
       AND (credit != 0
        OR debit != 0)
;

-- total liabilities

SELECT     SUM(ROUND(debit, 2)) AS Liabilities
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_type               AS jt
        ON jt.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jt.company_id
     WHERE is_balance_sheet_section = 1
       AND jt.company_id NOT LIKE '-1'
       AND ss.statement_section_id IN (64, 65, 66)
	   AND YEAR(entry_date) = 2015
       AND (credit != 0
        OR debit != 0);

-- total equity
SELECT     Distinct(je.journal_entry_code), SUM(ROUND(CASE
		   when debit IS NULL then credit
           When credit IS Null then debit END, 0)) AS sum_debit,
		   a.account_id, 
		   a.account_code
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_type               AS jt
        ON jt.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jt.company_id
     WHERE is_balance_sheet_section <> 0
       AND jt.company_id NOT LIKE '-1'
       AND ss.statement_section_id IN (67)
	   AND YEAR(entry_date) = 2016
GROUP BY   je.journal_entry_code, a.account_id, a.account_code, je.journal_entry
ORDER BY   sum_debit
;


SELECT     SUM(IFNULL(jeli.debit,0) - IFNULL(jeli.credit,0)) AS sum_debit,
           je.journal_entry_code, 
		   a.account_id, 
		   a.account_code
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_type               AS jt
        ON jt.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jt.company_id
     WHERE is_balance_sheet_section = 1
       AND jt.company_id NOT LIKE '-1'
       AND ss.statement_section_id IN (67)
	   AND YEAR(entry_date) = 2015
GROUP BY   je.journal_entry_code, a.account_id, a.account_code
ORDER BY   sum_debit
;

SELECT     SUM(IFNULL(jeli.debit,0) - IFNULL(jeli.credit,0)) AS sum_debit,
           je.journal_entry_code, 
		   a.account_id, 
		   a.account_code
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_type               AS jt
        ON jt.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jt.company_id
     WHERE balance_sheet_section_id <> 0
            AND statement_section_code IN ('CA','FA','DA')
            AND je.debit_credit_balanced = 1
	   AND YEAR(entry_date) = 2015
GROUP BY   je.journal_entry_code, a.account_id, a.account_code
ORDER BY   sum_debit DESC
;

-- Assets Line Items
-- Cash Assets

SELECT SUM(ROUND(CASE
           When debit IS NULL then credit
           when debit IS NOT NULL then debit - credit END, 0)) AS Cash_assets
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_type               AS jt
        ON jt.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jt.company_id
     WHERE is_balance_sheet_section = 1
       AND jt.company_id NOT LIKE '-1'
       AND ss.statement_section_id IN (61, 62, 63)
	   AND YEAR(entry_date) = 2015
       AND jt.journal_type_code = 'CA'
       AND (credit != 0
        OR debit != 0)
;

-- 
-- Bank Assets

SELECT SUM(ROUND(CASE
           When credit IS NULL then debit
           when debit IS NULL then - credit END, 0)) AS Bank_assets
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_type               AS jt
        ON jt.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jt.company_id
     WHERE is_balance_sheet_section = 1
       AND jt.company_id NOT LIKE '-1'
       AND ss.statement_section_id IN (61, 62, 63)
	   AND YEAR(entry_date) = 2015
       AND jt.journal_type_code = 'BK'
       AND (credit != 0
        OR debit != 0)
;

-- 
-- General Assets

SELECT SUM(ROUND(CASE
           When credit IS NULL then debit
           when debit IS NULL then - credit END, 0)) AS General_assets
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_type               AS jt
        ON jt.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jt.company_id
     WHERE is_balance_sheet_section = 1
       AND jt.company_id NOT LIKE '-1'
       AND ss.statement_section_id IN (61, 62, 63)
	   AND YEAR(entry_date) = 2015
       AND jt.journal_type_code = 'GR'
       AND (credit != 0
        OR debit != 0)
;
-- 
-- Sales Assets
SELECT SUM(ROUND(CASE
           When credit IS NULL then debit
           when debit IS NULL then - credit END, 0)) AS Sales_assets
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_type               AS jt
        ON jt.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jt.company_id
     WHERE is_balance_sheet_section = 1
       AND jt.company_id NOT LIKE '-1'
       AND ss.statement_section_id IN (61, 62, 63)
	   AND YEAR(entry_date) = 2015
       AND jt.journal_type_code = 'SA'
       AND (credit != 0
        OR debit != 0)
;

-- Liabilities Line Items
-- Cash Liabilities
SELECT SUM(ROUND(CASE
           When debit IS NULL then credit
           when debit IS NOT NULL then debit - credit END, 0)) AS Cash_liabilities
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_type               AS jt
        ON jt.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jt.company_id
     WHERE is_balance_sheet_section = 1
       AND jt.company_id NOT LIKE '-1'
       AND ss.statement_section_id IN (64, 65, 66)
	   AND YEAR(entry_date) = 2015
       AND jt.journal_type_code = 'CA'
       AND (credit != 0
        OR debit != 0)
;

-- 
-- Bank Liabilities
SELECT SUM(ROUND(CASE
           When debit IS NULL then credit
           when debit IS NOT NULL then debit - credit END, 0)) AS Bank_liabilities
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_type               AS jt
        ON jt.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jt.company_id
     WHERE is_balance_sheet_section = 1
       AND jt.company_id NOT LIKE '-1'
       AND ss.statement_section_id IN (64, 65, 66)
	   AND YEAR(entry_date) = 2015
       AND jt.journal_type_code = 'BK'
       AND (credit != 0
        OR debit != 0)
;

-- 
-- General Liabilities
SELECT SUM(ROUND(CASE
           When debit IS NULL then credit
           when debit IS NOT NULL then debit - credit END, 0)) AS General_liabilities
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_type               AS jt
        ON jt.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jt.company_id
     WHERE is_balance_sheet_section = 1
       AND jt.company_id NOT LIKE '-1'
       AND ss.statement_section_id IN (64, 65, 66)
	   AND YEAR(entry_date) = 2015
       AND jt.journal_type_code = 'GR'
       AND (credit != 0
        OR debit != 0)
;

-- 
-- Sales Liabilities
SELECT SUM(ROUND(CASE
           When debit IS NULL then credit
           when debit IS NOT NULL then debit - credit END, 0)) AS Sales_liabilities
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_type               AS jt
        ON jt.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jt.company_id
     WHERE is_balance_sheet_section = 1
       AND jt.company_id NOT LIKE '-1'
       AND ss.statement_section_id IN (64, 65, 66)
	   AND YEAR(entry_date) = 2015
       AND jt.journal_type_code = 'SA'
       AND (credit != 0
        OR debit != 0)
;

-- Equity Line Items
-- Cash Equity
SELECT SUM(ROUND(CASE
           When debit IS NULL then credit
           when debit IS NOT NULL then debit - credit END, 0)) AS Cash_Equity
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_type               AS jt
        ON jt.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jt.company_id
     WHERE is_balance_sheet_section = 1
       AND jt.company_id NOT LIKE '-1'
       AND ss.statement_section_id = 67
	   AND YEAR(entry_date) = 2015
       AND jt.journal_type_code = 'CA'
       AND (credit != 0
        OR debit != 0)
;

SELECT *
FROM journal_entry
WHERE YEAR(entry_date) = 2016;


