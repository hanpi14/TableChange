DELETE
FROM dw.dwd.dwd_order_emp_online_!{load_freq}i
WHERE order_type = 8
  AND data_source = -1
  AND is_sup = 0
  AND is_extra = 0
  AND is_refund = 0;

INSERT INTO dw.dwd.dwd_order_emp_online_!{load_freq}i(data_source, order_no, order_type, business_type, ar_no, order_month,
                                                      raw_order_month, fee_month,
                                                      member_code, member_name,
                                                      party_b,
                                                      emp_name, emp_id_no, mobile, region, raw_region, order_region,
                                                      raw_order_region,
                                                      order_item,
                                                      order_tax_rate,
                                                      reward_tax_rate, is_solo, tax_calc_mode,
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
                                                      income_stable, income_indv_tax, serve_count, supplier_code, supplier_name,
                                                      cost_type,
                                                      cost_reward,
                                                      sale_emp_name,
                                                      serve_emp_id,
                                                      sale_emp_id, serve_dept_id, sale_dept_id, order_parm, indv_net_pay,
                                                      indv_income_tax,
                                                      income_indv_order,
                                                      income_corp_order, corp_pension_amount, corp_pension_rate,
                                                      indv_pension_amount,
                                                      indv_pension_rate, corp_illness_amount, corp_illness_rate,
                                                      indv_illness_amount,
                                                      indv_illness_rate, corp_work_amount, corp_work_rate, indv_work_amount,
                                                      indv_work_rate,
                                                      corp_unemployed_amount, corp_unemployed_rate, indv_unemployed_amount,
                                                      indv_unemployed_rate,
                                                      corp_birth_amount, corp_birth_rate, indv_birth_amount, indv_birth_rate,
                                                      corp_disabled_amount,
                                                      corp_disabled_rate, indv_disabled_amount, indv_disabled_rate,
                                                      corp_serious_illness_amount,
                                                      corp_serious_illness_rate, indv_serious_illness_amount,
                                                      indv_serious_illness_rate,
                                                      corp_ext_illness_amount, corp_ext_illness_rate, indv_ext_illness_amount,
                                                      indv_ext_illness_rate,
                                                      corp_hospital_amount, corp_hospital_rate, indv_hospital_amount,
                                                      indv_hospital_rate,
                                                      corp_fund_amount, corp_fund_rate, indv_fund_amount, indv_fund_rate,
                                                      indv_union_amount,
                                                      corp_other_amount,
                                                      indv_other_amount, debit_card_no, bank_name, bank_region, tax_corp,
                                                      raw_create_time,
                                                      comment, raw_order_no, batch_no)
