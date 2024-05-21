DELETE
FROM dw.dwd.dwd_order_emp_online_!{load_freq} i
WHERE is_sup = 0
  AND data_source = -12
  AND (is_extra = 1
   OR is_refund = 1)
  AND order_type IN (1
    , 2
    , -1);
INSERT INTO dw.dwd.dwd_order_emp_online_!{load_freq} i(data_source, order_no, order_type, business_type, ar_no,
                                                       order_month,
                                                       raw_order_month,
                                                       fee_month,
                                                       member_code, member_name,
                                                       party_b,
                                                       emp_name, emp_id_no, mobile, region, raw_region, order_region,
                                                       raw_order_region,
                                                       order_item,
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
                                                       income_reward, raw_income_reward, income_order, raw_income_order,
                                                       income_overdue,
                                                       income_disabled,
                                                       income_added_tax,
                                                       income_stable, income_indv_tax, serve_count, supplier_code,
                                                       supplier_name,
                                                       cost_type,
                                                       cost_reward,
                                                       sale_emp_name,
                                                       serve_emp_id,
                                                       sale_emp_id, serve_dept_id, sale_dept_id, order_parm,
                                                       indv_net_pay,
                                                       indv_income_tax,
                                                       income_indv_order,
                                                       income_corp_order, corp_pension_amount, corp_pension_rate,
                                                       indv_pension_amount,
                                                       indv_pension_rate, corp_illness_amount, corp_illness_rate,
                                                       indv_illness_amount,
                                                       indv_illness_rate, corp_work_amount, corp_work_rate,
                                                       indv_work_amount,
                                                       indv_work_rate,
                                                       corp_unemployed_amount, corp_unemployed_rate,
                                                       indv_unemployed_amount,
                                                       indv_unemployed_rate,
                                                       corp_birth_amount, corp_birth_rate, indv_birth_amount,
                                                       indv_birth_rate,
                                                       corp_disabled_amount,
                                                       corp_disabled_rate, indv_disabled_amount, indv_disabled_rate,
                                                       corp_serious_illness_amount,
                                                       corp_serious_illness_rate, indv_serious_illness_amount,
                                                       indv_serious_illness_rate,
                                                       corp_ext_illness_amount, corp_ext_illness_rate,
                                                       indv_ext_illness_amount,
                                                       indv_ext_illness_rate,
                                                       corp_hospital_amount, corp_hospital_rate, indv_hospital_amount,
                                                       indv_hospital_rate,
                                                       corp_fund_amount, corp_fund_rate, indv_fund_amount,
                                                       indv_fund_rate,
                                                       indv_union_amount,
                                                       indv_other_amount, corp_other_amount, debit_card_no, bank_name,
                                                       bank_region,
                                                       tax_corp,
                                                       raw_create_time,
                                                       comment, raw_order_no, batch_no)

