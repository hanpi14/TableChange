-- mysql
UPDATE dwd_ar_mi A
SET A.reward_tax_rate=5
WHERE A.income_type = 1;

UPDATE
dwd_ar_mi A
SET A.reward_tax_rate=6
WHERE A.member_code IN (
    SELECT O.member_code FROM dwd_member_mi O WHERE O.group_code = '202011111583')
  AND A.income_type = 1;

UPDATE dwd_order_emp_mi A
SET A.reward_tax_rate=5
WHERE A.order_type IN (1, 2, 8)
  AND A.income_type = 1;

UPDATE
dwd_order_emp_mi A
SET A.reward_tax_rate=6,
    A.income_type=1,A.business_type=1
WHERE A.member_code IN (
    SELECT O.member_code FROM dwd_member_mi O WHERE O.group_code = '202011111583')
  AND A.order_type IN (1, 2, 8);

--sparkSql on iceberg

UPDATE dw.dwd.dwd_ar_di A SET A.reward_tax_rate=5 WHERE A.income_type = 1;


UPDATE
dw.dwd.dwd_ar_di A
SET A.reward_tax_rate=6
WHERE A.member_code IN (
    SELECT O.member_code FROM dw.dwd.dwd_member_di O WHERE O.group_code = '202011111583')
  AND A.income_type = 1;

UPDATE dw.dwd.dwd_order_emp_di A
SET A.reward_tax_rate=5
WHERE A.order_type IN (1, 2, 8)
  AND A.income_type = 1;


UPDATE dw.dwd.dwd_order_emp_di A
SET A.reward_tax_rate=6,
    A.income_type=1,A.business_type=1
WHERE A.member_code IN (
    SELECT O.member_code FROM dw.dwd.dwd_member_di O WHERE O.group_code = '202011111583')
  AND A.order_type IN (1, 2, 8);


--sparkSql Local




