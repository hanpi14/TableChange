DELETE
FROM dwd_order_emp_online_mi
WHERE order_type = 8
  AND is_sup = 0
  AND is_extra = 0
  AND data_source IN (1, 10)
  AND is_refund = 1;

INSERT INTO dwd_order_emp_online_mi(
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
    batch_no)
SELECT IF(D.bill_no = L.order_no AND L.valid = 1, 10, 1)                                                AS data_source,
       D.bill_no                                                                                        AS order_no,
       8                                                                                                AS order_type,
       IF(E.virtual_flag = 0, CASE I.open_invoice_type
                                  WHEN 1 THEN 8
                                  WHEN 2 THEN IF(N.dic_value = '2' OR N.dic_value = '3', 2, 1) END, -1) AS business_type,
       REPLACE(UUID(), _utf8'-', _utf8'')                                                               AS ar_no,
       '202204'                                                                                         AS order_month,
       D.tax_months                                                                                     AS raw_order_month,
       D.paid_months                                                                                    AS fee_month,
       E.member_code                                                                                    AS member_code,
       E.member_name                                                                                    AS member_name,
       F.org_name                                                                                       AS party_b,
       C.emp_name                                                                                       AS emp_name,
       AES_DECRYPT(FROM_BASE64(C.idcard_no), LEFT(UNHEX(SHA1('AbCdEfGh')), 16))                         AS emp_id_no,
       AES_DECRYPT(FROM_BASE64(IFNULL(C.tel, '')), LEFT(UNHEX(SHA1('AbCdEfGh')), 16))                   AS mobile,
       CASE
           WHEN G.area_name LIKE '%（%' THEN SUBSTRING_INDEX(G.area_name, '（', 1)
           WHEN G.area_name = '重庆WK' THEN '重庆'
           ELSE G.area_name
           END                                                                        AS region,
       G.area_name                                                                    AS raw_region,
       CASE
           WHEN S.area_name LIKE '%（%' THEN SUBSTRING_INDEX(S.area_name, '（', 1)
           WHEN S.area_name = '重庆WK' THEN '重庆'
           ELSE S.area_name
           END                                                                        AS order_region,
       S.area_name                                                                    AS raw_order_region,
       CONCAT(IF(D.tax_report_rule = '2', '次月报税-抵扣-', '当月报税-抵扣-'), '',
              CASE A.item_code
                  WHEN 'shifa' THEN '实发工资'
                  WHEN 'service' THEN '服务费'
                  WHEN 'geshui' THEN '个税'
                  WHEN 'canjijin' THEN '残保金'
                  WHEN 'gonghuifei' THEN '工会费'
                  WHEN 'daishou_tax_fee' THEN '代收代付税费'
                  WHEN 'service_tax_fee' THEN '服务费税费'
                  ELSE '其他' END)                                                    AS order_item, #拼接tax_report_rule 和 item_code
       IF(D.bill_no = L.order_no AND L.valid = 1, D.tax_rate, D.daishou_tax_rate)     AS order_tax_rate,#如果发放单号 和 订单编号相等 并且 账单订单构成表为有效 返回税率 否者返回代收税率
       D.tax_rate                                                                     AS reward_tax_rate,
        0                                                                              AS is_solo,
       1                                                                              AS is_collect,
       IF((D.tax_report_rule = '2' AND D.tax_months < '202204') OR
          (D.tax_report_rule = '1' AND DATE_FORMAT(D.create_time, '%Y%m') < DATE_FORMAT(
                  DATE_SUB(STR_TO_DATE(CONCAT('202204', '01'), '%Y%m%d'), INTERVAL 1 MONTH),
                  '%Y%m')), 1, 0)                                                     AS is_cross,
       1                                                                              AS is_refund,
       0                                                                              AS is_extra,
       0                                                                              AS is_sup,
       0                                                                              AS is_cancel,
       0                                                                              AS is_diff,
       0                                                                              AS is_ignore,
       0                                                                              AS is_discard,
       CASE I.open_invoice_type WHEN 1 THEN 2 WHEN 2 THEN 1 END                       AS income_type,
       ROUND(IF(A.item_code IN ('service', 'service_tax_fee'), A.diff_fee, 0), 4)     AS income_reward,
       ROUND(IF(A.item_code IN ('service', 'service_tax_fee'), A.diff_fee, 0), 4)     AS raw_income_reward,
       IF(K.tax_rule = 1, 2, 1)                                                       AS tax_calc_mode,
       ROUND(IF(A.item_code IN ('service', 'service_tax_fee'), 0, A.diff_fee), 4)     AS income_order,
       ROUND(IF(A.item_code IN ('service', 'service_tax_fee'), 0, A.diff_fee), 4)     AS raw_income_order,
       0                                                                              AS income_overdue,
       0                                                                              AS income_disabled,
       0                                                                              AS income_added_tax,
       0                                                                              AS income_stable,
       0                                                                              AS income_indv_tax,
       1                                                                              AS serve_count,
       IFNULL(J.supplier_code, '')                                                    AS supplier_code,
       IFNULL(J.supplier_name, '')                                                    AS supplier_name,
       1                                                                              AS cost_type,
       0                                                                              AS cost_reward,
       ''                                                                             AS sale_emp_name,
       IFNULL(D.service_emp, -1)                                                      AS serve_emp_id,
       IFNULL(D.achie_emp, -1)                                                        AS sale_emp_id,
       IFNULL(D.hr_service_dept, -1)                                                  AS serve_dept_id,
       IFNULL(D.hr_achie_dept, -1)                                                    AS sale_dept_id,
       C.revenue_position                                                             AS order_parm,
       IF(A.item_code = 'shifa', A.diff_fee, 0)                                       AS indv_net_pay,
       IF(A.item_code = 'geshui', A.diff_fee, 0)                                      AS indv_income_tax,
       0                                                                              AS income_indv_order,
       0                                                                              AS income_corp_order,
       0                                                                              AS corp_pension_amount,
       0                                                                              AS corp_pension_rate,
       0                                                                              AS indv_pension_amount,
       0                                                                              AS indv_pension_rate,
       0                                                                              AS corp_illness_amount,
       0                                                                              AS corp_illness_rate,
       0                                                                              AS indv_illness_amount,
       0                                                                              AS indv_illness_rate,
       0                                                                              AS corp_work_amount,
       0                                                                              AS corp_work_rate,
       0                                                                              AS indv_work_amount,
       0                                                                              AS indv_work_rate,
       0                                                                              AS corp_unemployed_amount,
       0                                                                              AS corp_unemployed_rate,
       0                                                                              AS indv_unemployed_amount,
       0                                                                              AS indv_unemployed_rate,
       0                                                                              AS corp_birth_amount,
       0                                                                              AS corp_birth_rate,
       0                                                                              AS indv_birth_amount,
       0                                                                              AS indv_birth_rate,
       0                                                                              AS corp_disabled_amount,
       0                                                                              AS corp_disabled_rate,
       IF(A.item_code = 'canjijin', A.diff_fee, 0)                                    AS indv_disabled_amount,
       0                                                                              AS indv_disabled_rate,
       0                                                                              AS corp_serious_illness_amount,
       0                                                                              AS corp_serious_illness_rate,
       0                                                                              AS indv_serious_illness_amount,
       0                                                                              AS indv_serious_illness_rate,
       0                                                                              AS corp_ext_illness_amount,
       0                                                                              AS corp_ext_illness_rate,
       0                                                                              AS indv_ext_illness_amount,
       0                                                                              AS indv_ext_illness_rate,
       0                                                                              AS corp_hospital_amount,
       0                                                                              AS corp_hospital_rate,
       0                                                                              AS indv_hospital_amount,
       0                                                                              AS indv_hospital_rate,
       0                                                                              AS corp_fund_amount,
       0                                                                              AS corp_fund_rate,
       0                                                                              AS indv_fund_amount,
       0                                                                              AS indv_fund_rate,
       0                                                                              AS indv_union_amount,
       0                                                                              AS indv_other_amount,
       IFNULL(C.bank_card_number, '')                                                 AS debit_card_no,
       IFNULL(C.bank_name, '')                                                        AS bank_name,
       IFNULL(C.account_city, '')                                                     AS bank_region,
       D.tax_org_name                                                                 AS tax_corp,
       D.create_time                                                                  AS raw_create_time,
       B.diff_reason                                                                  AS comment,
       ''                                                                             AS raw_order_no,
       IFNULL(M.bill_no, REPLACE(UUID(), _utf8'-', _utf8''))                          AS batch_no