SELECT -1                                                                  AS data_source,
       A.order_no                                                          AS order_no,
       8                                                                   AS order_type,
       IF(G.virtual_flag = 0, CASE D.open_invoice_type
                                  WHEN 1 THEN 8
                                  WHEN 2 THEN IF(N.dic_value = '2' OR N.dic_value = '3', 2, 1) END,
          -1)                                                              AS business_type,
       A.ar_no                                                             AS ar_no,
       '${report_month}'                                                            AS order_month,
       IFNULL(A.order_month, '${report_month}')                                     AS raw_order_month,
       IFNULL(DATE_FORMAT(CONCAT(B.tax_month, '-01'), 'yyyyMM'), '${report_month}') AS fee_month,
       G.member_code                                                       AS member_code,
       G.member_name                                                       AS member_name,
       E.org_name                                                          AS party_b,
       B.name                                                              AS emp_name,
       B.cert_no                                                           AS emp_id_no,
       B.mobile                                                            AS mobile,
       CASE
           WHEN B.area_name IS NULL THEN '全国'
           WHEN B.area_name LIKE '%（%' THEN SUBSTRING_INDEX(B.area_name, '（', 1)
           WHEN B.area_name = '重庆WK' THEN '重庆'
           ELSE B.area_name
           END                                                             AS region,
       IFNULL(B.area_name, '全国')                                         AS raw_region,
       CASE
           WHEN S.area_name IS NULL THEN '全国'
           WHEN S.area_name LIKE '%（%' THEN SUBSTRING_INDEX(S.area_name, '（', 1)
           WHEN S.area_name = '重庆WK' THEN '重庆'
           ELSE S.area_name
           END                                                             AS order_region,
       IFNULL(S.area_name, '全国')                                         AS raw_order_region,
       CASE
           WHEN B.xz_type = 1 THEN '正常薪资'
           WHEN B.xz_type = 2 THEN '年终奖'
           WHEN B.xz_type = 3 THEN '劳务工资'
           ELSE '其他'
           END                                                             AS order_item,
       C.daishou_tax_rate                                                  AS order_tax_rate,
       C.tax_rate                                                          AS reward_tax_rate,
       IF(C.single_flag = 1, 1, 0)                                         AS is_solo,
       1                                                                   AS tax_calc_mode,
       IF(C.single_flag = 1, 0, 1)                                         AS is_collect,
       IF(A.order_month != '${report_month}', 1, 0)                                 AS is_cross,
       0                                                                   AS is_refund,
       0                                                                   AS is_extra,
       0                                                                   AS is_sup,
       0                                                                   AS is_cancel,
       0                                                                   AS is_diff,
       0                                                                   AS is_ignore,
       0                                                                   AS is_discard,
       CASE D.open_invoice_type WHEN 1 THEN 2 WHEN 2 THEN 1 END            AS income_type,
       B.fuwufei / 10000                                                   AS income_reward,
       B.fuwufei / 10000                                                   AS raw_income_reward,
       IF(C.single_flag = 1, 0, B.pre_tax_income / 10000)                  AS income_order,
       B.pre_tax_income / 10000                                            AS raw_income_order,
       0                                                                   AS income_overdue,
       0                                                                   AS income_disabled,
       0                                                                   AS income_added_tax,
       0                                                                   AS income_stable,
       0                                                                   AS income_indv_tax,
       1                                                                   AS serve_count,
       IFNULL(F.supplier_code, '')                                         AS supplier_code,
       IFNULL(F.supplier_name, '')                                         AS supplier_name,
       1                                                                   AS cost_type,
       0                                                                   AS cost_reward,
       ''                                                                  AS sale_emp_name,
       IFNULL(C.service_emp, -1)                                           AS serve_emp_id,
       IFNULL(C.achie_emp, -1)                                             AS sale_emp_id,
       IFNULL(C.hr_service_dept, -1)                                       AS serve_dept_id,
       IFNULL(C.hr_achie_dept, -1)                                         AS sale_dept_id,
       B.shourue / 10000                                                   AS order_parm,
       B.real_wage / 10000                                                 AS indv_net_pay,
       B.tax_amount / 10000                                                AS indv_income_tax,
       0                                                                   AS income_indv_order,
       0                                                                   AS income_corp_order,
       0                                                                   AS corp_pension_amount,
       0                                                                   AS corp_pension_rate,
       B.yanglao_baoxian / 10000                                           AS indv_pension_amount,
       0                                                                   AS indv_pension_rate,
       0                                                                   AS corp_illness_amount,
       0                                                                   AS corp_illness_rate,
       B.yiliao_baoxian / 10000                                            AS indv_illness_amount,
       0                                                                   AS indv_illness_rate,
       0                                                                   AS corp_work_amount,
       0                                                                   AS corp_work_rate,
       0                                                                   AS indv_work_amount,
       0                                                                   AS indv_work_rate,
       0                                                                   AS corp_unemployed_amount,
       0                                                                   AS corp_unemployed_rate,
       B.shiye_baoxian / 10000                                             AS indv_unemployed_amount,
       0                                                                   AS indv_unemployed_rate,
       0                                                                   AS corp_birth_amount,
       0                                                                   AS corp_birth_rate,
       0                                                                   AS indv_birth_amount,
       0                                                                   AS indv_birth_rate,
       0                                                                   AS corp_disabled_amount,
       0                                                                   AS corp_disabled_rate,
       B.canbaojin / 10000                                                 AS indv_disabled_amount,
       0                                                                   AS indv_disabled_rate,
       0                                                                   AS corp_serious_illness_amount,
       0                                                                   AS corp_serious_illness_rate,
       0                                                                   AS indv_serious_illness_amount,
       0                                                                   AS indv_serious_illness_rate,
       0                                                                   AS corp_ext_illness_amount,
       0                                                                   AS corp_ext_illness_rate,
       0                                                                   AS indv_ext_illness_amount,
       0                                                                   AS indv_ext_illness_rate,
       0                                                                   AS corp_hospital_amount,
       0                                                                   AS corp_hospital_rate,
       0                                                                   AS indv_hospital_amount,
       0                                                                   AS indv_hospital_rate,
       0                                                                   AS corp_fund_amount,
       0                                                                   AS corp_fund_rate,
       B.gongjijin / 10000                                                 AS indv_fund_amount,
       0                                                                   AS indv_fund_rate,
       B.gonghuifei / 10000                                                AS indv_union_amount,
       0                                                                   AS corp_other_amount,
       B.shebao_qita / 10000                                               AS indv_other_amount,
       B.bank_card_no                                                      AS debit_card_no,
       ''                                                                  AS bank_name,
       ''                                                                  AS bank_region,
       ''                                                                  AS tax_corp,
       A.create_time                                                       AS raw_create_time,
       A.memo                                                              AS comment,
       ''                                                                  AS raw_order_no,
       REPLACE(UUID(), '-', '')                                            AS batch_no