SELECT -12                                                                           AS data_source,
       A.code                                                                        AS order_no,
       CASE WHEN C.ins_type = 1 THEN 1 WHEN C.ins_type = 2 THEN 2 ELSE -1 END        AS order_type,
       IF(F.virtual_flag = 0, CASE I.open_invoice_type
                                  WHEN 1 THEN 8
                                  WHEN 2 THEN IF(M.dic_value = '2' OR M.dic_value = '3', 2, 1) END,
          -1)                                                                        AS business_type,
       A.receive_no                                                                  AS ar_no,
       '${report_month}'                                                             AS order_month,
       C.area_order_month                                                            AS raw_order_month,
       C.fee_month                                                                   AS fee_month,
       F.member_code                                                                 AS member_code,
       F.member_name                                                                 AS member_name,
       E.org_name                                                                    AS party_b,
       D.emp_name                                                                    AS emp_name,
       D.idcard_no                                                                   AS emp_id_no,
       D.mobile_phone                                                                AS mobile,
       CASE
           WHEN G.area_name LIKE '%（%' THEN SUBSTRING_INDEX(G.area_name, '（', 1)
           WHEN G.area_name = '重庆WK' THEN '重庆'
           ELSE G.area_name
           END                                                                       AS region,
       G.area_name                                                                   AS raw_region,
       CASE
           WHEN G.area_name LIKE '%（%' THEN SUBSTRING_INDEX(G.area_name, '（', 1)
           WHEN G.area_name = '重庆WK' THEN '重庆'
           ELSE G.area_name
           END                                                                       AS order_region,
       G.area_name                                                                   AS raw_order_region,
       N.ins_org_name                                                                AS order_item,
       CASE
           WHEN R.sipr_tax_rate != 0 THEN R.sipr_tax_rate
           WHEN R.tax_rate != 0 THEN R.tax_rate
           ELSE 0 END                                                                AS order_tax_rate,
       H.tax_rate                                                                    AS reward_tax_rate,
       IF(C.account_property = 2, 1, 0)                                              AS is_solo,
       IF(C.account_property = 2, 0, 1)                                              AS is_collect,
       IF(C.area_order_month < '${report_month}', 1, 0)                              AS is_cross,
       IF(B.type = 1, 0, 1)                                                          AS is_refund,
       IF(B.type = 1, 1, 0)                                                          AS is_extra,
       0                                                                             AS is_sup,
       0                                                                             AS is_cancel,
       0                                                                             AS is_diff,
       0                                                                             AS is_ignore,
       0                                                                             AS is_discard,
       CASE I.open_invoice_type WHEN 1 THEN 2 WHEN 2 THEN 1 END                      AS income_type,
       IF(C.ins_code = 1, B.amount / 10000, 0)                                       AS income_reward,
       0                                                                             AS raw_income_reward,
       IF(C.account_property != 2 AND C.ins_code NOT IN (1, 2), B.amount / 10000, 0) AS income_order,
       IF(C.ins_code NOT IN (1, 2), B.amount / 10000, 0)                             AS raw_income_order,
       IF(C.ins_code = 2, B.amount / 10000, 0)                                       AS income_overdue,
       0                                                                             AS income_disabled,
       0                                                                             AS income_added_tax,
       0                                                                             AS income_stable,
       0                                                                             AS income_indv_tax,
       1                                                                             AS serve_count,
       IFNULL(L.supplier_code, '')                                                   AS supplier_code,
       IFNULL(L.supplier_name, '')                                                   AS supplier_name,
       1                                                                             AS cost_type,
       0                                                                             AS cost_reward,
       ''                                                                            AS sale_emp_name,
       IFNULL(P.service_emp, -1)                                                     AS serve_emp_id,
       IFNULL(P.achie_emp, -1)                                                       AS sale_emp_id,
       IFNULL(P.hr_service_dept, -1)                                                 AS serve_dept_id,
       IFNULL(P.hr_achie_dept, -1)                                                   AS sale_dept_id,
       0                                                                             AS order_parm,
       0                                                                             AS indv_net_pay,
       0                                                                             AS indv_income_tax,
       C.emp_diff_fee                                                                AS income_indv_order,
       C.org_diff_fee                                                                AS income_corp_order,
       IF(Q.category = 3, C.org_diff_fee, 0)                                         AS corp_pension_amount,
       0                                                                             AS corp_pension_rate,
       IF(Q.category = 3, C.emp_diff_fee, 0)                                         AS indv_pension_amount,
       0                                                                             AS indv_pension_rate,
       IF(Q.category = 4 AND Q.ins_code = 40, C.org_diff_fee, 0)                     AS corp_illness_amount,
       0                                                                             AS corp_illness_rate,
       IF(Q.category = 4 AND Q.ins_code = 40, C.emp_diff_fee, 0)                     AS indv_illness_amount,
       0                                                                             AS indv_illness_rate,
       IF(Q.category = 6, C.org_diff_fee, 0)                                         AS corp_work_amount,
       0                                                                             AS corp_work_rate,
       IF(Q.category = 6, C.emp_diff_fee, 0)                                         AS indv_work_amount,
       0                                                                             AS indv_work_rate,
       IF(Q.category = 5, C.org_diff_fee, 0)                                         AS corp_unemployed_amount,
       0                                                                             AS corp_unemployed_rate,
       IF(Q.category = 5, C.emp_diff_fee, 0)                                         AS indv_unemployed_amount,
       0                                                                             AS indv_unemployed_rate,
       IF(Q.category = 7, C.org_diff_fee, 0)                                         AS corp_birth_amount,
       0                                                                             AS corp_birth_rate,
       IF(Q.category = 7, C.emp_diff_fee, 0)                                         AS indv_birth_amount,
       0                                                                             AS indv_birth_rate,
       IF(Q.category = 8 AND Q.ins_code = 80, C.org_diff_fee, 0)                     AS corp_disabled_amount,
       0                                                                             AS corp_disabled_rate,
       IF(Q.category = 8 AND Q.ins_code = 80, C.emp_diff_fee, 0)                     AS indv_disabled_amount,
       0                                                                             AS indv_disabled_rate,
       IF(Q.category = 4 AND Q.ins_code = 43, C.org_diff_fee, 0)                     AS corp_serious_illness_amount,
       0                                                                             AS corp_serious_illness_rate,
       IF(Q.category = 4 AND Q.ins_code = 43, C.emp_diff_fee, 0)                     AS indv_serious_illness_amount,
       0                                                                             AS indv_serious_illness_rate,
       IF(Q.category = 4 AND Q.ins_code = 41, C.org_diff_fee, 0)                     AS corp_ext_illness_amount,
       0                                                                             AS corp_ext_illness_rate,
       IF(Q.category = 4 AND Q.ins_code = 41, C.emp_diff_fee, 0)                     AS indv_ext_illness_amount,
       0                                                                             AS indv_ext_illness_rate,
       IF(Q.category = 4 AND Q.ins_code = 42, C.org_diff_fee, 0)                     AS corp_hospital_amount,
       0                                                                             AS corp_hospital_rate,
       IF(Q.category = 4 AND Q.ins_code = 42, C.emp_diff_fee, 0)                     AS indv_hospital_amount,
       0                                                                             AS indv_hospital_rate,
       IF(Q.category = 2, C.org_diff_fee, 0)                                         AS corp_fund_amount,
       0                                                                             AS corp_fund_rate,
       IF(Q.category = 2, C.emp_diff_fee, 0)                                         AS indv_fund_amount,
       0                                                                             AS indv_fund_rate,
       IF(Q.category = 8 AND Q.ins_code = 90, C.emp_diff_fee, 0)                     AS indv_union_amount,
       IF(Q.category = 8 AND Q.ins_code NOT IN (80, 90), C.emp_diff_fee, 0)          AS indv_other_amount,
       IF(Q.category = 8 AND Q.ins_code NOT IN (80, 90), C.org_diff_fee, 0)          AS corp_other_amount,
       ''                                                                            AS debit_card_no,
       ''                                                                            AS bank_name,
       ''                                                                            AS bank_region,
       ''                                                                            AS tax_corp,
       A.create_time                                                                 AS raw_create_time,
       A.remark                                                                      AS comment,
       ''                                                                            AS raw_order_no,
       REPLACE(UUID(), '-', '')                                                      AS batch_no