FROM ods_pay_payroll_refund_20240410 A #薪资结转补退
         INNER JOIN ods_pay_payroll_diff_20240410 B #薪资补退记录
ON A.diff_id #补退记录id
    = B.id
    INNER JOIN ods_pay_payroll_emp_20240410 C #薪酬发放人员明细
    ON B.from_payroll_id #原始薪资单明细id
    = C.payroll_id #记录ID
    INNER JOIN (SELECT P.*, Q.confirm_time
    FROM ods_pay_payroll_bill_20240410 P #薪酬发放单（统计）
                              INNER JOIN (SELECT O.bill_id, MIN(O.create_time) AS confirm_time
                                          FROM ods_pay_payroll_deal_record_20240410 O #工资单处理记录
                                          WHERE O.deal_status = '1'
                                            AND NOT EXISTS(SELECT 1
                                                           FROM ods_pay_payroll_deal_record_20240410 V #工资单处理记录
                                                           WHERE V.bill_id = O.bill_id
                                                             AND V.deal_status = '2') #not exists 验证无意义 拖慢计算时间 在重构时可以校验以下逻辑
                                          GROUP BY O.bill_id) Q ON P.bill_id = Q.bill_id
                     WHERE (
                         (P.tax_months = '202204' AND P.tax_report_rule = '2' AND
                          DATE_FORMAT(Q.confirm_time, '%Y%m') <= '202204')
                             OR
                         (P.tax_months < '202204' AND P.tax_report_rule = '2' AND
                          DATE_FORMAT(Q.confirm_time, '%Y%m') = '202204')
                             OR (P.tax_months =
                                 DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT('202204', '01'), '%Y%m%d'), INTERVAL 1 MONTH),
                                             '%Y%m') AND P.tax_report_rule = '1' AND
                                 DATE_FORMAT(Q.confirm_time, '%Y%m') <= '202204')
                         )
                       AND P.alive_flag = '1'
                       AND P.import_method = '1'
                       AND (
                         (P.bill_status = '01' AND P.deal_status IN ('0', '1') AND P.flow_type = 0)
                             OR
                         P.bill_status NOT IN ('00', '01')
                         )
                       AND P.from_bill_id IS NULL
                       AND P.test_flag = 0
                       AND P.wirteoff_status IN (0, 1, 2, 5, 6, 7)) D ON A.bill_id = D.bill_id
         INNER JOIN ods_mbc_member_info_20240410 E ON A.member_id = E.member_id
         LEFT JOIN ods_oprt_boss_organization_20240410 F ON D.org_id = F.org_id
         LEFT JOIN ods_basic_ins_area_20240410 G ON C.area_code = G.area_code
         LEFT JOIN ods_mbc_member_product_20240410 H ON H.m_pr_id = D.m_pr_id
         LEFT JOIN ods_basic_org_product_20240410 I ON I.pr_id = H.pr_id
         LEFT JOIN ods_supplier_info_20240410 J ON D.supplier_id = J.supplier_id
         LEFT JOIN ods_mbc_member_product_cover_20240410 K
                   ON H.m_pr_id = K.m_pr_id AND D.area_code = K.area_code AND K.alive_flag = '1'
         LEFT JOIN ods_sys_dictionary_dtl_20240410 N
                   ON I.service_type = N.dic_value AND N.dic_code = 'PR_SERVICE_TYPE'
         LEFT JOIN ods_basic_ins_area_20240410 S ON D.area_code = S.area_code
         LEFT JOIN ods_hro_bill_constitute_20240410 L ON D.bill_no = L.order_no AND L.valid = 1
         LEFT JOIN ods_hro_bill_20240410 M ON L.bill_id = M.id AND M.valid = 1
WHERE IF(H.service_code = 'hro' AND M.out_time IS NULL, 0, 1) = 1;