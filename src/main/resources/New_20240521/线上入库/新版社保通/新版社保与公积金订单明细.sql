DELETE
FROM dw.dwd.dwd_order_emp_online_!{load_freq}i
WHERE is_sup = 0
  AND data_source IN (4, 9, 10)
  AND is_extra = 0
  AND is_refund = 0;

SET spark.sql.adaptive.enabled = true;
SET spark.sql.shuffle.partitions = 10;
SET spark.sql.autoBroadcastJoinThreshold=-1;
SET spark.sql.adaptive.skewJoin.enabled = true;
SET spark.sql.adaptive.skewJoin.skewedPartitionFactor = 10 ;
SET spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes = 256MB;

INSERT INTO dw.dwd.dwd_order_emp_online_!{load_freq}i(data_source,
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
                                                      corp_other_amount,
                                                      debit_card_no,
                                                      bank_name,
                                                      bank_region,
                                                      tax_corp,
                                                      raw_create_time,
                                                      comment,
                                                      raw_order_no,
                                                      batch_no,
                                                      create_time,
                                                      update_time)
SELECT IF(M.bill_no IS NULL, IF(O.order_no = A.order_no AND O.valid = 1, 10, 4), 9)                        AS data_source,
       A.order_no                                                                                          AS order_no,
       CASE WHEN B.ins_type = 1 THEN 1 WHEN B.ins_type = 2 THEN 2 ELSE -1 END                              AS order_type,
       IF(E.virtual_flag = 0, CASE J.open_invoice_type
                                  WHEN 1 THEN 8
                                  WHEN 2 THEN IF(N.dic_value = '2' OR N.dic_value = '3', 2, 1) END,
          -1)                                                                                              AS business_type,
       IFNULL(IF(A.receive_no = '', M.receive_no, A.receive_no), '')                                       AS ar_no,
       '${report_month}'                                                                                            AS order_month,
       A.area_order_month                                                                                  AS raw_order_month,
       B.fee_month                                                                                         AS fee_month,
       E.member_code                                                                                       AS member_code,
       E.member_name                                                                                       AS member_name,
       D.org_name                                                                                          AS party_b,
       C.emp_name                                                                                          AS emp_name,
       C.idcard_no                           AS emp_id_no,
       C.mobile_phone            AS mobile,
       CASE
           WHEN G.area_name LIKE '%（%' THEN SUBSTRING_INDEX(G.area_name, '（', 1)
           WHEN G.area_name = '重庆WK' THEN '重庆'
           ELSE G.area_name
           END                                                                                             AS region,
       G.area_name                                                                                         AS raw_region,
       CASE
           WHEN F.area_name LIKE '%（%' THEN SUBSTRING_INDEX(F.area_name, '（', 1)
           WHEN F.area_name = '重庆WK' THEN '重庆'
           ELSE F.area_name
           END                                                                                             AS order_region,
       F.area_name                                                                                         AS raw_order_region,
       B.ins_org_name                                                                                      AS order_item,
       CASE
           WHEN A.sbt_order_id != 0 THEN ABS(S.daishou_tax_rate)
           WHEN A.sbt_order_id = 0 AND R.sipr_tax_rate != 0 THEN R.sipr_tax_rate
           WHEN A.sbt_order_id = 0 AND R.tax_rate != 0 THEN R.tax_rate
           WHEN O.order_no = A.order_no AND O.valid = 1 THEN I.tax_rate
           ELSE 0 END                                                                                      AS order_tax_rate,
       I.tax_rate                                                                                          AS reward_tax_rate,
       IF(A.account_property = 2, 1, 0)                                                                    AS is_solo,
       IF(A.account_property = 2, 0, 1)                                                                    AS is_collect,
       IF(A.area_order_month < '${report_month}', 1, 0)                                                             AS is_cross,
       0                                                                                                   AS is_refund,
       0                                                                                                   AS is_extra,
       0                                                                                                   AS is_sup,
       IF(B.cancel_flag = 1, 1, 0)                                                                         AS is_cancel,
       0                                                                                                   AS is_diff,
       IF(A.order_amount = 0 OR B.income_total_order = 0, 1, 0)                                            AS is_ignore,
       IF(A.order_state = 5, 1, 0)                                                                         AS is_discard,
       CASE J.open_invoice_type WHEN 1 THEN 2 WHEN 2 THEN 1 END                                            AS income_type,
       0                                                                                                   AS income_reward,
       0                                                                                                   AS raw_income_reward,
       IF(A.account_property = 2, 0, B.income_indv_order + B.income_corp_order +
                                     B.income_late_order)                                                  AS income_order,
       B.income_indv_order + B.income_corp_order + B.income_late_order                                     AS raw_income_order,
       0                                                                                                   AS income_overdue,
       0                                                                                                   AS income_disabled,
       0                                                                                                   AS income_added_tax,
       0                                                                                                   AS income_stable,
       0                                                                                                   AS income_indv_tax,
       1                                                                                                   AS serve_count,
       COALESCE(K.supplier_code, V.supplier_code, '')                                                      AS supplier_code,
       COALESCE(K.supplier_name, V.supplier_name, '')                                                      AS supplier_name,
       1                                                                                                   AS cost_type,
       0                                                                                                   AS cost_reward,
       ''                                                                                                  AS sale_emp_name,
       IFNULL(H.service_emp, -1)                                                                           AS serve_emp_id,
       IFNULL(H.achie_emp, -1)                                                                             AS sale_emp_id,
       IFNULL(H.hr_service_dept, -1)                                                                       AS serve_dept_id,
       IFNULL(H.hr_achie_dept, -1)                                                                         AS sale_dept_id,
       B.base                                                                                              AS order_parm,
       0                                                                                                   AS indv_net_pay,
       0                                                                                                   AS indv_income_tax,
       B.income_indv_order                                                                                 AS income_indv_order,
       B.income_corp_order                                                                                 AS income_corp_order,
       B.corp_pension_amount                                                                               AS corp_pension_amount,
       B.corp_pension_rate                                                                                 AS corp_pension_rate,
       B.indv_pension_amount                                                                               AS indv_pension_amount,
       B.indv_pension_rate                                                                                 AS indv_pension_rate,
       B.corp_illness_amount                                                                               AS corp_illness_amount,
       B.corp_illness_rate                                                                                 AS corp_illness_rate,
       B.indv_illness_amount                                                                               AS indv_illness_amount,
       B.indv_illness_rate                                                                                 AS indv_illness_rate,
       B.corp_work_amount                                                                                  AS corp_work_amount,
       B.corp_work_rate                                                                                    AS corp_work_rate,
       B.indv_work_amount                                                                                  AS indv_work_amount,
       B.indv_work_rate                                                                                    AS indv_work_rate,
       B.corp_unemployed_amount                                                                            AS corp_unemployed_amount,
       B.corp_unemployed_rate                                                                              AS corp_unemployed_rate,
       B.indv_unemployed_amount                                                                            AS indv_unemployed_amount,
       B.indv_unemployed_rate                                                                              AS indv_unemployed_rate,
       B.corp_birth_amount                                                                                 AS corp_birth_amount,
       B.corp_birth_rate                                                                                   AS corp_birth_rate,
       B.indv_birth_amount                                                                                 AS indv_birth_amount,
       B.indv_birth_rate                                                                                   AS indv_birth_rate,
       B.corp_disabled_amount                                                                              AS corp_disabled_amount,
       B.corp_disabled_rate                                                                                AS corp_disabled_rate,
       B.indv_disabled_amount                                                                              AS indv_disabled_amount,
       B.indv_disabled_rate                                                                                AS indv_disabled_rate,
       B.corp_serious_illness_amount                                                                       AS corp_serious_illness_amount,
       B.corp_serious_illness_rate                                                                         AS corp_serious_illness_rate,
       B.indv_serious_illness_amount                                                                       AS indv_serious_illness_amount,
       B.indv_serious_illness_rate                                                                         AS indv_serious_illness_rate,
       B.corp_ext_illness_amount                                                                           AS corp_ext_illness_amount,
       B.corp_ext_illness_rate                                                                             AS corp_ext_illness_rate,
       B.indv_ext_illness_amount                                                                           AS indv_ext_illness_amount,
       B.indv_ext_illness_rate                                                                             AS indv_ext_illness_rate,
       B.corp_hospital_amount                                                                              AS corp_hospital_amount,
       B.corp_hospital_rate                                                                                AS corp_hospital_rate,
       B.indv_hospital_amount                                                                              AS indv_hospital_amount,
       B.indv_hospital_rate                                                                                AS indv_hospital_rate,
       B.corp_fund_amount                                                                                  AS corp_fund_amount,
       B.corp_fund_rate                                                                                    AS corp_fund_rate,
       B.indv_fund_amount                                                                                  AS indv_fund_amount,
       B.indv_fund_rate                                                                                    AS indv_fund_rate,
       B.indv_union_amount                                                                                 AS indv_union_amount,
       B.indv_other_amount                                                                                 AS indv_other_amount,
       B.corp_other_amount                                                                                 AS corp_other_amount,
       ''                                                                                                  AS debit_card_no,
       ''                                                                                                  AS bank_name,
       ''                                                                                                  AS bank_region,
       ''                                                                                                  AS tax_corp,
       A.create_time                                                                                       AS raw_create_time,
       ''                                                                                                  AS comment,
       ''                                                                                                  AS raw_order_no,
       COALESCE(IF(A.sbt_order_id = 0 OR M.sbt_bill_id = 0, M.bill_no,
                   REPLACE(UUID(),  '-',  '')), P.bill_no, REPLACE(UUID(),  '-',  '')) AS batch_no,
       current_timestamp() AS create_time,
       current_timestamp() AS update_time