FROM ods.trade_center.trade_business_fee_refund_order A
         INNER JOIN ods.trade_center.trade_business_fee_refund_order_detail B
                    ON A.id = B.order_id AND B.valid = 1
         INNER JOIN ods.shebaotong.sbt_emp_diff C
                    ON B.record_id = C.id
         INNER JOIN ods.shebaotong.sbt_employee D
                    ON C.emp_id = D.id
         LEFT JOIN ods.sbt_prod.oprt_boss_organization E
                   ON C.org_id = E.org_id
         INNER JOIN ods.sbt_prod.mbc_member_info F
                    ON C.member_id = F.member_id
         LEFT JOIN ods.sbt_prod.basic_ins_area G
                   ON C.area_id = G.area_id
         LEFT JOIN ods.sbt_prod.mbc_member_product H
                   ON C.member_product_id = H.m_pr_id
         LEFT JOIN ods.sbt_prod.basic_org_product I
                   ON I.pr_id = H.pr_id
         LEFT JOIN ods.shebaotong.sbt_operate_order_ins J
                   ON C.operate_order_ins_id = J.id AND J.latest = 1
         LEFT JOIN ods.shebaotong.sbt_operate_order K
                   ON J.operate_order_id = K.id
         LEFT JOIN ods.sbt_prod.supplier_info L
                   ON K.supplier_id = L.supplier_id
         LEFT JOIN ods.sbt_prod.sys_dictionary_dtl M
                   ON C.service_type = M.dic_value AND M.dic_code = 'PR_SERVICE_TYPE'
         LEFT JOIN ods.shebaotong.sbt_insurance_org N
                   ON C.ins_org_id = N.id
         LEFT JOIN ods.shebaotong.sbt_order_ins O
                   ON C.order_ins_id = O.id
         LEFT JOIN
            (SELECT order_id, max(sipr_tax_rate), max(tax_rate)
      FROM ods.shebaotong.sbt_order_subject
      WHERE fee_type = 1
      GROUP BY order_id) R ON R.order_id = O.order_id
         LEFT JOIN ods.sbt_prod.fnc_receivable_account P
                   ON A.receive_no = P.receive_no
         LEFT JOIN ods.shebaotong.sbt_insurance_item Q
                   ON C.ins_code = Q.ins_code
         LEFT JOIN ods.sbt_prod.fnc_receivable_account S
                   ON A.receive_no = S.receive_no
WHERE (
        (S.order_month = '${report_month}' AND DATE_FORMAT(S.confirm_time, 'yyyyMM') <= '${report_month}')
        OR (S.order_month <= '${report_month}' AND DATE_FORMAT(S.confirm_time, 'yyyyMM') = '${report_month}')
    )
  AND A.business_type = 1
  AND A.state IN (3, 5);