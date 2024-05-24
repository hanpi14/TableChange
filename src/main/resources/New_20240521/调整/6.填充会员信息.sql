--mysql

UPDATE dwd_order_emp_mi A,dwd_member_mi B
SET A.member_code=B.member_code
WHERE A.member_name != ''
  AND A.member_code = ''
  AND A.member_name = B.member_name;


--sparkSql on iceberg
MERGE INTO dw.dwd.dwd_order_emp_di AS A USING(
      SELECT member_name,member_code FROM dw.dwd.dwd_member_di
) B
ON(
  A.member_name != ''
  AND A.member_code = ''
  AND A.member_name = B.member_name
)
WHEN MATCHED  THEN UPDATE SET A.member_code=B.member_code;

-- sparkSql Local

SELECT * FROM  dw.dwd.dwd_order_emp_di AS A  JOIN
               dw.dwd.dwd_member_mi AS B
ON (
            A.member_name != ''
        AND A.member_code = ''
        AND A.member_name = B.member_name
    )
