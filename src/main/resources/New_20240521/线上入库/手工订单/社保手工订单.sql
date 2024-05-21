DELETE
FROM dw.dwd.dwd_order_emp_online_!{load_freq}i
WHERE order_type = 1
  AND data_source = -1
  AND is_sup = 0
  AND is_extra = 0
  AND is_refund = 0


INSERT INTO dw.dwd.dwd_order_emp_online_!{load_freq}i(data_source, order_no, order_type, business_type, ar_no, order_month,
                                                      raw_order_month,
                                                      fee_month,
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
SELECT -1                                                                                               AS data_source,
       A.order_no                                                                                       AS order_no,
       1                                                                                                AS order_type,
       IF(G.virtual_flag = 0, CASE D.open_invoice_type
                                  WHEN 1 THEN 8
                                  WHEN 2 THEN IF(N.dic_value = '2' OR N.dic_value = '3', 2, 1) END,
          -1)                                                                                           AS business_type,
       A.ar_no                                                                                          AS ar_no,
       '${report_month}'                                                                                         AS order_month,
       IFNULL(A.order_month, '${report_month}')                                                                  AS raw_order_month,
       IFNULL(DATE_FORMAT(CONCAT(B.month, '-01'), 'yyyyMM'), '${report_month}')                                  AS fee_month,
       G.member_code                                                                                    AS member_code,
       G.member_name                                                                                    AS member_name,
       E.org_name                                                                                       AS party_b,
       B.name                                                                                           AS emp_name,
       B.cert_no                        AS emp_id_no,
       ''                                                                                               AS mobile,
       CASE
           WHEN B.area_name IS NULL THEN '全国'
           WHEN B.area_name LIKE '%（%' THEN SUBSTRING_INDEX(B.area_name, '（', 1)
           WHEN B.area_name = '重庆WK' THEN '重庆'
           ELSE B.area_name
           END                                                                                          AS region,
       IFNULL(B.area_name, '全国')                                                                      AS raw_region,
       CASE
           WHEN S.area_name IS NULL THEN '全国'
           WHEN S.area_name LIKE '%（%' THEN SUBSTRING_INDEX(S.area_name, '（', 1)
           WHEN S.area_name = '重庆WK' THEN '重庆'
           ELSE S.area_name
           END                                                                                          AS order_region,
       IFNULL(S.area_name, '全国')                                                                      AS raw_order_region,
       B.shebao_zhengce                                                                                 AS order_item,
       C.daishou_tax_rate                                                                               AS order_tax_rate,
       C.tax_rate                                                                                       AS reward_tax_rate,
       IF(C.single_flag = 1, 1, 0)                                                                      AS is_solo,
       0                                                                                                AS tax_calc_mode,
       IF(C.single_flag = 1, 0, 1)                                                                      AS is_collect,
       IF(A.order_month != '${report_month}', 1, 0)                                                              AS is_cross,
       0                                                                                                AS is_refund,
       0                                                                                                AS is_extra,
       0                                                                                                AS is_sup,
       0                                                                                                AS is_cancel,
       0                                                                                                AS is_diff,
       0                                                                                                AS is_ignore,
       0                                                                                                AS is_discard,
       CASE D.open_invoice_type WHEN 1 THEN 2 WHEN 2 THEN 1 END                                         AS income_type,
       B.daili_fuwufei / 10000                                                                          AS income_reward,
       B.daili_fuwufei / 10000                                                                          AS raw_income_reward,
       IF(C.single_flag = 1, 0, B.shebao_amount / 10000)                                                AS income_order,
       B.shebao_amount / 10000                                                                          AS raw_income_order,
       B.shebao_zhinajin / 10000                                                                        AS income_overdue,
       0                                                                                                AS income_disabled,
       0                                                                                                AS income_added_tax,
       0                                                                                                AS income_stable,
       0                                                                                                AS income_indv_tax,
       1                                                                                                AS serve_count,
       IFNULL(F.supplier_code, '')                                                                      AS supplier_code,
       IFNULL(F.supplier_name, '')                                                                      AS supplier_name,
       1                                                                                                AS cost_type,
       0                                                                                                AS cost_reward,
       ''                                                                                               AS sale_emp_name,
       IFNULL(C.service_emp, -1)                                                                        AS serve_emp_id,
       IFNULL(C.achie_emp, -1)                                                                          AS sale_emp_id,
       IFNULL(C.hr_service_dept, -1)                                                                    AS serve_dept_id,
       IFNULL(C.hr_achie_dept, -1)                                                                      AS sale_dept_id,
       B.shebao_jishu / 10000                                                                           AS order_parm,
       0                                                                                                AS indv_net_pay,
       0                                                                                                AS indv_income_tax,
       B.shebao_geren_amount / 10000                                                                    AS income_indv_order,
       B.shebao_danwei_amount / 10000                                                                   AS income_corp_order,
       B.yanglao_danwei_amount / 10000                                                                  AS corp_pension_amount,
       B.yanglao_danwei_percent                                                                         AS corp_pension_rate,
       B.yanglao_geren_amount / 10000                                                                   AS indv_pension_amount,
       B.yanglao_geren_percent                                                                          AS indv_pension_rate,
       B.yiliao_danwei_amount / 10000                                                                   AS corp_illness_amount,
       B.yiliao_danwei_percent                                                                          AS corp_illness_rate,
       B.yiliao_geren_amount / 10000                                                                    AS indv_illness_amount,
       B.yiliao_geren_percent                                                                           AS indv_illness_rate,
       B.gongshang_danwei_amount / 10000                                                                AS corp_work_amount,
       B.gongshang_danwei_percent                                                                       AS corp_work_rate,
       0                                                                                                AS indv_work_amount,
       0                                                                                                AS indv_work_rate,
       B.shiye_danwei_amount / 10000                                                                    AS corp_unemployed_amount,
       B.shiye_danwei_percent                                                                           AS corp_unemployed_rate,
       B.shiye_geren_amount / 10000                                                                     AS indv_unemployed_amount,
       B.shiye_geren_percent                                                                            AS indv_unemployed_rate,
       B.shengyu_danwei_amount / 10000                                                                  AS corp_birth_amount,
       B.shengyu_danwei_percent                                                                         AS corp_birth_rate,
       0                                                                                                AS indv_birth_amount,
       0                                                                                                AS indv_birth_rate,
       B.canbaojin_danwei_amount / 10000                                                                AS corp_disabled_amount,
       B.canbaojin_danwei_percent                                                                       AS corp_disabled_rate,
       B.canbaojin_geren_amount / 10000                                                                 AS indv_disabled_amount,
       B.canbaojin_geren_percent                                                                        AS indv_disabled_rate,
       0                                                                                                AS corp_serious_illness_amount,
       0                                                                                                AS corp_serious_illness_rate,
       0                                                                                                AS indv_serious_illness_amount,
       0                                                                                                AS indv_serious_illness_rate,
       0                                                                                                AS corp_ext_illness_amount,
       0                                                                                                AS corp_ext_illness_rate,
       0                                                                                                AS indv_ext_illness_amount,
       0                                                                                                AS indv_ext_illness_rate,
       0                                                                                                AS corp_hospital_amount,
       0                                                                                                AS corp_hospital_rate,
       0                                                                                                AS indv_hospital_amount,
       0                                                                                                AS indv_hospital_rate,
       0                                                                                                AS corp_fund_amount,
       0                                                                                                AS corp_fund_rate,
       0                                                                                                AS indv_fund_amount,
       0                                                                                                AS indv_fund_rate,
       0                                                                                                AS indv_union_amount,
       IF(B.shebao_amount != 0, qita_danwei_amount / 10000, 0)                                          AS corp_other_amount,
       IF(B.shebao_amount != 0, B.qita_geren_amount / 10000, 0)                                         AS indv_other_amount,
       ''                                                                                               AS debit_card_no,
       ''                                                                                               AS bank_name,
       ''                                                                                               AS bank_region,
       ''                                                                                               AS tax_corp,
       A.create_time                                                                                    AS raw_create_time,
       A.memo                                                                                           AS comment,
       ''                                                                                               AS raw_order_no,
       REPLACE(UUID(),  '-',  '')                                                             AS batch_no
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
         INNER JOIN (ods.trade_center.trade_business_order_sbpeople FOR SYSTEM_TIME AS OF '${snap_date}') B
                    ON A.id = B.order_id AND
                       (B.shebao_amount != 0 OR (B.daili_fuwufei != 0 AND B.gongjijin_amount = 0)) AND B.valid = 1
         LEFT JOIN (ods.sbt_prod.mbc_member_product FOR SYSTEM_TIME AS OF '${snap_date}') C
                   ON A.member_product_id = C.m_pr_id
         LEFT JOIN (ods.sbt_prod.basic_org_product FOR SYSTEM_TIME AS OF '${snap_date}') D ON C.pr_id = D.pr_id
         LEFT JOIN (ods.sbt_prod.oprt_boss_organization FOR SYSTEM_TIME AS OF '${snap_date}') E
                   ON E.org_id = A.contract_company_id
         LEFT JOIN (ods.sbt_prod.supplier_info FOR SYSTEM_TIME AS OF '${snap_date}') F
                   ON IF(B.shebao_supplier_id != 0, B.shebao_supplier_id, B.supplier_id) = F.supplier_id
         INNER JOIN (ods.sbt_prod.mbc_member_info FOR SYSTEM_TIME AS OF '${snap_date}') G ON A.member_id = G.member_id
         LEFT JOIN (ods.sbt_prod.sys_dictionary_dtl FOR SYSTEM_TIME AS OF '${snap_date}') N
                   ON D.service_type = N.dic_value AND N.dic_code = 'PR_SERVICE_TYPE'
         LEFT JOIN (ods.sbt_prod.basic_ins_area FOR SYSTEM_TIME AS OF '${snap_date}') S ON A.city_code = S.area_code
