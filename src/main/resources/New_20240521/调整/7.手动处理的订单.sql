-- mysql
UPDATE dwd_order_emp_mi A,dwd_ar_mi B
SET A.is_discard=1
WHERE A.order_no = B.order_no
  AND B.is_discard = 1;

--sparkSql on iceberg

MERGE INTO dw.dwd.dwd_order_emp_di AS A USING(
     SELECT order_no,is_discard FROM dw.dwd.dwd_ar_di WHERE is_discard = 1
) AS B
ON A.order_no = B.order_no
   WHEN MATCHED  THEN UPDATE SET    A.is_discard=1


--sparkSql Local

SELECT * FROM  dw.dwd.dwd_order_emp_di AS A JOIN (
    SELECT order_no,is_discard FROM dw.dwd.dwd_ar_mi WHERE is_discard = 1
)  AS B
ON A.order_no = B.order_no