FROM (SELECT O.id,
             O.member_product_id,
             O.contract_company_id,
             O.member_id,
             O.city_code,
             O.order_code                                            AS order_no,
             O.receive_no                                            AS ar_no,
             DATE_FORMAT(IF(O.order_month = '', IF(O.order_date = '', O.order_start_date, O.order_date),
                            CONCAT(O.order_month, '-01')), 'yyyyMM') AS order_month,
             O.name                                                  AS order_item,
             O.create_time,
             O.memo
      FROM (ods.trade_center.trade_business_order FOR SYSTEM_TIME AS OF '${snap_date}') O
      WHERE O.create_order = 1
        AND (O.order_month != '' OR O.order_date != '' OR O.order_start_date != '')
        AND ((DATE_FORMAT(IF(O.order_month = '', IF(O.order_date = '', O.order_start_date, O.order_date),
                             CONCAT(O.order_month, '-01')), 'yyyyMM') <= '${report_month}'
          AND DATE_FORMAT(O.confirm_time, 'yyyyMM') = '${report_month}') OR
             (DATE_FORMAT(IF(O.order_month = '', IF(O.order_date = '', O.order_start_date, O.order_date),
                             CONCAT(O.order_month, '-01')), 'yyyyMM') = '${report_month}'
                 AND DATE_FORMAT(O.confirm_time, 'yyyyMM') <= '${report_month}'))
        AND O.test_flag = 0
        AND O.service_type = 1
        AND O.audit_state = 3
        AND O.order_state != 5
        AND O.memo NOT LIKE '%补录%') A
         INNER JOIN (ods.trade_center.trade_business_order_xzpeople FOR SYSTEM_TIME AS OF '${snap_date}') B
                    ON A.id = B.order_id AND B.valid = 1
         LEFT JOIN (ods.sbt_prod.mbc_member_product FOR SYSTEM_TIME AS OF '${snap_date}') C
                   ON A.member_product_id = C.m_pr_id
         LEFT JOIN (ods.sbt_prod.basic_org_product FOR SYSTEM_TIME AS OF '${snap_date}') D ON C.pr_id = D.pr_id
         LEFT JOIN (ods.sbt_prod.oprt_boss_organization FOR SYSTEM_TIME AS OF '${snap_date}') E
                   ON E.org_id = A.contract_company_id
         LEFT JOIN (ods.sbt_prod.supplier_info FOR SYSTEM_TIME AS OF '${snap_date}') F
                   ON B.supplier_id = F.supplier_id
         INNER JOIN (ods.sbt_prod.mbc_member_info FOR SYSTEM_TIME AS OF '${snap_date}') G ON A.member_id = G.member_id
         LEFT JOIN (ods.sbt_prod.sys_dictionary_dtl FOR SYSTEM_TIME AS OF '${snap_date}') N
                   ON D.service_type = N.dic_value AND N.dic_code = 'PR_SERVICE_TYPE'
         LEFT JOIN (ods.sbt_prod.basic_ins_area FOR SYSTEM_TIME AS OF '${snap_date}') S ON A.city_code = S.area_code;