FROM (ods.shebaotong.sbt_order FOR SYSTEM_TIME AS OF '${snap_date}') A
         INNER JOIN (SELECT SUM(IF(S.category = 3, R.org_fee, 0))                                AS corp_pension_amount,
                            MAX(IF(S.category = 3, R.org_prop, 0))                               AS corp_pension_rate,
                            SUM(IF(S.category = 3, R.emp_fee, 0))                                AS indv_pension_amount,
                            MAX(IF(S.category = 3, R.emp_prop, 0))                               AS indv_pension_rate,
                            SUM(IF(S.category = 4 AND S.ins_code = 40, R.org_fee, 0))            AS corp_illness_amount,
                            MAX(IF(S.category = 4 AND S.ins_code = 40, R.org_prop, 0))           AS corp_illness_rate,
                            SUM(IF(S.category = 4 AND S.ins_code = 40, R.emp_fee, 0))            AS indv_illness_amount,
                            MAX(IF(S.category = 4 AND S.ins_code = 40, R.emp_prop, 0))           AS indv_illness_rate,
                            SUM(IF(S.category = 4 AND S.ins_code = 42, R.org_fee, 0))            AS corp_hospital_amount,
                            MAX(IF(S.category = 4 AND S.ins_code = 42, R.org_prop, 0))           AS corp_hospital_rate,
                            SUM(IF(S.category = 4 AND S.ins_code = 42, R.emp_fee, 0))            AS indv_hospital_amount,
                            MAX(IF(S.category = 4 AND S.ins_code = 42, R.emp_prop, 0))           AS indv_hospital_rate,
                            SUM(IF(S.category = 4 AND S.ins_code = 41, R.org_fee, 0))            AS corp_ext_illness_amount,
                            MAX(IF(S.category = 4 AND S.ins_code = 41, R.org_prop, 0))           AS corp_ext_illness_rate,
                            SUM(IF(S.category = 4 AND S.ins_code = 41, R.emp_fee, 0))            AS indv_ext_illness_amount,
                            MAX(IF(S.category = 4 AND S.ins_code = 41, R.emp_prop, 0))           AS indv_ext_illness_rate,
                            SUM(IF(S.category = 4 AND S.ins_code = 43, R.org_fee, 0))            AS corp_serious_illness_amount,
                            MAX(IF(S.category = 4 AND S.ins_code = 43, R.org_prop, 0))           AS corp_serious_illness_rate,
                            SUM(IF(S.category = 4 AND S.ins_code = 43, R.emp_fee, 0))            AS indv_serious_illness_amount,
                            MAX(IF(S.category = 4 AND S.ins_code = 43, R.emp_prop, 0))           AS indv_serious_illness_rate,
                            SUM(IF(S.category = 5, R.org_fee, 0))                                AS corp_unemployed_amount,
                            MAX(IF(S.category = 5, R.org_prop, 0))                               AS corp_unemployed_rate,
                            SUM(IF(S.category = 5, R.emp_fee, 0))                                AS indv_unemployed_amount,
                            MAX(IF(S.category = 5, R.emp_prop, 0))                               AS indv_unemployed_rate,
                            SUM(IF(S.category = 6, R.org_fee, 0))                                AS corp_work_amount,
                            MAX(IF(S.category = 6, R.org_prop, 0))                               AS corp_work_rate,
                            SUM(IF(S.category = 6, R.emp_fee, 0))                                AS indv_work_amount,
                            MAX(IF(S.category = 6, R.emp_prop, 0))                               AS indv_work_rate,
                            SUM(IF(S.category = 7, R.org_fee, 0))                                AS corp_birth_amount,
                            MAX(IF(S.category = 7, R.org_prop, 0))                               AS corp_birth_rate,
                            SUM(IF(S.category = 7, R.emp_fee, 0))                                AS indv_birth_amount,
                            MAX(IF(S.category = 7, R.emp_prop, 0))                               AS indv_birth_rate,
                            SUM(IF(S.category = 2, R.org_fee, 0))                                AS corp_fund_amount,
                            MAX(IF(S.category = 2, R.org_prop, 0))                               AS corp_fund_rate,
                            SUM(IF(S.category = 2, R.emp_fee, 0))                                AS indv_fund_amount,
                            MAX(IF(S.category = 2, R.emp_prop, 0))                               AS indv_fund_rate,
                            SUM(IF(S.category = 8 AND S.ins_code = 80, R.org_fee, 0))            AS corp_disabled_amount,
                            MAX(IF(S.category = 8 AND S.ins_code = 80, R.org_prop, 0))           AS corp_disabled_rate,
                            SUM(IF(S.category = 8 AND S.ins_code = 80, R.emp_fee, 0))            AS indv_disabled_amount,
                            MAX(IF(S.category = 8 AND S.ins_code = 80, R.emp_prop, 0))           AS indv_disabled_rate,
                            SUM(IF(S.category = 8 AND S.ins_code = 90, R.org_fee, 0))            AS corp_union_amount,
                            MAX(IF(S.category = 8 AND S.ins_code = 90, R.org_prop, 0))           AS corp_union_rate,
                            SUM(IF(S.category = 8 AND S.ins_code = 90, R.emp_fee, 0))            AS indv_union_amount,
                            MAX(IF(S.category = 8 AND S.ins_code = 90, R.emp_prop, 0))           AS indv_union_rate,
                            SUM(IF(S.category = 8 AND S.ins_code NOT IN (80, 90), R.emp_fee, 0)) AS indv_other_amount,
                            SUM(IF(S.category = 8 AND S.ins_code NOT IN (80, 90), R.org_fee, 0)) AS corp_other_amount,
                            SUM(R.emp_fee)                                                       AS income_indv_order,
                            SUM(R.org_fee)                                                       AS income_corp_order,
                            SUM(R.overdue_fee)                                                   AS income_late_order,
                            R.base,
                            T.ins_org_name,
                            R.order_id,
                            R.ins_type,
                            R.emp_id,
                            R.area_order_month,
                            R.fee_month,
                            U.vendor_id                                            AS vendor_id,
                            R.area_id,
                            R.cancel_flag,
                            R.order_state,
                            SUM(R.total_fee)                                                     AS income_total_order
                     FROM (ods.shebaotong.sbt_order_ins FOR SYSTEM_TIME AS OF '${snap_date}') R
                              INNER JOIN (ods.shebaotong.sbt_insurance_item FOR SYSTEM_TIME AS OF '${snap_date}') S
                                         ON R.ins_code = S.ins_code
                              INNER JOIN (ods.shebaotong.sbt_insurance_org FOR SYSTEM_TIME AS OF '${snap_date}') T
                                         ON R.ins_org_id = T.id
                              LEFT JOIN (ods.shebaotong.sbt_operate_order_ins FOR SYSTEM_TIME AS OF '${snap_date}') V
                                        ON R.id = V.order_ins_id AND V.latest = 1
                              LEFT JOIN (
                         SELECT id,IFNULL(supplier_id, '') AS vendor_id FROM  ods.shebaotong.sbt_operate_order FOR SYSTEM_TIME AS OF '${snap_date}'
                     ) U
                                        ON V.operate_order_id = U.id
                     WHERE (R.order_flag = 1 OR R.cancel_flag = 1 OR R.order_state = 8)
                     GROUP BY R.base, T.ins_org_name, R.order_id, R.ins_type, R.emp_id, R.area_order_month, R.fee_month,
                              U.vendor_id, R.area_id, R.cancel_flag,R.order_state) B
                    ON A.id = B.order_id
                        AND IF(B.order_state = 8 AND A.receive_no NOT IN (SELECT Q.receive_no
                                                                          FROM (ods.sbt_prod.fnc_receivable_account FOR SYSTEM_TIME AS OF '${snap_date}') Q
                                                                          WHERE Q.alive_flag = '1'
                                                                            AND Q.confirm_status = '1') AND
                               A.order_type = 1, 0, 1) = 1
         INNER JOIN (ods.shebaotong.sbt_employee FOR SYSTEM_TIME AS OF '${snap_date}') C
                    ON B.emp_id = C.id
         LEFT JOIN (ods.sbt_prod.oprt_boss_organization FOR SYSTEM_TIME AS OF '${snap_date}') D
                   ON A.org_id = D.org_id
         INNER JOIN (ods.sbt_prod.mbc_member_info FOR SYSTEM_TIME AS OF '${snap_date}') E
                    ON A.member_id = E.member_id
         LEFT JOIN (ods.sbt_prod.basic_ins_area FOR SYSTEM_TIME AS OF '${snap_date}') F
                   ON A.area_id = F.area_id
         LEFT JOIN (ods.sbt_prod.basic_ins_area FOR SYSTEM_TIME AS OF '${snap_date}') G
                   ON B.area_id = G.area_id
         LEFT JOIN (ods.sbt_prod.mbc_member_product FOR SYSTEM_TIME AS OF '${snap_date}') I
                   ON A.member_product_id = I.m_pr_id
         LEFT JOIN (ods.sbt_prod.basic_org_product FOR SYSTEM_TIME AS OF '${snap_date}') J
                   ON J.pr_id = I.pr_id
         LEFT JOIN (ods.sbt_prod.supplier_info FOR SYSTEM_TIME AS OF '${snap_date}') K
                   ON B.vendor_id = K.supplier_id
         LEFT JOIN (ods.sbt_prod.sys_dictionary_dtl FOR SYSTEM_TIME AS OF '${snap_date}') N
                   ON A.service_type = N.dic_value AND N.dic_code = 'PR_SERVICE_TYPE'
         LEFT JOIN (ods.shebaotong.sbt_bill_dtl FOR SYSTEM_TIME AS OF '${snap_date}') L
                   ON A.id = L.order_id AND L.data_type = 1 AND L.alive_flag = 1
         LEFT JOIN (ods.shebaotong.sbt_bill FOR SYSTEM_TIME AS OF '${snap_date}') M
                   ON L.bill_id = M.id
         LEFT JOIN (ods.sbt_prod.fnc_receivable_account FOR SYSTEM_TIME AS OF '${snap_date}') H
                   ON IF(A.receive_no = '', M.receive_no, A.receive_no) = H.receive_no
         LEFT JOIN (ods.shebao_hro.hro_bill_constitute FOR SYSTEM_TIME AS OF '${snap_date}') O
                   ON O.order_no = A.order_no AND O.valid = 1
         LEFT JOIN (ods.shebao_hro.hro_bill FOR SYSTEM_TIME AS OF '${snap_date}') P
                   ON O.bill_id = P.id AND P.valid = 1
         LEFT JOIN (SELECT MAX(create_time) create_time, order_id
                    FROM (ods.shebaotong.sbt_order_record FOR SYSTEM_TIME AS OF '${snap_date}')
                    WHERE oprt_node = 15
                    GROUP BY order_id) Q ON Q.order_id = A.id
         LEFT JOIN (SELECT order_id,max(sipr_tax_rate) AS sipr_tax_rate, max(tax_rate) AS tax_rate
                    FROM (ods.shebaotong.sbt_order_subject FOR SYSTEM_TIME AS OF '${snap_date}')
                    WHERE fee_type = 1
                    GROUP BY order_id) R ON R.order_id = A.id AND A.sbt_order_id = 0
         LEFT JOIN (ods.sbt_prod.ec_order FOR SYSTEM_TIME AS OF '${snap_date}') S
                   ON A.sbt_order_id = S.order_id
         LEFT JOIN (ods.sbt_prod.ec_order_second_socialins FOR SYSTEM_TIME AS OF '${snap_date}') U
                   ON S.order_id = U.order_id AND U.emp_id = C.sbt_emp_id AND
                      IF(U.insurance_type = 'shebao', 1, 2) = B.ins_type AND
                      U.account_status = 'keep'
         LEFT JOIN (ods.sbt_prod.supplier_info FOR SYSTEM_TIME AS OF '${snap_date}') V
                   ON U.supplier_id = V.supplier_id
