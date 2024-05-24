-- MYSQL
UPDATE dwd_order_emp_mi A,(SELECT X.supplier_code, X.supplier_name, Y.*
                        FROM dwd_vendor_mi X,
                             dwd_vendor_cost_mi Y
                        WHERE X.supplier_id = Y.supplier_id
                          AND Y.cost_rule NOT LIKE '%?%'
                          AND Y.cost_rule NOT LIKE '%=%'
) B
SET A.cost_reward=B.cost_rule
WHERE A.supplier_code = B.supplier_code
  AND A.supplier_name = B.supplier_name
  AND A.order_type IN (1, 2)
  AND A.is_extra = 0
  AND A.is_sup = 0
  AND A.data_source IN(1, 4, 9, -3)
  AND A.is_refund = 0
  AND A.is_cancel = 0
  AND A.is_ignore = 0
  AND A.is_discard = 0
  AND A.raw_region = B.region
  AND A.order_item = B.ins_name;



--sparkSql on iceberg

MERGE INTO dw.dwd.dwd_order_emp_di AS A USING (
                SELECT X.supplier_code, X.supplier_name, Y.*
                        FROM dw.dwd.dwd_vendor_di X,
                             dw.dwd.dwd_vendor_cost_di Y
                        WHERE X.supplier_id = Y.supplier_id
                          AND Y.cost_rule NOT LIKE '%?%'
                          AND Y.cost_rule NOT LIKE '%=%'
) AS B
      ON(
      A.supplier_code = B.supplier_code
  AND A.supplier_name = B.supplier_name
  AND A.order_type IN (1, 2)
  AND A.is_extra = 0
  AND A.is_sup = 0
  AND A.data_source IN(1, 4, 9, -3)
  AND A.is_refund = 0
  AND A.is_cancel = 0
  AND A.is_ignore = 0
  AND A.is_discard = 0
  AND A.raw_region = B.region
  AND A.order_item = B.ins_name)
       WHEN MATCHED  THEN UPDATE SET A.cost_reward=CAST(B.cost_rule AS DECIMAL(15,4));


-- sparkSql local
                          -- sparkSql Local
SELECT * FROM  dw.dwd.dwd_order_emp_di AS A JOIN
               (
                   SELECT X.supplier_code, X.supplier_name, Y.*
                   FROM dw.dwd.dwd_vendor_di X,
                        dw.dwd.dwd_vendor_cost_di Y
                   WHERE X.supplier_id = Y.supplier_id
                     AND Y.cost_rule NOT LIKE '%?%'
                     AND Y.cost_rule NOT LIKE '%=%'
               ) AS B
               ON(
                           A.supplier_code = B.supplier_code
                       AND A.supplier_name = B.supplier_name
                       AND A.order_type IN (1, 2)
                       AND A.is_extra = 0
                       AND A.is_sup = 0
                       AND A.data_source IN(1, 4, 9, -3)
                       AND A.is_refund = 0
                       AND A.is_cancel = 0
                       AND A.is_ignore = 0
                       AND A.is_discard = 0
                       AND A.raw_region = B.region
                       AND A.order_item = B.ins_name)


-------------------------------------------------------------------------------------

SELECT DISTINCT X.supplier_code, X.supplier_name, Y.cost_rule
FROM dwd_vendor_mi X,
     dwd_vendor_cost_mi Y
WHERE X.supplier_id = Y.supplier_id
  AND Y.ins_type = 2
  AND (Y.cost_rule LIKE '%?%' OR Y.cost_rule LIKE '%=%');

UPDATE dwd_order_emp_mi A,(SELECT A.supplier_code,
                               B.supplier_name,
                               B.region,
                               B.ins_name,
                               B.cost_rule,
                               COUNT(A.emp_id_no) AS CNT
                        FROM dwd_order_emp_mi A,
                             (SELECT X.supplier_code, X.supplier_name, Y.*
                              FROM dwd_vendor_mi X,
                                   dwd_vendor_cost_mi Y
                              WHERE X.supplier_id = Y.supplier_id
                                AND (Y.cost_rule LIKE '%?%' OR Y.cost_rule LIKE '%=%')) B
                        WHERE A.supplier_code = B.supplier_code
                          AND A.supplier_name = B.supplier_name
                          AND A.order_item = B.ins_name
                          AND A.order_type = 2
                          AND A.is_extra = 0
                          AND A.is_cancel = 0
                          AND A.is_sup = 0
                          AND A.is_ignore = 0
                          AND A.data_source IN(1, 4, 9, -3)
                          AND A.is_refund = 0
                          AND A.raw_region = B.region
                        GROUP BY A.supplier_code, A.supplier_name, A.raw_region, A.order_item, B.cost_rule) B