union all
SELECT -1                                                                    AS data_source,
       A.order_no                                                            AS order_no,
       8                                                                     AS order_type,
       IF(G.virtual_flag = 0, CASE D.open_invoice_type
                                  WHEN 1 THEN 8
                                  WHEN 2 THEN IF(N.dic_value = '2' OR N.dic_value = '3', 2, 1) END,
          -1)                                                                AS business_type,
       A.ar_no                                                               AS ar_no,
       '${report_month}'                                                              AS order_month,
       IFNULL(A.order_month, '${report_month}')                                       AS raw_order_month,
       IFNULL(A.fee_month, '${report_month}')                                         AS fee_month,
       G.member_code                                                         AS member_code,
       G.member_name                                                         AS member_name,
       E.org_name                                                            AS party_b,
       A.emp_name                                                            AS emp_name,
       A.emp_id_no                                                           AS emp_id_no,
       ''                                                                    AS mobile,
       CASE
           WHEN S.area_name IS NULL THEN '全国'
           WHEN S.area_name LIKE '%（%' THEN SUBSTRING_INDEX(S.area_name, '（', 1)
           WHEN S.area_name = '重庆WK' THEN '重庆'
           ELSE S.area_name
           END                                                               AS region,
       IFNULL(S.area_name, '全国')                                           AS raw_region,
       CASE
           WHEN S.area_name IS NULL THEN '全国'
           WHEN S.area_name LIKE '%（%' THEN SUBSTRING_INDEX(S.area_name, '（', 1)
           WHEN S.area_name = '重庆WK' THEN '重庆'
           ELSE S.area_name
           END                                                               AS order_region,
       IFNULL(S.area_name, '全国')                                           AS raw_order_region,
       A.order_item                                                          AS order_item,
       C.daishou_tax_rate                                                    AS order_tax_rate,
       C.tax_rate                                                            AS reward_tax_rate,
       IF(C.single_flag = 1, 1, 0)                                           AS is_solo,
       1                                                                     AS tax_calc_mode,
       IF(C.single_flag = 1, 0, 1)                                           AS is_collect,
       IF(A.order_month != '${report_month}', 1, 0)                                   AS is_cross,
       0                                                                     AS is_refund,
       0                                                                     AS is_extra,
       0                                                                     AS is_sup,
       0                                                                     AS is_cancel,
       0                                                                     AS is_diff,
       0                                                                     AS is_ignore,
       0                                                                     AS is_discard,
       CASE D.open_invoice_type WHEN 1 THEN 2 WHEN 2 THEN 1 END              AS income_type,
       A.income_reward_type_1 + A.income_reward_type_8                       AS income_reward,
       A.income_reward_type_1 + A.income_reward_type_8                       AS raw_income_reward,
       A.income_order_type_1 + A.income_order_type_2 + A.income_order_type_8 AS income_order,
       A.income_order_type_1 + A.income_order_type_2 + A.income_order_type_8 AS raw_income_order,
       0                                                                     AS income_overdue,
       0                                                                     AS income_disabled,
       0                                                                     AS income_added_tax,
       0                                                                     AS income_stable,
       0                                                                     AS income_indv_tax,
       1                                                                     AS serve_count,
       ''                                                                    AS supplier_code,
       ''                                                                    AS supplier_name,
       1                                                                     AS cost_type,
       0                                                                     AS cost_reward,
       ''                                                                    AS sale_emp_name,
       IFNULL(C.service_emp, -1)                                             AS serve_emp_id,
       IFNULL(C.achie_emp, -1)                                               AS sale_emp_id,
       IFNULL(C.hr_service_dept, -1)                                         AS serve_dept_id,
       IFNULL(C.hr_achie_dept, -1)                                           AS sale_dept_id,
       0                                                                     AS order_parm,
       0                                                                     AS indv_net_pay,
       A.income_tax_type_8                                                   AS indv_income_tax,
       0                                                                     AS income_indv_order,
       0                                                                     AS income_corp_order,
       0                                                                     AS corp_pension_amount,
       0                                                                     AS corp_pension_rate,
       0                                                                     AS indv_pension_amount,
       0                                                                     AS indv_pension_rate,
       0                                                                     AS corp_illness_amount,
       0                                                                     AS corp_illness_rate,
       0                                                                     AS indv_illness_amount,
       0                                                                     AS indv_illness_rate,
       0                                                                     AS corp_work_amount,
       0                                                                     AS corp_work_rate,
       0                                                                     AS indv_work_amount,
       0                                                                     AS indv_work_rate,
       0                                                                     AS corp_unemployed_amount,
       0                                                                     AS corp_unemployed_rate,
       0                                                                     AS indv_unemployed_amount,
       0                                                                     AS indv_unemployed_rate,
       0                                                                     AS corp_birth_amount,
       0                                                                     AS corp_birth_rate,
       0                                                                     AS indv_birth_amount,
       0                                                                     AS indv_birth_rate,
       A.income_order_type_1_disabled + A.income_order_type_8_disabled       AS corp_disabled_amount,
       0                                                                     AS corp_disabled_rate,
       0                                                                     AS indv_disabled_amount,
       0                                                                     AS indv_disabled_rate,
       0                                                                     AS corp_serious_illness_amount,
       0                                                                     AS corp_serious_illness_rate,
       0                                                                     AS indv_serious_illness_amount,
       0                                                                     AS indv_serious_illness_rate,
       0                                                                     AS corp_ext_illness_amount,
       0                                                                     AS corp_ext_illness_rate,
       0                                                                     AS indv_ext_illness_amount,
       0                                                                     AS indv_ext_illness_rate,
       0                                                                     AS corp_hospital_amount,
       0                                                                     AS corp_hospital_rate,
       0                                                                     AS indv_hospital_amount,
       0                                                                     AS indv_hospital_rate,
       0                                                                     AS corp_fund_amount,
       0                                                                     AS corp_fund_rate,
       0                                                                     AS indv_fund_amount,
       0                                                                     AS indv_fund_rate,
       A.income_order_union                                                  AS indv_union_amount,
       0                                                                     AS corp_other_amount,
       0                                                                     AS indv_other_amount,
       0                                                                     AS debit_card_no,
       ''                                                                    AS bank_name,
       ''                                                                    AS bank_region,
       ''                                                                    AS tax_corp,
       A.create_time                                                         AS raw_create_time,
       A.memo                                                                AS comment,
       ''                                                                    AS raw_order_no,
       REPLACE(UUID(), '-', '')                                              AS batch_no
