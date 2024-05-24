--mysql

UPDATE dwd_order_emp_mi A ,dwd_order_custom_income_reward_mi B
SET A.income_reward=B.income_reward
WHERE A.order_no = B.order_no
  AND A.emp_id_no = B.emp_id_no
  AND A.fee_month = B.fee_month
  AND A.raw_region = B.raw_region
  AND B.raw_region != ''
  AND A.order_type = B.order_type
  AND A.is_extra = 0
  AND A.is_sup = 0
  AND A.is_refund = 0;


--sparkSql on iceberg
MERGE INTO dw.dwd.dwd_order_emp_di AS A USING (SELECT emp_id_no AS ein,fee_month,raw_region,order_no,income_reward
      FROM dw.dwd.dwd_order_custom_income_reward_di WHERE raw_region != '') AS B
      ON (A.emp_id_no = B.ein
      AND A.fee_month = B.fee_month
      AND A.raw_region = B.raw_region
      AND  A.order_no = B.order_no
      AND A.is_extra = 0
      AND A.is_sup = 0
      AND A.is_refund = 0)
      WHEN MATCHED  THEN UPDATE SET A.income_reward=B.income_reward;