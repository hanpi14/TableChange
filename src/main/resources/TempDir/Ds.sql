DELETE 
FROM dw.dwd.dwd_order_emp_online_!{load_freq}i 
WHERE order_item = '退费扣手续费' 
AND is_sup = 1 
AND order_type = 1; 
 
INSERT INTO dw.dwd.dwd_order_emp_online_!{load_freq}i(data_source, order_no, order_type, business_type, ar_no, order_month, 
raw_order_month, fee_month, 
member_code, member_name, 
party_b, 
emp_name, emp_id_no, mobile, region, raw_region, order_region,raw_order_region, order_item, 
order_tax_rate, 
reward_tax_rate, is_solo, 
is_collect, is_cross, 
is_refund, 
is_extra, 
is_sup, 
is_cancel, 
is_diff, 
is_ignore, 
is_discard, 
income_type, 
income_reward, raw_income_reward, income_order, raw_income_order, income_overdue, 
income_disabled, 
income_added_tax, 
income_stable, income_indv_tax, serve_count, supplier_code, supplier_name, cost_type, 
cost_reward, 
sale_emp_name, 
serve_emp_id, 
sale_emp_id, serve_dept_id, sale_dept_id, order_parm, indv_net_pay, 
indv_income_tax, 
income_indv_order, 
income_corp_order, corp_pension_amount, corp_pension_rate, indv_pension_amount, 
indv_pension_rate, corp_illness_amount, corp_illness_rate, indv_illness_amount, 
indv_illness_rate, corp_work_amount, corp_work_rate, indv_work_amount, indv_work_rate, 
corp_unemployed_amount, corp_unemployed_rate, indv_unemployed_amount, 
indv_unemployed_rate, 
corp_birth_amount, corp_birth_rate, indv_birth_amount, indv_birth_rate, 
corp_disabled_amount, 
corp_disabled_rate, indv_disabled_amount, indv_disabled_rate, 
corp_serious_illness_amount, 
corp_serious_illness_rate, indv_serious_illness_amount, indv_serious_illness_rate, 
corp_ext_illness_amount, corp_ext_illness_rate, indv_ext_illness_amount, 
indv_ext_illness_rate, 
corp_hospital_amount, corp_hospital_rate, indv_hospital_amount, indv_hospital_rate, 
corp_fund_amount, corp_fund_rate, indv_fund_amount, indv_fund_rate, indv_union_amount, 
indv_other_amount, debit_card_no, bank_name, bank_region, tax_corp, raw_create_time, 
comment,raw_order_no,batch_no) 
SELECT 1 AS data_source, 
A.order_no AS order_no, 
1 AS order_type, 
IFNULL(B.business_type, -1) AS business_type, 
A.ar_no AS ar_no, 
A.order_month AS order_month, 
A.order_month AS raw_order_month, 
A.order_month AS fee_month, 
A.member_code AS member_code, 
A.member_name AS member_name, 
A.party_b AS party_b, 
REPLACE(UUID(), _utf8'-', _utf8'') AS emp_name, 
REPLACE(UUID(), _utf8'-', _utf8'') AS emp_id_no, 
'' AS mobile, 
A.region AS region, 
A.raw_region AS raw_region, 
A.region AS order_region, 
A.raw_region AS raw_order_region, 
'退费扣手续费' AS order_item, 
0 AS order_tax_rate, 
A.reward_tax_rate AS reward_tax_rate, 
0 AS is_solo, 
1 AS is_collect, 
0 AS is_cross, 
0 AS is_refund, 
0 AS is_extra, 
1 AS is_sup, 
0 AS is_cancel, 
0 AS is_diff, 
0 AS is_ignore, 
0 AS is_discard, 
A.income_type AS income_type, 
A.income_reward AS income_reward, 
A.income_reward AS raw_income_reward, 
0 AS income_order, 
0 AS raw_income_order, 
0 AS income_overdue, 
0 AS income_disabled, 
0 AS income_added_tax, 
0 AS income_stable, 
0 AS income_indv_tax, 
1 AS serve_count, 
'' AS supplier_code, 
'' AS supplier_name, 
1 AS cost_type, 
0 AS cost_reward, 
'' AS sale_emp_name, 
A.serve_emp_id AS serve_emp_id, 
A.sale_emp_id AS sale_emp_id, 
A.serve_dept_id AS serve_dept_id, 
A.sale_dept_id AS sale_dept_id, 
0 AS order_parm, 
0 AS indv_net_pay, 
0 AS indv_income_tax, 
0 AS income_indv_order, 
0 AS income_corp_order, 
0 AS corp_pension_amount, 
0 AS corp_pension_rate, 
0 AS indv_pension_amount, 
0 AS indv_pension_rate, 
0 AS corp_illness_amount, 
0 AS corp_illness_rate, 
0 AS indv_illness_amount, 
0 AS indv_illness_rate, 
0 AS corp_work_amount, 
0 AS corp_work_rate, 
0 AS indv_work_amount, 
0 AS indv_work_rate, 
0 AS corp_unemployed_amount, 
0 AS corp_unemployed_rate, 
0 AS indv_unemployed_amount, 
0 AS indv_unemployed_rate, 
0 AS corp_birth_amount, 
0 AS corp_birth_rate, 
0 AS indv_birth_amount, 
0 AS indv_birth_rate, 
0 AS corp_disabled_amount, 
0 AS corp_disabled_rate, 
0 AS indv_disabled_amount, 
0 AS indv_disabled_rate, 
0 AS corp_serious_illness_amount, 
0 AS corp_serious_illness_rate, 
0 AS indv_serious_illness_amount, 
0 AS indv_serious_illness_rate, 
0 AS corp_ext_illness_amount, 
0 AS corp_ext_illness_rate, 
0 AS indv_ext_illness_amount, 
0 AS indv_ext_illness_rate, 
0 AS corp_hospital_amount, 
0 AS corp_hospital_rate, 
0 AS indv_hospital_amount, 
0 AS indv_hospital_rate, 
0 AS corp_fund_amount, 
0 AS corp_fund_rate, 
0 AS indv_fund_amount, 
0 AS indv_fund_rate, 
0 AS indv_union_amount, 
0 AS indv_other_amount, 
'' AS debit_card_no, 
'' AS bank_name, 
'' AS bank_region, 
'' AS tax_corp, 
A.raw_create_time AS raw_create_time, 
'' AS comment, 
'' AS raw_order_no, 
REPLACE(UUID(), _utf8'-', _utf8'') AS batch_no 
FROM dw.dwd.dwd_ar_!{load_freq}i A 
LEFT JOIN dw.dwd.mid_product_business_mapping B ON A.product_name = B.product_name AND B.tag = 4 
WHERE A.data_source = -3 
AND A.is_discard = 0 
AND A.is_split = 0 
