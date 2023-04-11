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

-- Error Code: 1146. Table 'h_accounting.journal_type' doesn't exist


SELECT     a.account_id               AS 'account_id', 
           ss.statement_section_code  AS 'statement_section_code',
           a.`account`                AS 'account',
           ROUND(jeli.credit, 2)      AS 'credit',
		   ROUND(jeli.debit, 2)       AS 'debit',
           je.entry_date              AS 'entry_date'
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_entry_type               AS jet
        ON jet.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jet.company_id
     WHERE is_balance_sheet_section = 1
       AND jet.company_id NOT LIKE '-1'
	   AND YEAR(entry_date) = 2015
       AND (credit != 0
        OR debit != 0)
GROUP BY   account_id, `account`, entry_date, credit, debit, statement_section_code
ORDER BY   entry_date ASC
;
-- 
-- 




--
-- Assets

SELECT     YEAR(entry_date)           AS 'year',
           jeli.account_id            AS 'account_id', 
           ss.statement_section_code  AS 'statement_section_code',
           je.journal_entry AS 'journal_entry',
           a.`account`                AS 'account',
           ROUND(jeli.credit, 2)      AS 'credit',
           ROUND(jeli.debit, 2)       AS 'debit'
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_entry_type         AS jet
        ON jet.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jet.company_id
     WHERE is_balance_sheet_section = 1
       AND jet.company_id NOT LIKE '-1'
       AND ss.statement_section_id IN (61, 62, 63)
	   AND YEAR(entry_date) = 2015
       AND (credit != 0
        OR debit != 0)
GROUP BY   `account`, journal_entry, account_id, credit, debit, statement_section_code, year 
ORDER BY   account_id ASC
;

--
-- Liabilities

SELECT     YEAR(entry_date)           AS 'year',
           jeli.account_id            AS 'account_id', 
           ss.statement_section_code  AS 'statement_section_code',
           je.journal_entry AS 'journal_entry',
           a.`account`                AS 'account',
           ROUND(jeli.credit, 2)      AS 'credit',
           ROUND(jeli.debit, 2)       AS 'debit'
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_entry_type               AS jet
        ON jet.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jet.company_id
     WHERE is_balance_sheet_section = 1
       AND jet.company_id NOT LIKE '-1'
       AND ss.statement_section_id IN (64, 65, 66)
	   AND YEAR(entry_date) = 2015
       AND (credit != 0
        OR debit != 0)
GROUP BY   `account`, journal_entry, account_id, credit, debit, statement_section_code, year 
ORDER BY   account_id ASC
;

-- shareholder equity

SELECT     YEAR(entry_date)           AS 'year',
           jeli.account_id            AS 'account_id', 
           ss.statement_section_code  AS 'statement_section_code',
           je.journal_entry           AS 'journal_entry',
           a.`account`                AS 'account',
           ROUND(jeli.credit, 2)      AS 'credit',
           ROUND(jeli.debit, 2)       AS 'debit'
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_entry_type               AS jet
        ON jet.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jet.company_id
     WHERE is_balance_sheet_section = 1
       AND jet.company_id NOT LIKE '-1'
       AND ss.statement_section_id = 67
	   AND YEAR(entry_date) = 2015
       AND (credit != 0
        OR debit != 0)
GROUP BY   `account`, journal_entry, account_id, credit, debit, statement_section_code, year 
ORDER BY   account_id ASC
;

--
--
/*
Error Code: 1305. PROCEDURE h_accounting.temp_table_assets does not exist
*/


DELIMITER $$
DROP PROCEDURE IF EXISTS H_Accounting.temp_table_assets;
CREATE PROCEDURE H_Accounting.temp_table_assets()
READS SQL DATA

BEGIN

DROP TEMPORARY TABLE IF EXISTS assets;
CREATE TEMPORARY TABLE assets

SELECT     YEAR(entry_date)           AS 'year',
           jeli.account_id            AS 'account_id', 
           ss.statement_section_code  AS 'statement_section_code',
           je.journal_entry AS 'journal_entry',
           a.`account`                AS 'account',
           ROUND(jeli.credit, 2)      AS 'credit',
           ROUND(jeli.debit, 2)       AS 'debit'
FROM       journal_entry_line_item    AS jeli
INNER JOIN `account`                  AS a
        ON a.account_id = jeli.account_id
INNER JOIN journal_entry              AS je
        ON jeli.journal_entry_id = je.journal_entry_id
      JOIN journal_entry_type         AS jet
        ON jet.journal_type_id = je.journal_type_id
	  JOIN statement_section          AS ss
        ON ss.company_id = jet.company_id
     WHERE is_balance_sheet_section = 1
       AND jet.company_id NOT LIKE '-1'
       AND ss.statement_section_id IN (61, 62, 63)
	   AND YEAR(entry_date) = 2015
       AND (credit != 0
        OR debit != 0)
GROUP BY   `account`, journal_entry, account_id, credit, debit, statement_section_code, year 
ORDER BY   account_id ASC


END $$
DELIMITER ;

CALL temp_table_assets();


-- Error Code: 1305. PROCEDURE h_accounting.temp_table_assets does not exist

-- 






