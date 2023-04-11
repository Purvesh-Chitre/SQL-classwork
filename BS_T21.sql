USE H_accounting;

-- CREATING PROCEDURE FOR THE BALANCE SHEET
/*

*/


DROP PROCEDURE IF EXISTS h_accounting.sp_pchitre_temp;
DELIMITER $$
CREATE PROCEDURE BS_T21(varCalenderYear INT)
BEGIN
    -- Declaring variables
    DECLARE i INT;
    DECLARE statement_section VARCHAR(35);
    -- a,b will be used for calculating the percentage change
    DECLARE a DOUBLE;
    DECLARE b DOUBLE;
    -- setting year as a global variable to be used in the prepared statements SQL
    SET @year = varCalendarYear;
    SET @prev_year = varCalendarYear - 1;
    -- setting company id to 1
    SET @comp_id = 1;
    -- dummy var saying if we are getting values for BS (1), or PL (0)
    SET @BS = 1;
    -- t is the counter to offset the returned statement section id in the WHERE subquery
    SET @t = 0;
    -- i si the counter fot he while loop
    SET i = -(SELECT COUNT(*)
              FROM statement_section
              WHERE company_id = 1
                AND is_balance_sheet_section = 1);
    -- creating table to store the final BS with percentage changes
    DROP TABLE if EXISTS final_BS2015;
    CREATE TABLE final_BS2015
    (
        Account           VARCHAR(35),
        Current_Year      VARCHAR(25),
        Past_Year         VARCHAR(25),
        Percentage_Change VARCHAR(25)
    );
    -- while loop to get all the accounts of the BS for the specified and its previous year
    -- calculate the percentage change and storing all in the table final_BS
    WHILE i < 0
        DO
            -- getting the field to put in the table
            SET @field = (SELECT statement_section 
                          FROM statement_section 
                          WHERE is_balance_sheet_section = 1 
                          AND company_id = 1 
                          LIMIT 100, 1);
            PREPARE stmt FROM @sql;
            EXECUTE stmt USING @BS, @comp_id, @t;
            -- IF statement to see if it is an asset or liabilities/equity to be calculated
            IF @field LIKE ('%ASSETS%') THEN
                -- assets --> debit - credit
                SET @amount = (SELECT IFNULL((SUM(jeli.debit) - SUM(jeli.credit)), 0)
                           FROM account
                                    INNER JOIN journal_entry_line_item AS jeli
											ON account.account_id = jeli.account_id
                                    INNER JOIN journal_entry AS je
											ON jeli.journal_entry_id = je.journal_entry_id
                           WHERE balance_sheet_section_id = (SELECT statement_section_id 
                                                             FROM statement_section 
                                                             WHERE is_balance_sheet_section = 1 
                                                             AND company_id = 1 
                                                             LIMIT 100, 1)
                             AND YEAR(je.entry_date) = 2015
                             AND je.company_id = 1);
                PREPARE stmt FROM @sql;
                EXECUTE stmt USING @BS, @comp_id, @t, @Year, @comp_id;
                DEALLOCATE PREPARE stmt;
                -- querying for year previous to specified
                SET @amount_prev_year = (SELECT IFNULL((SUM(jeli.debit) - SUM(jeli.credit)), 0)
                           FROM account
                                    INNER JOIN journal_entry_line_item AS jeli
											ON account.account_id = jeli.account_id
                                    INNER JOIN journal_entry AS je
											ON jeli.journal_entry_id = je.journal_entry_id
                           WHERE balance_sheet_section_id = (SELECT statement_section_id 
                                                             FROM statement_section 
                                                             WHERE is_balance_sheet_section = 1 
                                                             AND company_id = 1 
                                                             LIMIT 100, 1)
                             AND YEAR(je.entry_date) = 2015
                             AND je.company_id = 1);
                PREPARE stmt FROM @sql;
                EXECUTE stmt USING @BS, @comp_id, @t, @prev_year, @comp_id;
                DEALLOCATE PREPARE stmt;

            ELSE
                -- Liability/equity --> credit - debit
				SET @amount = (SELECT IFNULL((SUM(jeli.credit) - SUM(jeli.debit)), 0)
                           FROM account
                                    INNER JOIN journal_entry_line_item AS jeli
											ON account.account_id = jeli.account_id
                                    INNER JOIN journal_entry AS je
											ON jeli.journal_entry_id = je.journal_entry_id
                           WHERE balance_sheet_section_id = (SELECT statement_section_id 
                                                             FROM statement_section 
                                                             WHERE is_balance_sheet_section = 1 
                                                             AND company_id = 1 
                                                             LIMIT 100, 1)
                             AND YEAR(je.entry_date) = 2015
                             AND je.company_id = 1);
                PREPARE stmt FROM @sql;
                EXECUTE stmt USING @BS, @comp_id, @t, @Year, @comp_id;
                DEALLOCATE PREPARE stmt;
                -- querying for year previous to specified
                SET @amount_prev_year = (SELECT IFNULL((SUM(jeli.credit) - SUM(jeli.debit)), 0)
                           FROM account
                                    INNER JOIN journal_entry_line_item AS jeli
											ON account.account_id = jeli.account_id
                                    INNER JOIN journal_entry AS je
											ON jeli.journal_entry_id = je.journal_entry_id
                           WHERE balance_sheet_section_id = (SELECT statement_section_id 
                                                             FROM statement_section 
                                                             WHERE is_balance_sheet_section = 1 
                                                             AND company_id = 1 
                                                             LIMIT 100, 1)
                             AND YEAR(je.entry_date) = 2015
                             AND je.company_id = 1);
                PREPARE stmt FROM @sql;
                EXECUTE stmt USING @BS, @comp_id, @t, @prev_year, @comp_id;
                DEALLOCATE PREPARE stmt;

            END IF;
            -- converting global var into FLOAT var
            SET a = CAST(@amount AS DECIMAL(65, 2));
            SET b = CAST(@amount_prev_year AS DECIMAL(65, 2));
            SET @perc_change = CONCAT(FORMAT(IFNULL(((a - b) / b) * 100, 0), 2), '%');
            -- insert data into table
            INSERT INTO final_BS_statements
            VALUES (@field, ROUND(@amount, 2), ROUND(@amount_prev_year, 2), @perc_change);
            SET @t = @t + 1;
            SET i = i + 1;
        END WHILE;


    SELECT *
    FROM final_BS2015;
END $$

CALL sp_Team21_BS();