FROM (SELECT O.order_code                                                             AS order_no,
             O.receive_no                                                             AS ar_no,
             O.create_time,
             O.city_code,
             O.memo,
             O.name                                                                   AS order_item,
             O.member_product_id,
             O.contract_company_id,
             O.member_id,
             DATE_FORMAT(IF(O.order_month = '', IF(O.order_date = '', O.order_start_date, O.order_date),
                            CONCAT(O.order_month, '-01')),
                         'yyyyMM')                                                    AS order_month,
             IFNULL(
                     IF(element_at(from_json(O.detail_title, 'array<string>'), 4) = '费用月份(示例: 2021-01)',
                        DATE_FORMAT(CONCAT(element_at(from_json(P.detail_data, 'array<string>'), 4), '-01'), 'yyyyMM'),
                        NULL),
                     DATE_FORMAT(CONCAT(O.order_month, '-01'), 'yyyyMM'))             AS fee_month,
             P.name                                                                   AS emp_name,
             P.cert_no                                                                AS emp_id_no,
             IF(element_at(from_json(O.detail_title, 'array<string>'), 5) = '劳务派遣社保金额',
                element_at(from_json(P.detail_data, 'array<string>'), 5) + 0,
                IF(element_at(from_json(O.detail_title, 'array<string>'), 10) = '劳务派遣社保金额',
                   element_at(from_json(P.detail_data, 'array<string>'), 10) + 0, 0)) AS income_order_type_1,
             IF(element_at(from_json(O.detail_title, 'array<string>'), 6) = '劳务派遣公积金金额',
                element_at(from_json(P.detail_data, 'array<string>'), 6) + 0,
                IF(element_at(from_json(O.detail_title, 'array<string>'), 11) = '劳务派遣公积金金额',
                   element_at(from_json(P.detail_data, 'array<string>'), 11) + 0, 0)) AS income_order_type_2,
             IF(element_at(from_json(O.detail_title, 'array<string>'), 7) = '劳务派遣社保服务费金额',
                element_at(from_json(P.detail_data, 'array<string>'), 7) + 0,
                IF(element_at(from_json(O.detail_title, 'array<string>'), 12) = '劳务派遣社保服务费金额',
                   element_at(from_json(P.detail_data, 'array<string>'), 12) + 0, 0)) AS income_reward_type_1,
             IF(element_at(from_json(O.detail_title, 'array<string>'), 8) = '劳务派遣社保残疾人保障金金额',
                element_at(from_json(P.detail_data, 'array<string>'), 8) + 0,
                IF(element_at(from_json(O.detail_title, 'array<string>'), 13) = '劳务派遣社保残疾人保障金金额',
                   element_at(from_json(P.detail_data, 'array<string>'), 13) + 0, 0)) AS income_order_type_1_disabled,
             IF(element_at(from_json(O.detail_title, 'array<string>'), 9) = '劳务派遣薪资金额',
                element_at(from_json(P.detail_data, 'array<string>'), 9) + 0,
                IF(element_at(from_json(O.detail_title, 'array<string>'), 5) = '劳务派遣薪资金额',
                   element_at(from_json(P.detail_data, 'array<string>'), 5) + 0, 0))  AS income_order_type_8,
             IF(element_at(from_json(O.detail_title, 'array<string>'), 10) = '劳务派遣薪资残疾人保障金金额',
                element_at(from_json(P.detail_data, 'array<string>'), 10) + 0,
                IF(element_at(from_json(O.detail_title, 'array<string>'), 7) = '劳务派遣薪资残疾人保障金金额',
                   element_at(from_json(P.detail_data, 'array<string>'), 7) + 0, 0))  AS income_order_type_8_disabled,
             IF(element_at(from_json(O.detail_title, 'array<string>'), 11) = '劳务派遣薪资个税金额',
                element_at(from_json(P.detail_data, 'array<string>'), 11) + 0,
                IF(element_at(from_json(O.detail_title, 'array<string>'), 6) = '劳务派遣薪资个税金额',
                   element_at(from_json(P.detail_data, 'array<string>'), 6) + 0, 0))  AS income_tax_type_8,
             IF(element_at(from_json(O.detail_title, 'array<string>'), 12) = '劳务派遣工会经费金额',
                element_at(from_json(P.detail_data, 'array<string>'), 12) + 0,
                IF(element_at(from_json(O.detail_title, 'array<string>'), 8) = '劳务派遣工会经费金额',
                   element_at(from_json(P.detail_data, 'array<string>'), 8) + 0, 0))  AS income_order_union,
             IF(element_at(from_json(O.detail_title, 'array<string>'), 13) = '劳务派遣薪资服务费金额',
                element_at(from_json(P.detail_data, 'array<string>'), 13) + 0,
                IF(element_at(from_json(O.detail_title, 'array<string>'), 9) = '劳务派遣薪资服务费金额',
                   element_at(from_json(P.detail_data, 'array<string>'), 9) + 0, 0))  AS income_reward_type_8
      FROM (ods.trade_center.trade_business_order FOR SYSTEM_TIME AS OF '${snap_date}') O
               INNER JOIN (ods.trade_center.trade_business_order_detail FOR SYSTEM_TIME AS OF '${snap_date}') P
                          ON O.id = P.order_id AND P.valid = 1
      WHERE O.create_order = 1
        AND (O.order_month != '' OR O.order_date != '' OR O.order_start_date != '')
        AND ((DATE_FORMAT(IF(O.order_month = '', IF(O.order_date = '', O.order_start_date, O.order_date),
                             CONCAT(O.order_month, '-01')), 'yyyyMM') <= '${report_month}'
          AND DATE_FORMAT(O.confirm_time, 'yyyyMM') = '${report_month}') OR
             (DATE_FORMAT(IF(O.order_month = '', IF(O.order_date = '', O.order_start_date, O.order_date),
                             CONCAT(O.order_month, '-01')), 'yyyyMM') = '${report_month}'
                 AND DATE_FORMAT(O.confirm_time, 'yyyyMM') <= '${report_month}'))
        AND O.test_flag = 0
        AND O.audit_state = 3
        AND O.order_state != 5
        AND O.product_name IN ('社保薪资通')
        AND O.memo NOT LIKE '%补录%') A
         LEFT JOIN (ods.sbt_prod.mbc_member_product FOR SYSTEM_TIME AS OF '${snap_date}') C
                   ON A.member_product_id = C.m_pr_id
         LEFT JOIN (ods.sbt_prod.basic_org_product FOR SYSTEM_TIME AS OF '${snap_date}') D ON C.pr_id = D.pr_id
         LEFT JOIN (ods.sbt_prod.oprt_boss_organization FOR SYSTEM_TIME AS OF '${snap_date}') E
                   ON E.org_id = A.contract_company_id
         INNER JOIN (ods.sbt_prod.mbc_member_info FOR SYSTEM_TIME AS OF '${snap_date}') G ON A.member_id = G.member_id
         LEFT JOIN (ods.sbt_prod.sys_dictionary_dtl FOR SYSTEM_TIME AS OF '${snap_date}') N
                   ON D.service_type = N.dic_value AND N.dic_code = 'PR_SERVICE_TYPE'
         LEFT JOIN (ods.sbt_prod.basic_ins_area FOR SYSTEM_TIME AS OF '${snap_date}') S ON A.city_code = S.area_code;


