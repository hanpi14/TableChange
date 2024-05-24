--mysql

UPDATE dwd_order_emp_mi A , (SELECT order_no,order_type,fee_month,emp_id_no,MIN(order_parm) AS order_parm
FROM dwd_order_emp_mi WHERE income_reward!=0  AND is_extra = 0 AND is_refund = 0
GROUP BY order_no,order_type,fee_month,emp_id_no HAVING COUNT(order_parm)>1 ) B
SET income_reward=0
WHERE  A.order_no=B.order_no
AND A.order_type=B.order_type
AND A.fee_month=B.fee_month
AND A.emp_id_no=B.emp_id_no
AND A.order_parm!=B.order_parm
AND A.is_extra = 0 AND A.is_refund = 0 AND A.order_type IN(1,2) AND A.data_source!=-1;


--sparkSql On iceberg
MERGE INTO dw.dwd.dwd_order_emp_di AS A USING(SELECT order_no,order_type,fee_month,emp_id_no,MIN(order_parm) AS order_parm
FROM dw.dwd.dwd_order_emp_di WHERE income_reward!=0  AND is_extra = 0 AND is_refund = 0
GROUP BY order_no,order_type,fee_month,emp_id_no HAVING COUNT(order_parm)>1 ) B
ON (
A.order_no=B.order_no
AND A.order_type=B.order_type
AND A.fee_month=B.fee_month
AND A.emp_id_no=B.emp_id_no
AND A.order_parm!=B.order_parm
AND A.is_extra = 0 AND A.is_refund = 0 AND A.order_type IN(1,2) AND A.data_source!=-1
)
WHEN MATCHED  THEN UPDATE SET A.income_reward=0;



-- sparkSql Local


SELECT * FROM  dw.dwd.dwd_order_emp_di AS A JOIN
               (SELECT order_no,order_type,fee_month,emp_id_no,MIN(order_parm) AS order_parm
                FROM dw.dwd.dwd_order_emp_di WHERE income_reward!=0  AND is_extra = 0 AND is_refund = 0
                GROUP BY order_no,order_type,fee_month,emp_id_no HAVING COUNT(order_parm)>1 ) B
               ON (
                           A.order_no=B.order_no
                       AND A.order_type=B.order_type
                       AND A.fee_month=B.fee_month
                       AND A.emp_id_no=B.emp_id_no
                       AND A.order_parm!=B.order_parm
                       AND A.is_extra = 0 AND A.is_refund = 0 AND A.order_type IN(1,2) AND A.data_source!=-1
                   )