WHERE (
        (A.confirm_flag = '1' AND
         ((A.order_type = 1) OR (M.bill_state = 2 AND A.order_type = 2 AND A.sbt_order_id != 0)) AND
         (
                 (A.area_order_month = '${report_month}' AND
                  DATE_FORMAT(IF(Q.order_id = A.id, Q.create_time, A.confirm_time), 'yyyyMM') <= '${report_month}')
                 OR
                 (A.area_order_month <= '${report_month}' AND
                  DATE_FORMAT(IF(Q.order_id = A.id, Q.create_time, A.confirm_time), 'yyyyMM') = '${report_month}')
             ) AND A.service_type != 51
            )
        OR
        (M.bill_state = 2 AND A.order_type = 2 AND A.sbt_order_id = 0 AND
         (
                 (M.bill_month = '${report_month}' AND
                  IF(A.sbt_order_id != 0, DATE_FORMAT(A.create_time, 'yyyyMM') <= '${report_month}',
                     DATE_FORMAT(L.create_time, 'yyyyMM') <= '${report_month}') OR
                  DATE_FORMAT(M.bill_time, 'yyyyMM') <= '${report_month}')
                 OR
                 (M.bill_month <= '${report_month}' AND
                  IF(A.sbt_order_id != 0, DATE_FORMAT(A.create_time, 'yyyyMM') = '${report_month}',
                     DATE_FORMAT(L.create_time, 'yyyyMM') = '${report_month}') OR DATE_FORMAT(M.bill_time, 'yyyyMM') = '${report_month}')
             )
            )
        OR
        (
                    A.confirm_flag = '1' AND DATE_FORMAT(P.out_time, 'yyyyMM') = '${report_month}' AND O.bill_has = 1
            )
        OR
        (
                    M.bill_state = 2 AND A.order_type = 2 AND A.sbt_order_id != 0 AND
                    (M.bill_month = '${report_month}' OR DATE_FORMAT(M.bill_time, 'yyyyMM') = '${report_month}')
            )
    )
  AND A.order_no NOT IN (SELECT T.order_no
                         FROM (ods.shebaotong.sbt_order FOR SYSTEM_TIME AS OF '${snap_date}') T
                         WHERE T.order_state = 5
                           AND T.order_type = 2
                           AND T.id != L.order_id)
  AND A.order_no NOT IN (SELECT W.order_no
                         FROM (ods.shebaotong.sbt_order FOR SYSTEM_TIME AS OF '${snap_date}') W
                         WHERE A.order_state = 5
                           AND DATE_FORMAT(H.confirm_time, 'yyyyMM') != DATE_FORMAT(Q.create_time, 'yyyyMM')
                           AND A.order_type = 1
                           AND A.area_order_month != '${report_month}')
  AND A.order_no NOT IN (SELECT X.order_no
                         FROM (ods.shebaotong.sbt_order FOR SYSTEM_TIME AS OF '${snap_date}') X
                         WHERE A.order_state = 5
                           AND DATE_FORMAT(H.confirm_time, 'yyyyMM') != DATE_FORMAT(Q.create_time, 'yyyyMM')
                           AND A.order_type = 2
                           AND A.area_order_month != '${report_month}'
                           AND M.bill_month != '${report_month}'
                           AND DATE_FORMAT(M.bill_time, 'yyyyMM') != '${report_month}');