SET A.cost_reward=IF(B.CNT <= 150, 20, 15)
WHERE A.raw_region = B.region
  AND A.supplier_code = B.supplier_code
  AND A.order_item = B.ins_name
  AND A.order_type = 2
  AND A.is_extra = 0
  AND A.is_cancel = 0
  AND A.is_sup = 0
  AND A.is_ignore = 0
  AND A.data_source IN(1, 4, 9, -3)
  AND A.is_refund = 0
  AND A.is_discard = 0
  AND A.supplier_code = 'SP202104260001';

--sparkSql on iceberg



--sparkSql Local


----------------------------------------------------------------------------------------------------------------------------------

UPDATE dwd_order_emp_mi A,(SELECT A.supplier_code,
                               B.supplier_name,
                               B.region,
                               B.ins_name,
                               B.cost_rule,
                               COUNT(A.emp_id_no) AS CNT
                        FROM dwd_order_emp_mi A,
                             (SELECT X.supplier_code, X.supplier_name, Y.*
                              FROM dwd_vendor_mi X,
                                   dwd_vendor_cost_mi Y
                              WHERE X.supplier_id = Y.supplier_id
                                AND (Y.cost_rule LIKE '%?%' OR Y.cost_rule LIKE '%=%')) B
                        WHERE A.supplier_code = B.supplier_code
                          AND A.supplier_name = B.supplier_name
                          AND A.order_item = B.ins_name
                          AND A.order_type = 2
                          AND A.is_extra = 0
                          AND A.is_cancel = 0
                          AND A.is_sup = 0
                          AND A.is_ignore = 0
                          AND A.data_source IN(1, 4, 9, -3)
                          AND A.is_refund = 0
                          AND A.raw_region = B.region
                        GROUP BY A.supplier_code, A.supplier_name, A.raw_region, A.order_item, B.cost_rule) B
SET A.cost_reward=IF(B.CNT < 5, 50, IF(B.CNT <= 30, 30, 25))
WHERE A.raw_region = B.region
  AND A.supplier_code = B.supplier_code
  AND A.order_item = B.ins_name
  AND A.order_type = 2
  AND A.is_extra = 0
  AND A.is_cancel = 0
  AND A.is_ignore = 0
  AND A.data_source IN(1, 4, 9, -3)
  AND A.is_sup = 0
  AND A.is_refund = 0
  AND A.is_discard = 0
  AND A.supplier_code = 'SP201908300001';

---------------------------------------------------------------------------------------------------------------------------------

UPDATE dwd_order_emp_mi A
SET A.cost_reward=0
WHERE A.order_type IN (1, 2)
  AND (A.is_cancel = 1
    OR A.is_ignore = 1
    OR A.is_discard = 1)
  AND A.cost_reward > 0;

UPDATE dwd_order_emp_mi X,(SELECT *
                        FROM dwd_order_emp_mi
                        WHERE order_type = 1
                          AND is_sup = 0
                          AND is_extra = 0
                          AND is_refund = 0
                          AND is_ignore = 0
                          AND is_discard = 0
                          AND data_source IN(1, 4, 9, -3)
                          AND cost_reward > 0
) Y
SET X.cost_reward=0
WHERE X.fee_month = Y.fee_month
  AND X.order_month = Y.order_month
  AND X.raw_region = Y.raw_region
  AND X.order_type = 2
  AND X.data_source IN(1, 4, 9, -3)
  AND X.is_sup = 0
  AND X.is_extra = 0
  AND X.is_refund = 0
  AND X.is_ignore = 0
  AND X.is_discard = 0
  AND X.cost_reward > 0
  AND X.emp_id_no = Y.emp_id_no;


------------------------------------------------------------------------------------------------------------------------------
UPDATE dwd_order_emp_mi
SET cost_reward=0
WHERE u_id IN (
   SELECT A.u_id FROM (
SELECT P.u_id FROM
(SELECT order_no,emp_id_no,fee_month,MIN(order_parm) AS order_parm FROM dwd_order_emp_mi WHERE data_source IN (4,9) AND cost_reward>0 AND order_type=1 GROUP BY order_no,emp_id_no,fee_month) O
INNER JOIN
(SELECT * FROM dwd_order_emp_mi WHERE cost_reward>0 AND data_source in(4,9) AND order_type=1) P
WHERE O.order_no=P.order_no AND O.emp_id_no=P.emp_id_no AND O.fee_month=P.fee_month AND O.order_parm!=P.order_parm
   )A
);