union all
SELECT -1                                                       AS data_source,
       A.order_no                                               AS order_no,
       8                                                        AS order_type,
       IF(G.virtual_flag = 0, CASE D.open_invoice_type
                                  WHEN 1 THEN 8
                                  WHEN 2 THEN IF(N.dic_value = '2' OR N.dic_value = '3', 2, 1) END,
          -1)                                                   AS business_type,
       A.ar_no                                                  AS ar_no,
       '${report_month}'                                                 AS order_month,
       IFNULL(A.order_month, '${report_month}')                          AS raw_order_month,
       IFNULL(A.fee_month, '${report_month}')                            AS fee_month,
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
       IF(A.order_month != '${report_month}', 1, 0)                      AS is_cross,
       0                                                        AS is_refund,
       0                                                        AS is_extra,
       0                                                        AS is_sup,
       0                                                        AS is_cancel,
       0                                                        AS is_diff,
       0                                                        AS is_ignore,
       0                                                        AS is_discard,
       CASE D.open_invoice_type WHEN 1 THEN 2 WHEN 2 THEN 1 END AS income_type,
       ROUND(A.income_reward + A.income_reward_pubaotong - ROUND(
                       (A.income_order_payroll + A.income_order_disabled + A.income_order_tax + A.income_order_other +
                        A.income_order_welfare) *
                       C.daishou_tax_rate / 100, 2),
             2)                                                 AS income_reward,
       A.income_reward + A.income_reward_pubaotong              AS raw_income_reward,
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
       REPLACE(UUID(), '-', '')                                 AS batch_no
