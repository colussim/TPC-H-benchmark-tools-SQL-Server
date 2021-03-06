-- using default substitutions

/* TPC_H  Query 6 - Forecasting Revenue Change */

SELECT	SUM(L_EXTENDEDPRICE*L_DISCOUNT)	AS REVENUE
FROM	LINEITEM
WHERE	L_SHIPDATE	>= '1994-01-01' AND
	L_SHIPDATE	< dateadd (yy, 1, cast('1994-01-01' as date)) AND
	L_DISCOUNT	BETWEEN .06 - 0.01 AND .06 + 0.01 AND
	L_QUANTITY	< 24
