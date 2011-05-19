--
-- us_stk_past_week.sql
--

-- Usage: @us_stk_past_week.sql 2011-01-30

-- I use this script to get 1 week's worth of us_stk-prediction data.
-- This script depends on tables created by us_stk_past.sql
-- So, I should run us_stk_past.sql before I run us_stk_past_week.sql

-- Start by showing summarized data for each tkr:

COLUMN tkr FORMAT A8  HEADING  'Stock|Ticker'
COLUMN avg_danbot_score FORMAT 9.99 HEADING    'Avg|DanBot|Score' 

BREAK ON REPORT

COMPUTE SUM LABEL 'Sum:' OF sum_24hr_gain ON REPORT
COMPUTE SUM LABEL 'Sum:' OF position_count ON REPORT

SET TIME off TIMING off ECHO off PAGESIZE 123 LINESIZE 188
SET MARKUP HTML ON TABLE "class='table_us_stk_past_week'"
SPOOL /tmp/tmp_us_stk_past_week_&1

SELECT
tkr
,ROUND(AVG(score_diff),2) avg_danbot_score
FROM us_stk_pst13
WHERE rnng_crr1 > 0.1
AND score_diff < -0.55
AND ydate > '&1'
AND ydate - 7 < '&1'
GROUP BY tkr
ORDER BY tkr
/

SPOOL OFF
SET MARKUP HTML OFF

-- This is called by other sql scripts.
-- So, comment out exit:
-- exit