FROM (SELECT O.order_code                                                         AS order_no,
             O.receive_no                                                         AS ar_no,
             O.create_time,
             O.memo,
             O.name                                                               AS order_item,
             O.member_product_id,
             O.contract_company_id,
             O.member_id,
             O.city_code,
             DATE_FORMAT(IF(O.order_month = '', IF(O.order_date = '', O.order_start_date, O.order_date),
                            CONCAT(O.order_month, '-01')),
                         'yyyyMM')                                                AS order_month,
             P.name                                                               AS emp_name,
             P.cert_no                                                            AS emp_id_no,
             IFNULL(IF(element_at(from_json(O.detail_title, 'array<string>'), 4) = '费用月份(示例: 2021-01)',
                       DATE_FORMAT(CONCAT(element_at(from_json(P.detail_data, 'array<string>'), 4), '-01'),
                                   'yyyyMM'), NULL), DATE_FORMAT(CONCAT(O.order_month, '-01'),
                                                                 'yyyyMM'))       AS fee_month,
             IF(element_at(from_json(O.detail_title, 'array<string>'), 13) = '外包SIPR服务费-外包服务费金额',
                element_at(from_json(P.detail_data, 'array<string>'), 13) + 0, 0) AS income_reward,
             IF(element_at(from_json(O.detail_title, 'array<string>'), 12) = '外包SIPR服务费-普保通服务费金额',
                element_at(from_json(P.detail_data, 'array<string>'), 12) + 0, 0) AS income_reward_pubaotong,
             IF(element_at(from_json(O.detail_title, 'array<string>'), 5) = '外包SIPR服务费-薪资金额',
                element_at(from_json(P.detail_data, 'array<string>'), 5) + 0, 0)  AS income_order_payroll,
             IF(element_at(from_json(O.detail_title, 'array<string>'), 6) = '外包SIPR服务费-薪资残保金金额',
                element_at(from_json(P.detail_data, 'array<string>'), 6) + 0, 0)  AS income_order_disabled,
             IF(element_at(from_json(O.detail_title, 'array<string>'), 7) = '外包SIPR服务费-薪资个税金额',
                element_at(from_json(P.detail_data, 'array<string>'), 7) + 0, 0)  AS income_order_tax,
             IF(element_at(from_json(O.detail_title, 'array<string>'), 14) = '外包SIPR服务费-其他金额',
                element_at(from_json(P.detail_data, 'array<string>'), 14) + 0, 0) AS income_order_other,
             IF(element_at(from_json(O.detail_title, 'array<string>'), 9) = '外包SIPR服务费-公积金金额',
                element_at(from_json(P.detail_data, 'array<string>'), 9) + 0, 0)  AS income_order_type_2,
             IF(element_at(from_json(O.detail_title, 'array<string>'), 10) = '外包SIPR服务费-社保金额',
                element_at(from_json(P.detail_data, 'array<string>'), 10) + 0, 0) AS income_order_type_1,
             IF(element_at(from_json(O.detail_title, 'array<string>'), 11) = '外包SIPR服务费-社保残保金金额',
                element_at(from_json(P.detail_data, 'array<string>'), 11) + 0, 0) AS income_order_type_1_disabled,
             IF(element_at(from_json(O.detail_title, 'array<string>'), 15) = '外包SIPR服务费-员工福利金额',
                element_at(from_json(P.detail_data, 'array<string>'), 15) + 0, 0) AS income_order_welfare
      FROM (ods.trade_center.trade_business_order FOR SYSTEM_TIME AS OF '${snap_date}') O
               INNER JOIN (ods.trade_center.trade_business_order_detail FOR SYSTEM_TIME AS OF '${snap_date}') P
                          ON O.id = P.order_id AND P.valid = 1
      WHERE O.create_order = 1
        AND (O.order_month != '' OR O.order_date != '' OR O.order_start_date != '')
        AND ((DATE_FORMAT(IF(O.order_month = '', IF(O.order_date = '', O.order_start_date, O.order_date),
                             CONCAT(O.order_month, '-01')), 'yyyyMM') <= '${report_month}'
          AND DATE_FORMAT(O.confirm_time, 'yyyyMM') = '${report_month}') OR
             (DATE_FORMAT(IF(O.order_month = '', IF(O.order_date = '', O.order_start_date, O.order_date),
                             CONCAT(O.order_month, '-01')), 'yyyyMM') = '${report_month}'
                 AND DATE_FORMAT(O.confirm_time, 'yyyyMM') <= '${report_month}'))
        AND O.test_flag = 0
        AND O.audit_state = 3
        AND O.order_state != 5
        AND O.product_name IN ('外包-SIPR')
        AND O.memo NOT LIKE '%补录%') A
         LEFT JOIN (ods.sbt_prod.mbc_member_product FOR SYSTEM_TIME AS OF '${snap_date}') C
                   ON A.member_product_id = C.m_pr_id
         LEFT JOIN (ods.sbt_prod.basic_org_product FOR SYSTEM_TIME AS OF '${snap_date}') D ON C.pr_id = D.pr_id
         LEFT JOIN (ods.sbt_prod.oprt_boss_organization FOR SYSTEM_TIME AS OF '${snap_date}') E
                   ON E.org_id = A.contract_company_id
         INNER JOIN (ods.sbt_prod.mbc_member_info FOR SYSTEM_TIME AS OF '${snap_date}') G ON A.member_id = G.member_id
         LEFT JOIN (ods.sbt_prod.sys_dictionary_dtl FOR SYSTEM_TIME AS OF '${snap_date}') N
                   ON D.service_type = N.dic_value AND N.dic_code = 'PR_SERVICE_TYPE'
         LEFT JOIN (ods.sbt_prod.basic_ins_area FOR SYSTEM_TIME AS OF '${snap_date}') S ON A.city_code = S.area_code;

