USE H_Accounting;

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

--
-- Basic 

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




DELIMITER $$
DROP PROCEDURE IF EXISTS H_Accounting.assets_laibilities_equity;
CREATE PROCEDURE H_Accounting.assets_laibilities_equity()
BEGIN
--
-- Assets

SELECT     YEAR(entry_date)           AS 'year',
           jeli.account_id            AS 'account_id', 
           ss.statement_section_code  AS 'statement_section_code',
           je.journal_entry           AS 'journal_entry',
           a.account                  AS 'account',
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
GROUP BY   journal_entry, account_id, credit, debit, statement_section_code, year 
ORDER BY   account_id ASC
;


--
-- Liabilities

SELECT     YEAR(entry_date)           AS 'year',
           jeli.account_id            AS 'account_id', 
           ss.statement_section_code  AS 'statement_section_code',
           je.journal_entry           AS 'journal_entry',
           a.account                  AS 'account',
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
GROUP BY   journal_entry, account_id, credit, debit, statement_section_code, year 
ORDER BY   account_id ASC
;

-- shareholder equity

SELECT     YEAR(entry_date)           AS 'year',
           jeli.account_id            AS 'account_id', 
           ss.statement_section_code  AS 'statement_section_code',
           je.journal_entry           AS 'journal_entry',
           a.account                  AS 'account',
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
GROUP BY   journal_entry, account_id, credit, debit, statement_section_code, year 
ORDER BY   account_id ASC
;
END $$
DELIMITER ;
CALL assets_liabilities_equity();
--
--

SELECT    SUM(debit), 
          SUM(credit)
FROM      journal_entry AS je
LEFT JOIN journal_entry_line_item AS jeli
       ON je.journal_entry_id = jeli.journal_entry_id
    WHERE YEAR(entry_date) = 2015;


--
-- does not allow to create table
--
--





