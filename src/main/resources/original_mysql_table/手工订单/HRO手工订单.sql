DELETE
FROM dwd_order_emp_online_mi
WHERE order_type = 32
  AND business_type = 64
  AND data_source = -1
  AND is_sup = 0
  AND is_extra = 0
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
                                    tax_calc_mode,
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
                                    corp_other_amount,
                                    indv_other_amount,
                                    debit_card_no,
                                    bank_name,
                                    bank_region,
                                    tax_corp,
                                    raw_create_time,
                                    comment,
                                    raw_order_no,
                                    batch_no)
SELECT -1                                                       AS data_source,
       A.order_no                                               AS order_no,
        32                                                       AS order_type,
       64                                                       AS business_type,
       A.ar_no                                                  AS ar_no,
       '202308'                                                 AS order_month,
       IFNULL(A.order_month, '202308')                          AS raw_order_month,
       IFNULL(A.fee_month, '202308')                            AS fee_month,
       G.member_code                                            AS member_code,
       G.member_name                                            AS member_name,
       E.org_name                                               AS party_b,
       A.emp_name                                               AS emp_name,
       A.emp_id_no                                              AS emp_id_no,
       ''                                                       AS mobile,
       CASE
           WHEN S.area_name IS NULL THEN '全国'
           WHEN S.area_name LIKE '%（%' THEN SUBSTRING_INDEX(S.area_name, '（', 1)
           WHEN S.area_name = '重庆WK' THEN '重庆'
           ELSE S.area_name
           END                                                  AS region,
       IFNULL(S.area_name, '全国')                              AS raw_region,
       CASE
           WHEN S.area_name IS NULL THEN '全国'
           WHEN S.area_name LIKE '%（%' THEN SUBSTRING_INDEX(S.area_name, '（', 1)
           WHEN S.area_name = '重庆WK' THEN '重庆'
           ELSE S.area_name
           END                                                  AS order_region,
       IFNULL(S.area_name, '全国')                              AS raw_order_region,
       A.order_item                                             AS order_item,
       C.daishou_tax_rate                                       AS order_tax_rate,
       C.tax_rate                                               AS reward_tax_rate,
       IF(C.single_flag = 1, 1, 0)                              AS is_solo,
       1                                                        AS tax_calc_mode,
       IF(C.single_flag = 1, 0, 1)                              AS is_collect,
       IF(A.order_month != '202308', 1, 0)                      AS is_cross,
       0                                                        AS is_refund,
       0                                                        AS is_extra,
       0                                                        AS is_sup,
       0                                                        AS is_cancel,
       0                                                        AS is_diff,
       0                                                        AS is_ignore,
       0                                                        AS is_discard,
       CASE D.open_invoice_type WHEN 1 THEN 2 WHEN 2 THEN 1 END AS income_type,
       ROUND(A.income_reward - ROUND(
                       (A.income_order_payroll + A.income_order_disabled + A.income_order_tax + A.income_order_other +
                        A.income_order_welfare) *
                       C.daishou_tax_rate / 100, 2), 2)                 AS income_reward,
       A.income_reward                                          AS raw_income_reward,
       A.income_order_payroll + A.income_order_tax + A.income_order_disabled + A.income_order_other +
       A.income_order_type_2 + A.income_order_type_1 + A.income_order_type_1_disabled + A.income_order_welfare
           AS income_order,
       A.income_order_payroll + A.income_order_tax + A.income_order_disabled + A.income_order_other +
       A.income_order_type_2 + A.income_order_type_1 + A.income_order_type_1_disabled + A.income_order_welfare
           AS raw_income_order,
       0                                                        AS income_overdue,
       0                                                        AS income_disabled,
       0                                                        AS income_added_tax,
       0                                                        AS income_stable,
       0                                                        AS income_indv_tax,
       1                                                        AS serve_count,
       ''                                                       AS supplier_code,
       ''                                                       AS supplier_name,
       1                                                        AS cost_type,
       0                                                        AS cost_reward,
       ''                                                       AS sale_emp_name,
       IFNULL(C.service_emp, -1)                                AS serve_emp_id,
       IFNULL(C.achie_emp, -1)                                  AS sale_emp_id,
       IFNULL(C.hr_service_dept, -1)                            AS serve_dept_id,
       IFNULL(C.hr_achie_dept, -1)                              AS sale_dept_id,
       0                                                        AS order_parm,
       0                                                        AS indv_net_pay,
       A.income_order_tax                                       AS indv_income_tax,
       0                                                        AS income_indv_order,
       0                                                        AS income_corp_order,
       0                                                        AS corp_pension_amount,
       0                                                        AS corp_pension_rate,
       0                                                        AS indv_pension_amount,
       0                                                        AS indv_pension_rate,
       0                                                        AS corp_illness_amount,
       0                                                        AS corp_illness_rate,
       0                                                        AS indv_illness_amount,
       0                                                        AS indv_illness_rate,
       0                                                        AS corp_work_amount,
       0                                                        AS corp_work_rate,
       0                                                        AS indv_work_amount,
       0                                                        AS indv_work_rate,
       0                                                        AS corp_unemployed_amount,
       0                                                        AS corp_unemployed_rate,
       0                                                        AS indv_unemployed_amount,
       0                                                        AS indv_unemployed_rate,
       0                                                        AS corp_birth_amount,
       0                                                        AS corp_birth_rate,
       0                                                        AS indv_birth_amount,
       0                                                        AS indv_birth_rate,
       0                                                        AS corp_disabled_amount,
       0                                                        AS corp_disabled_rate,
       A.income_order_disabled                                  AS indv_disabled_amount,
       0                                                        AS indv_disabled_rate,
       0                                                        AS corp_serious_illness_amount,
       0                                                        AS corp_serious_illness_rate,
       0                                                        AS indv_serious_illness_amount,
       0                                                        AS indv_serious_illness_rate,
       0                                                        AS corp_ext_illness_amount,
       0                                                        AS corp_ext_illness_rate,
       0                                                        AS indv_ext_illness_amount,
       0                                                        AS indv_ext_illness_rate,
       0                                                        AS corp_hospital_amount,
       0                                                        AS corp_hospital_rate,
       0                                                        AS indv_hospital_amount,
       0                                                        AS indv_hospital_rate,
       0                                                        AS corp_fund_amount,
       0                                                        AS corp_fund_rate,
       0                                                        AS indv_fund_amount,
       0                                                        AS indv_fund_rate,
       0                                                        AS indv_union_amount,
       0                                                        AS corp_other_amount,
       A.income_order_other                                     AS indv_other_amount,
       0                                                        AS debit_card_no,
       ''                                                       AS bank_name,
       ''                                                       AS bank_region,
       ''                                                       AS tax_corp,
       A.create_time                                            AS raw_create_time,
       A.memo                                                   AS comment,
       ''                                                       AS raw_order_no,
       REPLACE(UUID(), _utf8'-', _utf8'')                       AS batch_no
