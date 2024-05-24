-- mysql

UPDATE dwd_order_emp_mi X,(SELECT *
                        FROM dwd_order_emp_mi
                        WHERE order_type = 1
                          AND is_sup = 0
                          AND is_extra = 0
                          AND is_refund = 0
                          AND income_reward != 0
) Y
SET X.income_reward=0
WHERE X.fee_month = Y.fee_month
  AND X.order_month = Y.order_month
  AND X.raw_region = Y.raw_region
  AND X.order_type = 2
  AND ((X.data_source =1 AND Y.data_source =1) OR (X.data_source =4 AND Y.data_source =4) OR (X.data_source =9 AND Y.data_source =9))
  AND X.member_code = Y.member_code
  AND X.is_sup = 0
  AND X.is_extra = 0
  AND X.is_refund = 0
  AND X.emp_id_no = Y.emp_id_no
  AND X.income_reward != 0
  AND ((X.is_cancel=Y.is_cancel) OR (X.is_cancel=1 AND Y.is_cancel=0));

--sparkSql on iceberg
MERGE INTO dw.dwd.dwd_order_emp_di AS X USING (SELECT *
                        FROM dw.dwd.dwd_order_emp_di
                        WHERE order_type = 1
                          AND is_sup = 0
                          AND is_extra = 0
                          AND is_refund = 0
                          AND income_reward != 0) AS Y
       ON (X.fee_month = Y.fee_month
       AND X.order_month = Y.order_month
       AND X.raw_region = Y.raw_region
       AND X.order_type = 2
       AND ((X.data_source =1 AND Y.data_source =1) OR (X.data_source =4 AND Y.data_source =4) OR (X.data_source =9 AND Y.data_source =9))
       AND X.member_code = Y.member_code
       AND X.is_sup = 0
       AND X.is_extra = 0
       AND X.is_refund = 0
       AND X.emp_id_no = Y.emp_id_no
       AND X.income_reward != 0
       AND ((X.is_cancel=Y.is_cancel) OR (X.is_cancel=1 AND Y.is_cancel=0)))
      WHEN MATCHED  THEN UPDATE SET X.income_reward=0;

--sparkSql local

SELECT * FROM  dw.dwd.dwd_order_emp_di AS X JOIN  (SELECT *
                                                   FROM dw.dwd.dwd_order_emp_mi
                                                   WHERE order_type = 1
                                                     AND is_sup = 0
                                                     AND is_extra = 0
                                                     AND is_refund = 0
                                                     AND income_reward != 0) AS Y
ON  (X.fee_month = Y.fee_month
    AND X.order_month = Y.order_month
    AND X.raw_region = Y.raw_region
    AND X.order_type = 2
    AND ((X.data_source =1 AND Y.data_source =1) OR (X.data_source =4 AND Y.data_source =4) OR (X.data_source =9 AND Y.data_source =9))
    AND X.member_code = Y.member_code
    AND X.is_sup = 0
    AND X.is_extra = 0
    AND X.is_refund = 0
    AND X.emp_id_no = Y.emp_id_no
    AND X.income_reward != 0
    AND ((X.is_cancel=Y.is_cancel) OR (X.is_cancel=1 AND Y.is_cancel=0)));

