--
-- us_stk_past_week.sql
--

-- Usage: @us_stk_past_week.sql 2011-01-30

-- I use this script to get 1 week's worth of us_stk-prediction data.
-- This script depends on tables created by us_stk_past.sql
-- So, I should run us_stk_past.sql before I run us_stk_past_week.sql

-- Start by showing summarized data for each tkr:

COLUMN tkr FORMAT A8  HEADING  'Stock|Ticker'
COLUMN avg_danbot_score FORMAT 9.99    HEADING 'Avg|DanBot|Score'
COLUMN sharpe_ratio     FORMAT 9999.99 HEADING 'Sharpe|Ratio'  
COLUMN avg_24hr_gain    FORMAT 999.99  HEADING 'Avg|24hr|Gain'
COLUMN position_count   FORMAT 99999   HEADING 'Count of|positions'  
COLUMN sum_24hr_gain    FORMAT 99999.9999 HEADING 'Sum of|24hr gains'   

BREAK ON REPORT

COMPUTE SUM LABEL 'Sum:' OF sum_24hr_gain ON REPORT
COMPUTE SUM LABEL 'Sum:' OF position_count ON REPORT

SET TIME off TIMING off ECHO off PAGESIZE 123 LINESIZE 188
SET MARKUP HTML ON TABLE "class='table_us_stk_past_week'"
SPOOL /tmp/tmp_us_stk_past_week_&1

SELECT
tkr
,ROUND(AVG(score_diff),2)                  avg_danbot_score
,ROUND(AVG(gain1day) / STDDEV(gain1day),2) sharpe_ratio
,ROUND(AVG(gain1day),2)                    avg_24hr_gain
,COUNT(gain1day)                           position_count
,ROUND(SUM(gain1day),2)                    sum_24hr_gain
FROM us_stk_pst13
WHERE rnng_crr1 > 0.1
AND score_diff < -0.55
AND ydate > '&1'
AND ydate - 7 < '&1'
GROUP BY tkr
HAVING STDDEV(gain1day) > 0
ORDER BY tkr
/

SPOOL OFF
SET MARKUP HTML OFF

-- This is called by other sql scripts.
-- So, comment out exit:
-- exit

