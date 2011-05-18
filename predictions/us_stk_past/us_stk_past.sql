--
-- us_stk_past.sql
--

DROP TABLE us_stk_pst11;
PURGE RECYCLEBIN;
CREATE TABLE us_stk_pst11 COMPRESS AS
SELECT
tkr
,ydate
,tkrdate
,clse  price_0hr
,clse2 price_24hr
,gain1day
,selldate
,LEAD(clse,12*1,NULL)OVER(PARTITION BY tkr ORDER BY ydate) price_1hr
,(LEAD(clse,12*1,NULL)OVER(PARTITION BY tkr ORDER BY ydate)-clse) g1hr
FROM di5min_stk_c2
WHERE ydate > '2011-01-30'
AND clse > 0
ORDER BY tkr,ydate
/

ANALYZE TABLE us_stk_pst11 ESTIMATE STATISTICS SAMPLE 9 PERCENT;

-- Now join us_stk_pst11 with stkscores

DROP TABLE us_stk_pst13;
CREATE TABLE us_stk_pst13 COMPRESS AS
SELECT
m.tkr
,m.ydate
,(l.score-s.score)        score_diff
,ROUND(l.score-s.score,1) rscore_diff1
,ROUND(l.score-s.score,2) rscore_diff2
,m.gain1day
,m.selldate
,m.price_0hr
,m.price_1hr
,m.price_24hr
,m.g1hr
,CORR(l.score-s.score,m.gain1day)OVER(PARTITION BY l.tkr ORDER BY l.ydate ROWS BETWEEN 12*24*5 PRECEDING AND CURRENT ROW)rnng_crr1
FROM stkscores l,stkscores s,us_stk_pst11 m
WHERE l.targ='gatt'
AND   s.targ='gattn'
AND l.tkrdate = s.tkrdate
AND l.tkrdate = m.tkrdate
-- Speed things up:
AND l.ydate > sysdate - 123
AND s.ydate > sysdate - 123
/

ANALYZE TABLE us_stk_pst13 ESTIMATE STATISTICS SAMPLE 9 PERCENT;

-- This SELECT gives me text for a-tags
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
SET TIME off TIMING off ECHO off HEADING off
SET MARKUP HTML ON TABLE "id='table_us_stk_past'" ENTMAP ON
SPOOL /tmp/_us_stk_past_spool.html.erb

select 'hello world'from dual;

SPOOL OFF

exit
