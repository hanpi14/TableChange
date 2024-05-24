-- mysql
UPDATE dwd_order_emp_mi A  SET A.income_order=0 WHERE A.is_solo=1 AND A.is_collect=0 AND A.data_source=2;

--SparkSql on iceberg

UPDATE dw.dwd.dwd_order_emp_di A  SET A.income_order=0 WHERE A.is_solo=1 AND A.is_collect=0 AND A.data_source=2;


-- sparkSql Local
