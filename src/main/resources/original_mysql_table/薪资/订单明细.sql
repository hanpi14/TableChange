DELETE
FROM dwd_order_emp_online_mi
WHERE order_type = 8
  AND is_sup = 0
  AND is_extra = 0
  AND data_source IN (1, 10)
  AND is_refund = 0;

INSERT INTO dwd_order_emp_online_mi(data_source,
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
                                    is_discard,
                                    is_ignore,
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
                                    batch_no)
SELECT B.data_source                                                                                    AS data_source,
       B.bill_no                                                                                        AS order_no,
       8                                                                                                AS order_type,
       IF(C.virtual_flag = 0, CASE G.open_invoice_type
                                  WHEN 1 THEN 8
                                  WHEN 2 THEN IF(N.dic_value = '2' OR N.dic_value = '3', 2, 1) END, -1) AS business_type,
       REPLACE(UUID(), _utf8'-', _utf8'')                                                               AS ar_no,
       '202404'                                                                                         AS order_month,
       B.tax_months                                                                                     AS raw_order_month,
       B.paid_months                                                                                    AS fee_month,
       C.member_code                                                                                    AS member_code,
       C.member_name                                                                                    AS member_name,
       D.org_name                                                                                       AS party_b,
       A.emp_name                                                                                       AS emp_name,
       AES_DECRYPT(FROM_BASE64(A.idcard_no), LEFT(UNHEX(SHA1('x^5(8?0bv@d7!*az')), 16))                 AS emp_id_no,
       AES_DECRYPT(FROM_BASE64(IFNULL(A.tel, '')), LEFT(UNHEX(SHA1('x^5(8?0bv@d7!*az')), 16))           AS mobile,
       CASE
           WHEN E.area_name LIKE '%（%' THEN SUBSTRING_INDEX(E.area_name, '（', 1)
           WHEN E.area_name = '重庆WK' THEN '重庆'
           ELSE E.area_name
           END                                                                                        AS region,
       E.area_name                                                                                    AS raw_region,
       CASE
           WHEN S.area_name LIKE '%（%' THEN SUBSTRING_INDEX(S.area_name, '（', 1)
           WHEN S.area_name = '重庆WK' THEN '重庆'
           ELSE S.area_name
           END                                                                                        AS order_region,
       S.area_name                                                                                    AS raw_order_region,
       CONCAT(IF(B.tax_report_rule = '2', '次月报税-', '当月报税-'),
              IF(B.template_type = '01', '正常薪资', IF(B.template_type = '02', '劳务费', '年终奖'))) AS order_item,
       IF(B.data_source = 10, B.tax_rate, B.daishou_tax_rate)                                         AS order_tax_rate,
       B.tax_rate                                                                                     AS reward_tax_rate,
       IF(G.service_type IN (27, 29), 1, 0)                                                           AS is_solo,
       IF(G.service_type IN (27, 29), 0, 1)                                                           AS is_collect,
       IF((B.tax_report_rule = '2' AND B.tax_months < '202404') OR
          (B.tax_report_rule = '1' AND DATE_FORMAT(B.create_time, '%Y%m') < '202404'), 1, 0)          AS is_cross,
       0                                                                                              AS is_refund,
       0                                                                                              AS is_extra,
       0                                                                                              AS is_sup,
       IF(A.handle_type = 2, 1, 0)                                                                    AS is_cancel,
       0                                                                                              AS is_diff,
       0                                                                                              AS is_discard,
       0                                                                                              AS is_ignore,
       CASE G.open_invoice_type WHEN 1 THEN 2 WHEN 2 THEN 1 END                                       AS income_type,
       IF(B.service_tax_flag = 0, ROUND(A.service_charge * (1 + B.tax_rate / 100), 4),
          A.service_charge)                                                                           AS income_reward,
       IF(B.service_tax_flag = 0, ROUND(A.service_charge * (1 + B.tax_rate / 100), 4),
          A.service_charge)                                                                           AS raw_income_reward,
       IF(I.tax_rule = 1, 2, 1)                                                                       AS tax_calc_mode,
       CASE
           WHEN G.service_type = 26 THEN A.payment + IFNULL(A.ghf_fee, 0) + IFNULL(A.cash_deposit, 0)
           WHEN G.service_type = 27 THEN 0
           WHEN G.service_type = 29 THEN 0
           WHEN B.flow_type = 1 AND A.alive_flag = 0 AND B.channel_type = 4 AND A.repeat_flag = 1 THEN A.tax_with_held +
                                                                                                       IFNULL(A.ghf_fee, 0) +
                                                                                                       IFNULL(A.cash_deposit, 0) +
                                                                                                       A.tax_less_fee
           WHEN B.flow_type = 1 AND B.channel_type = 4 AND B.from_bill_id IS NOT NULL AND A.from_payroll_id IS NOT NULL
               THEN A.payment
           ELSE A.payment + A.tax_with_held + IFNULL(A.ghf_fee, 0) + IFNULL(A.cash_deposit, 0) + A.tax_less_fee -
                A.tax_more_fee END                                                                    AS income_order,
       IF(G.service_type = 26, A.payment + IFNULL(A.ghf_fee, 0) + IFNULL(A.cash_deposit, 0),
          A.payment + A.tax_with_held + IFNULL(A.ghf_fee, 0) + IFNULL(A.cash_deposit, 0) + A.tax_less_fee -
          A.tax_more_fee)                                                                             AS raw_income_order,
       0                                                                                              AS income_overdue,
       0                                                                                              AS income_disabled,
       0                                                                                              AS income_added_tax,
       0                                                                                              AS income_stable,
       0                                                                                              AS income_indv_tax,
       1                                                                                              AS serve_count,
       IFNULL(H.supplier_code, '')                                                                    AS supplier_code,
       IFNULL(H.supplier_name, '')                                                                    AS supplier_name,
       1                                                                                              AS cost_type,
       0                                                                                              AS cost_reward,
       ''                                                                                             AS sale_emp_name,
       IFNULL(B.service_emp, -1)                                                                      AS serve_emp_id,
       IFNULL(B.achie_emp, -1)                                                                        AS sale_emp_id,
       IFNULL(B.hr_service_dept, -1)                                                                  AS serve_dept_id,
       IFNULL(B.hr_achie_dept, -1)                                                                    AS sale_dept_id,
       A.revenue_position                                                                             AS order_parm,
       A.payment                                                                                      AS indv_net_pay,
       A.tax_with_held                                                                                AS indv_income_tax,
       0                                                                                              AS income_indv_order,
       0                                                                                              AS income_corp_order,
       0                                                                                              AS corp_pension_amount,
       0                                                                                              AS corp_pension_rate,
       ifnull(A.endowment_insurance, 0)                                                               AS indv_pension_amount,
       0                                                                                              AS indv_pension_rate,
       0                                                                                              AS corp_illness_amount,
       0                                                                                              AS corp_illness_rate,
       ifnull(A.medical_insurance, 0)                                                                 AS indv_illness_amount,
       0                                                                                              AS indv_illness_rate,
       0                                                                                              AS corp_work_amount,
       0                                                                                              AS corp_work_rate,
       0                                                                                              AS indv_work_amount,
       0                                                                                              AS indv_work_rate,
       0                                                                                              AS corp_unemployed_amount,
       0                                                                                              AS corp_unemployed_rate,
       ifnull(A.unemployment_insurance, 0)                                                            AS indv_unemployed_amount,
       0                                                                                              AS indv_unemployed_rate,
       0                                                                                              AS corp_birth_amount,
       0                                                                                              AS corp_birth_rate,
       0                                                                                              AS indv_birth_amount,
       0                                                                                              AS indv_birth_rate,
       0                                                                                              AS corp_disabled_amount,
       0                                                                                              AS corp_disabled_rate,
       ifnull(A.cash_deposit, 0)                                                                      AS indv_disabled_amount,
       0                                                                                              AS indv_disabled_rate,
       0                                                                                              AS corp_serious_illness_amount,
       0                                                                                              AS corp_serious_illness_rate,
       0                                                                                              AS indv_serious_illness_amount,
       0                                                                                              AS indv_serious_illness_rate,
       0                                                                                              AS corp_ext_illness_amount,
       0                                                                                              AS corp_ext_illness_rate,
       0                                                                                              AS indv_ext_illness_amount,
       0                                                                                              AS indv_ext_illness_rate,
       0                                                                                              AS corp_hospital_amount,
       0                                                                                              AS corp_hospital_rate,
       0                                                                                              AS indv_hospital_amount,
       0                                                                                              AS indv_hospital_rate,
       0                                                                                              AS corp_fund_amount,
       0                                                                                              AS corp_fund_rate,
       ifnull(A.housing_fund, 0)                                                                      AS indv_fund_amount,
       0                                                                                              AS indv_fund_rate,
       ifnull(A.ghf_fee, 0)                                                                           AS indv_union_amount,
       0                                                                                              AS indv_other_amount,
       IFNULL(A.bank_card_number, '')                                                                 AS debit_card_no,
       IFNULL(A.bank_name, '')                                                                        AS bank_name,
       IFNULL(A.account_city, '')                                                                     AS bank_region,
       B.tax_org_name                                                                                 AS tax_corp,
       A.create_time                                                                                  AS raw_create_time,
       ''                                                                                             AS comment,
       ''                                                                                             AS raw_order_no,
       IFNULL(B.hro_no, REPLACE(UUID(), _utf8'-', _utf8''))                                           AS batch_no
