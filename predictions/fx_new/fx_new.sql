--
-- fx_new.sql
--

@fxpst12.sql

COLUMN pair          FORMAT A8  HEADING     'Currency|Pair'    
COLUMN timestamp_0hr FORMAT A11   HEADING 'GMT Time|at hour 0' 
COLUMN danbot_score FORMAT 9.99   HEADING 'DanBot|Score|at hour 0' 
COLUMN price_0hr    FORMAT 999.9999 HEADING 'Price at|hour 0'
COLUMN price_1hr    FORMAT 999.9999 HEADING 'Price after|1 hour'
COLUMN price_6hr    FORMAT 999.9999 HEADING 'Price after|6 hours'
COLUMN gain_6hr1hr  FORMAT  99.9999 HEADING '5 hour gain|between|hr1 and hr6'
COLUMN normalized_gain_5hr FORMAT 9.9999 HEADING 'Normalized|5hr gain'

SET TIME off TIMING off ECHO off PAGESIZE 123 LINESIZE 188
SET MARKUP HTML ON TABLE "class='table_fx_new'"
SPOOL /tmp/_fx_new_spool.html.erb

SELECT
pair
,ydate timestamp_0hr
,ROUND(score_diff,4) danbot_score
,ROUND(price_0hr,4)  price_0hr
,ROUND(price_1hr,4)  price_1hr
,ROUND(price_6hr,4)  price_6hr
,ROUND(price_6hr-price_1hr,4)gain_6hr1hr
,ROUND((price_6hr-price_1hr)/price_0hr,4)normalized_gain_5hr
FROM fxpst12
WHERE rnng_crr1 > 0.0
AND score_diff < -0.55
AND ydate > sysdate - 3
ORDER BY pair,ydate
/

SPOOL OFF

exit
