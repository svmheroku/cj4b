--
-- us_stk_past.sql
--

DROP TABLE us_stk_pst10;
PURGE RECYCLEBIN;
CREATE TABLE us_stk_pst10 COMPRESS AS
SELECT
tkr
,ydate
,clse
,tkrdate
,(LEAD(clse,12*1,NULL)OVER(PARTITION BY tkr ORDER BY ydate)-clse) g1
,clse price_0hr
,clse2
,gain1day
,selldate
FROM di5min_stk_c2
WHERE ydate > '2011-01-30'
AND clse > 0
ORDER BY tkr,ydate
/

ANALYZE TABLE us_stk_pst10 ESTIMATE STATISTICS SAMPLE 9 PERCENT;

exit