FROM (SELECT O.order_code                                               AS order_no,
             O.receive_no                                               AS ar_no,
             O.create_time,
             O.memo,
             O.name                                                     AS order_item,
             O.member_product_id,
             O.contract_company_id,
             O.member_id,
             O.city_code,
             DATE_FORMAT(IF(O.order_month = '', IF(O.order_date = '', O.order_start_date, O.order_date),
                            CONCAT(O.order_month, '-01')),
                         '%Y%m')                                        AS order_month,
             P.name                                                     AS emp_name,
             AES_DECRYPT(FROM_BASE64(P.cert_no),
                         LEFT(UNHEX(SHA1('eyHXTWVo&B69')), 16))         AS emp_id_no,
             IFNULL(IF(O.detail_title ->> '$\[3\]' = '费用月份(示例: 2021-01)',
                       DATE_FORMAT(CONCAT(P.detail_data ->> '$\[3\]', '-01'),
                                   '%Y%m'), NULL), DATE_FORMAT(CONCAT(O.order_month, '-01'),
                                                               '%Y%m')) AS fee_month,
             IF(O.detail_title ->> '$\[14\]' = 'HRO服务费-外包服务费金额', P.detail_data ->> '$\[14\]' + 0,
                0)                                                      AS income_reward,
             IF(O.detail_title ->> '$\[4\]' = 'HRO服务费-薪资金额', P.detail_data ->> '$\[4\]' + 0,
                0)                                                      AS income_order_payroll,
             IF(O.detail_title ->> '$\[5\]' = 'HRO服务费-薪资残保金金额', P.detail_data ->> '$\[5\]' + 0,
                0)                                                      AS income_order_disabled,
             IF(O.detail_title ->> '$\[6\]' = 'HRO服务费-薪资个税金额', P.detail_data ->> '$\[6\]' + 0,
                0)                                                      AS income_order_tax,
             IF(O.detail_title ->> '$\[8\]' = 'HRO服务费-其他金额', P.detail_data ->> '$\[8\]' + 0,
                0)                                                      AS income_order_other,
             IF(O.detail_title ->> '$\[10\]' = 'HRO服务费-公积金金额', P.detail_data ->> '$\[10\]' + 0,
                0)                                                      AS income_order_type_2,
             IF(O.detail_title ->> '$\[9\]' = 'HRO服务费-社保金额', P.detail_data ->> '$\[9\]' + 0,
                0)                                                      AS income_order_type_1,
             IF(O.detail_title ->> '$\[11\]' = 'HRO服务费-社保残保金金额', P.detail_data ->> '$\[11\]' + 0,
                0)                                                      AS income_order_type_1_disabled,
             IF(O.detail_title ->> '$\[13\]' = 'HRO服务费-员工福利金额', P.detail_data ->> '$\[13\]' + 0,
                0)                                                      AS income_order_welfare
      FROM ods_trade_business_order_20240411 O
               INNER JOIN ods_trade_business_order_detail_20240411 P
                          ON O.id
                                 = P.order_id
                              AND P.valid = 1
      WHERE O.create_order = 1
        AND (O.order_month != '' OR O.order_date != '' OR O.order_start_date != '')
        AND ((DATE_FORMAT(IF(O.order_month = '', IF(O.order_date = '', O.order_start_date, O.order_date),
                             CONCAT(O.order_month, '-01')), '%Y%m') <= '202308'
          AND DATE_FORMAT(O.confirm_time, '%Y%m') = '202308') OR
             (DATE_FORMAT(IF(O.order_month = '', IF(O.order_date = '', O.order_start_date, O.order_date),
                             CONCAT(O.order_month, '-01')), '%Y%m') = '202308'
                 AND DATE_FORMAT(O.confirm_time, '%Y%m') <= '202308'))
        AND O.test_flag = 0
        AND O.audit_state = 3
        AND O.order_state != 5
        AND O.product_name IN ('HRO')
        AND O.memo NOT LIKE '%补录%') A
         LEFT JOIN ods_mbc_member_product_20240410 C
                   ON A.member_product_id
                       = C.m_pr_id
         LEFT JOIN ods_basic_org_product_20240410 D
                   ON C.pr_id
                       = D.pr_id
         LEFT JOIN ods_oprt_boss_organization_20240410 E
ON E.org_id
    = A.contract_company_id
    INNER JOIN ods_mbc_member_info_20240410 G
                    ON A.member_id
                        = G.member_id
         LEFT JOIN ods_sys_dictionary_dtl_20240410 N
                   ON D.service_type
                          = N.dic_value
                       AND N.dic_code = 'PR_SERVICE_TYPE'
         LEFT JOIN ods_basic_ins_area_20240410 S
                   ON A.city_code
                       = S.area_code;
