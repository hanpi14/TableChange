DELETE
FROM dw.dwd.dwd_order_emp_online_!{load_freq}i
WHERE is_sup = 0
  AND data_source = -12
  AND (is_extra = 1 OR is_refund = 1)
  AND order_type = 8;

INSERT INTO dw.dwd.dwd_order_emp_online_!{load_freq}i(
    data_source,
    order_no,
    order_type,
    business_type,
    ar_no,
    order_month,
    raw_order_month,
    fee_month,
    member_code,
    member_name,
    party_b,
    emp_name,
    emp_id_no,
    mobile,
    region,
    raw_region,
    order_region,
    raw_order_region,
    order_item,
    order_tax_rate,
    reward_tax_rate,
    is_solo,
    is_collect,
    is_cross,
    is_refund,
    is_extra,
    is_sup,
    is_cancel,
    is_diff,
    is_ignore,
    is_discard,
    income_type,
    income_reward,
    raw_income_reward,
    tax_calc_mode,
    income_order,
    raw_income_order,
    income_overdue,
    income_disabled,
    income_added_tax,
    income_stable,
    income_indv_tax,
    serve_count,
    supplier_code,
    supplier_name,
    cost_type,
    cost_reward,
    sale_emp_name,
    serve_emp_id,
    sale_emp_id,
    serve_dept_id,
    sale_dept_id,
    order_parm,
    indv_net_pay,
    indv_income_tax,
    income_indv_order,
    income_corp_order,
    corp_pension_amount,
    corp_pension_rate,
    indv_pension_amount,
    indv_pension_rate,
    corp_illness_amount,
    corp_illness_rate,
    indv_illness_amount,
    indv_illness_rate,
    corp_work_amount,
    corp_work_rate,
    indv_work_amount,
    indv_work_rate,
    corp_unemployed_amount,
    corp_unemployed_rate,
    indv_unemployed_amount,
    indv_unemployed_rate,
    corp_birth_amount,
    corp_birth_rate,
    indv_birth_amount,
    indv_birth_rate,
    corp_disabled_amount,
    corp_disabled_rate,
    indv_disabled_amount,
    indv_disabled_rate,
    corp_serious_illness_amount,
    corp_serious_illness_rate,
    indv_serious_illness_amount,
    indv_serious_illness_rate,
    corp_ext_illness_amount,
    corp_ext_illness_rate,
    indv_ext_illness_amount,
    indv_ext_illness_rate,
    corp_hospital_amount,
    corp_hospital_rate,
    indv_hospital_amount,
    indv_hospital_rate,
    corp_fund_amount,
    corp_fund_rate,
    indv_fund_amount,
    indv_fund_rate,
    indv_union_amount,
    indv_other_amount,
    debit_card_no,
    bank_name,
    bank_region,
    tax_corp,
    raw_create_time,
    comment,
    raw_order_no,
    batch_no
)
SELECT -12 AS data_source,
       A.code AS order_no,
       8 AS order_type,
       CASE
           WHEN F.virtual_flag = 0 THEN CASE J.open_invoice_type
                                            WHEN 1 THEN 8
                                            WHEN 2 THEN IF(M.dic_value = '2' OR M.dic_value = '3', 2, 1) END
           ELSE -1
           END AS business_type,
       A.receive_no AS ar_no,
       '${report_month}' AS order_month,
       E.tax_months AS raw_order_month,
       E.paid_months AS fee_month,
       F.member_code AS member_code,
       F.member_name AS member_name,
       G.org_name AS party_b,
       D.emp_name AS emp_name,
       D.idcard_no AS emp_id_no,
       D.tel AS mobile,
       CASE
           WHEN H.area_name LIKE '%（%' THEN SUBSTRING_INDEX(H.area_name, '（', 1)
           WHEN H.area_name = '重庆WK' THEN '重庆'
           ELSE H.area_name
           END AS region,
       H.area_name AS raw_region,
       CASE
           WHEN N.area_name LIKE '%（%' THEN SUBSTRING_INDEX(N.area_name, '（', 1)
           WHEN N.area_name = '重庆WK' THEN '重庆'
           ELSE N.area_name
           END AS order_region,
       N.area_name AS raw_order_region,
       B.project AS order_item,
       E.daishou_tax_rate AS order_tax_rate,
       E.tax_rate AS reward_tax_rate,
       0 AS is_solo,
       1 AS is_collect,
       IF((E.tax_report_rule = '2' AND E.tax_months < '${report_month}') OR
          (E.tax_report_rule = '1' AND DATE_FORMAT(E.create_time, 'yyyyMM') < DATE_FORMAT(
                  add_months(to_date(CONCAT('${report_month}', '01'), 'yyyyMMdd'), -1),
                  'yyyyMM')), 1, 0) AS is_cross,
       1 AS is_refund,
       0 AS is_extra,
       0 AS is_sup,
       0 AS is_cancel,
       0 AS is_diff,
       0 AS is_ignore,
       0 AS is_discard,
       CASE J.open_invoice_type WHEN 1 THEN 2 WHEN 2 THEN 1 END AS income_type,
       ROUND(IF(B.project = '服务费', B.amount / 10000, 0), 4) AS income_reward,
       ROUND(IF(B.project = '服务费', B.amount / 10000, 0), 4) AS raw_income_reward,
       IF(L.tax_rule = 1, 2, 1) AS tax_calc_mode,
       ROUND(IF(B.project = '服务费', 0, B.amount / 10000), 4) AS income_order,
       ROUND(IF(B.project = '服务费', 0, B.amount / 10000), 4) AS raw_income_order,
       0 AS income_overdue,
       0 AS income_disabled,
       0 AS income_added_tax,
       0 AS income_stable,
       0 AS income_indv_tax,
       1 AS serve_count,
       IFNULL(K.supplier_code, '') AS supplier_code,
       IFNULL(K.supplier_name, '') AS supplier_name,
       1 AS cost_type,
       0 AS cost_reward,
       '' AS sale_emp_name,
       IFNULL(E.service_emp, -1) AS serve_emp_id,
       IFNULL(E.achie_emp, -1) AS sale_emp_id,
       IFNULL(E.hr_service_dept, -1) AS serve_dept_id,
       IFNULL(E.hr_achie_dept, -1) AS sale_dept_id,
       D.revenue_position AS order_parm,
       IF(B.project = '实发工资', B.amount / 10000, 0) AS indv_net_pay,
       IF(B.project = '个税', B.amount / 10000, 0) AS indv_income_tax,
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
       IF(B.project = '残保金', B.amount / 10000, 0) AS indv_disabled_amount,
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
       IFNULL(D.bank_card_number, '') AS debit_card_no,
       IFNULL(D.bank_name, '') AS bank_name,
       IFNULL(D.account_city, '') AS bank_region,
       E.tax_org_name AS tax_corp,
       A.create_time AS raw_create_time,
       A.remark AS comment,
       '' AS raw_order_no,
       REPLACE(UUID(), '-', '') AS batch_no
