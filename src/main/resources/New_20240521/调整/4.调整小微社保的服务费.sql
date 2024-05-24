-- mysql
UPDATE dwd_order_emp_mi A ,dwd_order_custom_income_reward_mi B
SET A.income_reward=B.income_reward
WHERE A.order_no = B.order_no
  AND A.emp_id_no = B.emp_id_no
  AND A.fee_month = B.fee_month
  AND B.raw_region = ''
  AND A.order_type = B.order_type;

--sparkSql on iceberg
MERGE INTO dw.dwd.dwd_order_emp_di AS A USING (SELECT order_no,emp_id_no AS ein,fee_month,order_type,income_reward
      FROM dw.dwd.dwd_order_custom_income_reward_di WHERE raw_region = '') AS B
      ON(A.order_no = B.order_no
      AND A.emp_id_no = B.ein
      AND A.fee_month = B.fee_month
      AND A.order_type = B.order_type
      )
      WHEN MATCHED  THEN UPDATE SET A.income_reward=B.income_reward;

-- sparkSql local

SELECT * FROM dw.dwd.dwd_order_emp_mi AS A JOIN
              dw.dwd.dwd_order_custom_income_reward_mi B
                ON (A.order_no = B.order_no
                    AND A.emp_id_no = B.emp_id_no
                    AND A.fee_month = B.fee_month
                    AND B.raw_region = ''
                    AND A.order_type = B.order_type);