union all
SELECT -1                                                       AS data_source,
       A.order_no                                               AS order_no,
       8                                                        AS order_type,
       IF(G.virtual_flag = 0, CASE D.open_invoice_type
                                  WHEN 1 THEN 8
                                  WHEN 2 THEN IF(N.dic_value = '2' OR N.dic_value = '3', 2, 1) END,
          -1)                                                   AS business_type,
       A.ar_no                                                  AS ar_no,
       '${report_month}'                                                 AS order_month,
       IFNULL(A.order_month, '${report_month}')                          AS raw_order_month,
       IFNULL(A.order_month, '${report_month}')                          AS fee_month,
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
       IF(A.order_month != '${report_month}', 1, 0)                      AS is_cross,
       0                                                        AS is_refund,
       0                                                        AS is_extra,
       0                                                        AS is_sup,
       0                                                        AS is_cancel,
       0                                                        AS is_diff,
       0                                                        AS is_ignore,
       0                                                        AS is_discard,
       CASE D.open_invoice_type WHEN 1 THEN 2 WHEN 2 THEN 1 END AS income_type,
       0                                                        AS income_reward,
       0                                                        AS raw_income_reward,
       A.income_order_fuli                                      AS income_order,
       A.income_order_fuli                                      AS raw_income_order,
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
       0                                                        AS indv_income_tax,
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
       0                                                        AS indv_disabled_amount,
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
       0                                                        AS indv_other_amount,
       0                                                        AS debit_card_no,
       ''                                                       AS bank_name,
       ''                                                       AS bank_region,
       ''                                                       AS tax_corp,
       A.create_time                                            AS raw_create_time,
       A.memo                                                   AS comment,
       ''                                                       AS raw_order_no,
       REPLACE(UUID(),  '-',  '')                     AS batch_no
FROM (SELECT O.order_code                                                           AS order_no,
             O.receive_no                                                           AS ar_no,
             O.create_time,
             O.memo,
             O.name                                                                 AS order_item,
             O.member_product_id,
             O.contract_company_id,
             O.member_id,
             O.city_code,
             DATE_FORMAT(IF(O.order_month = '', IF(O.order_date = '', O.order_start_date, O.order_date),
                            CONCAT(O.order_month, '-01')), 'yyyyMM')                AS order_month,
             P.name                                                                 AS emp_name,
             P.cert_no AS emp_id_no,
             P.fu_li / 10000                                                        AS income_order_fuli
      FROM (ods.trade_center.trade_business_order FOR SYSTEM_TIME AS OF '${snap_date}') O
               INNER JOIN (ods.trade_center.trade_business_order_xmpeople FOR SYSTEM_TIME AS OF '${snap_date}') P
                          ON O.id = P.order_id
                              AND P.valid = 1
      WHERE O.create_order = 1
        AND (O.order_month != '' OR O.order_date != '' OR O.order_start_date != '')
        AND ((DATE_FORMAT(IF(O.order_month = '', IF(O.order_date = '', O.order_start_date, O.order_date),
                             CONCAT(O.order_month, '-01')), 'yyyyMM') <= '${report_month}'
          AND DATE_FORMAT(O.confirm_time, 'yyyyMM') = '${report_month}') OR
             (DATE_FORMAT(IF(O.order_month = '', IF(O.order_date = '', O.order_start_date, O.order_date),
                             CONCAT(O.order_month, '-01')), 'yyyyMM') = '${report_month}'
                 AND DATE_FORMAT(O.confirm_time, 'yyyyMM') <= '${report_month}'))
        AND O.test_flag = 0
        AND O.audit_state = 3
        AND O.order_state != 5
        AND O.product_name IN ('外包-SIPR')
        AND O.memo NOT LIKE '%补录%') A
         LEFT JOIN (ods.sbt_prod.mbc_member_product FOR SYSTEM_TIME AS OF '${snap_date}') C
                   ON A.member_product_id = C.m_pr_id
         LEFT JOIN (ods.sbt_prod.basic_org_product FOR SYSTEM_TIME AS OF '${snap_date}') D ON C.pr_id = D.pr_id
         LEFT JOIN (ods.sbt_prod.oprt_boss_organization FOR SYSTEM_TIME AS OF '${snap_date}') E
                   ON E.org_id = A.contract_company_id
         INNER JOIN (ods.sbt_prod.mbc_member_info FOR SYSTEM_TIME AS OF '${snap_date}') G ON A.member_id = G.member_id
         LEFT JOIN (ods.sbt_prod.sys_dictionary_dtl FOR SYSTEM_TIME AS OF '${snap_date}') N
                   ON D.service_type = N.dic_value AND N.dic_code = 'PR_SERVICE_TYPE'
         LEFT JOIN (ods.sbt_prod.basic_ins_area FOR SYSTEM_TIME AS OF '${snap_date}') S ON A.city_code = S.area_code;