FROM ods_pay_payroll_emp_20240419 A
         INNER JOIN (SELECT P.*,
                            Q.confirm_time,
                            T.bill_no                                         AS hro_no,
                            T.out_time,
                            IF(P.bill_no = R.order_no AND R.valid = 1, 10, 1) AS data_source
                     FROM ods_pay_payroll_bill_20240419 P
                              LEFT JOIN (SELECT O.bill_id, MIN(O.create_time) AS confirm_time
                                         FROM ods_pay_payroll_deal_record_20240419 O
                                         WHERE O.deal_status = '1'   #处理状态: 0=已驳回,1=已通过，2=已取消
                                           AND NOT EXISTS(SELECT 1
                                                          FROM ods_pay_payroll_deal_record_20240419 V
                                                          WHERE V.bill_id = O.bill_id
                                                            AND V.deal_status = '2'     #处理状态: 0=已驳回,1=已通过，2=已取消)'
                                                          )
                                         GROUP BY O.bill_id) Q ON P.bill_id = Q.bill_id
                              LEFT JOIN ods_hro_bill_constitute_20240419 R ON P.bill_no = R.order_no
                                                                                  AND R.valid = 1   #账单订单构成表: 是否有效(0无效,1有效)
                              LEFT JOIN ods_hro_bill_20240419 T ON R.bill_id = T.id
                                                                       AND T.valid = 1  #HRO账单表: 是否有效(0无效,1有效)
                     WHERE (
                         ((
                              (P.tax_months = '202404' AND P.tax_report_rule = '2' AND DATE_FORMAT(Q.confirm_time, '%Y%m') <= '202404')
                                  OR
                              (P.tax_months < '202404' AND P.tax_report_rule = '2' AND DATE_FORMAT(Q.confirm_time, '%Y%m') = '202404')
                                  OR (P.tax_months =
                                      DATE_FORMAT(
                                              DATE_SUB(STR_TO_DATE(CONCAT('202404', '01'), '%Y%m%d'), INTERVAL 1 MONTH),
                                              '%Y%m') AND P.tax_report_rule = '1' AND
                                      DATE_FORMAT(Q.confirm_time, '%Y%m') <= '202404')
                                  OR
                              (
                                  (P.wirteoff_status = 6 OR (P.wirteoff_status = 7 AND P.receivable_status = 0)) AND (
                                  (P.tax_months = '202404' AND P.tax_report_rule = '2' AND
                                   DATE_FORMAT(P.create_time, '%Y%m') <= '202404')
                                      OR (P.tax_months < '202404' AND P.tax_report_rule = '2' AND
                                          DATE_FORMAT(P.create_time, '%Y%m') = '202404')
                                      OR (P.tax_months =
                                          DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT('202404', '01'), '%Y%m%d'), INTERVAL 1
                                                               MONTH),
                                                      '%Y%m') AND P.tax_report_rule = '1' AND
                                          DATE_FORMAT(P.create_time, '%Y%m') <= '202404')
                                  )
                                  )
                              ) AND T.out_time IS NULL)
                             OR (DATE_FORMAT(T.out_time, '%Y%m') = '202401' AND R.bill_has = 1 AND T.state = 2)
                         )
                       AND P.alive_flag = '1'
                       AND P.import_method = '1'
                       AND (
                         (P.bill_status = '01' AND P.deal_status IN ('0', '1') AND P.flow_type = 0)
                             OR
                         (P.bill_status = '00' AND P.deal_status IN ('0', '1') AND P.flow_type = 1)
                             OR
                         P.bill_status NOT IN ('00', '01')
                         )
                       AND (P.from_bill_id IS NULL OR (P.from_bill_id IS NOT NULL AND P.channel_type = 4))
                       AND P.test_flag = 0
                       AND P.wirteoff_status IN (0, 1, 2, 5, 6, 7)) B ON A.bill_id = B.bill_id
         INNER JOIN ods_mbc_member_info_20240419 C ON A.member_id = C.member_id
         LEFT JOIN ods_oprt_boss_organization_20240419 D ON B.org_id = D.org_id
         LEFT JOIN ods_basic_ins_area_20240419 E ON A.area_code = E.area_code
         LEFT JOIN ods_mbc_member_product_20240419 F ON B.m_pr_id = F.m_pr_id
         LEFT JOIN ods_basic_org_product_20240419 G ON F.pr_id = G.pr_id
         LEFT JOIN ods_supplier_info_20240419 H ON H.supplier_id = B.supplier_id
         LEFT JOIN ods_mbc_member_product_cover_20240419 I
                   ON F.m_pr_id = I.m_pr_id AND A.area_code = I.area_code AND I.alive_flag = '1'
         LEFT JOIN ods_sys_dictionary_dtl_20240419 N
                   ON G.service_type = N.dic_value AND N.dic_code = 'PR_SERVICE_TYPE'
         LEFT JOIN ods_basic_ins_area_20240419 S ON B.area_code = S.area_code
--    LEFT JOIN ods_hro_bill_constitute_20230616 J ON B.bill_no=J.order_no AND J.valid=1
--    LEFT JOIN ods_hro_bill_20230616 K ON J.bill_id=K.id AND K.valid=1
WHERE IF(F.service_code = 'hro' AND B.out_time IS NULL, 0, 1) = 1;