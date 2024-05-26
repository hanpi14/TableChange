-- mysql
UPDATE dwd_order_emp_mi
SET income_reward=0
WHERE u_id IN (
SELECT R.u_id FROM (
SELECT DISTINCT A.u_id FROM dwd_order_emp_mi A
INNER JOIN dwd_order_emp_mi B
ON A.data_source=B.data_source AND A.order_no=B.order_no AND A.order_type=B.order_type
AND A.fee_month=B.fee_month AND A.emp_id_no=B.emp_id_no AND A.is_cancel=1 AND B.is_cancel=0
AND A.is_refund=0 AND A.is_extra=0 AND  A.is_sup=0 AND B.is_refund=0 AND B.is_extra=0 AND  B.is_sup=0
WHERE A.income_reward!=0 AND B.income_reward !=0
) R
);

-- sparkSql on iceberg

MERGE INTO dw.dwd.dwd_order_emp_di AS A USING(
      SELECT * FROM dw.dwd.dwd_order_emp_mi WHERE income_reward !=0 AND B.is_refund=0 AND B.is_extra=0 AND  B.is_sup=0 AND B.is_cancel=0
) B
ON (
A.data_source=B.data_source
AND A.order_no=B.order_no
AND A.order_type=B.order_type
AND A.fee_month=B.fee_month
AND A.emp_id_no=B.emp_id_no
AND A.is_cancel=1
AND A.is_refund=0
AND A.is_extra=0
AND A.is_sup=0
AND A.income_reward!=0
)
WHEN MATCHED  THEN UPDATE SET A.income_reward=0;



-- sparkSql Local