FROM ods.trade_center.trade_business_fee_refund_order A
         INNER JOIN ods.trade_center.trade_business_fee_refund_order_detail B
                    ON A.id = B.order_id AND B.valid = 1
         INNER JOIN ods.sbt_prod.pay_payroll_diff C
                    ON B.record_id = C.id
         INNER JOIN ods.sbt_prod.pay_payroll_emp D
                    ON C.from_payroll_id = D.payroll_id
         INNER JOIN ods.sbt_prod.pay_payroll_bill E
                    ON E.bill_id = C.from_bill_id
         INNER JOIN ods.sbt_prod.mbc_member_info F
                    ON E.member_id = F.member_id
         LEFT JOIN ods.sbt_prod.oprt_boss_organization G
                   ON E.org_id = G.org_id
         LEFT JOIN ods.sbt_prod.basic_ins_area H
                   ON D.area_code = H.area_code
         LEFT JOIN ods.sbt_prod.mbc_member_product I
                   ON I.m_pr_id = E.m_pr_id
         LEFT JOIN ods.sbt_prod.basic_org_product J
                   ON J.pr_id = I.pr_id
         LEFT JOIN ods.sbt_prod.supplier_info K
                   ON E.supplier_id = K.supplier_id
         LEFT JOIN ods.sbt_prod.mbc_member_product_cover L
                   ON L.m_pr_id = I.m_pr_id AND E.area_code = L.area_code AND L.alive_flag = '1'
         LEFT JOIN ods.sbt_prod.sys_dictionary_dtl M
                   ON J.service_type = M.dic_value AND M.dic_code = 'PR_SERVICE_TYPE'
         LEFT JOIN ods.sbt_prod.basic_ins_area N
                   ON E.area_code = N.area_code
         LEFT JOIN ods.sbt_prod.fnc_receivable_account S
                   ON A.receive_no = S.receive_no
WHERE (
        (S.order_month = '${report_month}' AND DATE_FORMAT(S.confirm_time, 'yyyyMM') <= '${report_month}')
        OR (S.order_month <= '${report_month}' AND DATE_FORMAT(S.confirm_time, 'yyyyMM') = '${report_month}')
    )
  AND A.business_type = 2
  AND A.state IN (3, 5);