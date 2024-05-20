DELETE
FROM dwd_order_emp_online_mi
WHERE order_type = 1
  AND is_sup = 1
  AND is_extra = 0
  AND data_source IN (4, 9)
  AND is_refund = 0
  AND order_item = '补充费用';

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
    comment, raw_order_no, batch_no)

SELECT IF(M.bill_no IS NULL, IF(O.order_no = A.order_no AND O.valid = 1, 10, 4), 9)                     AS data_source,
       A.order_no                                                                                       AS order_no,
       1                                                                                                AS order_type,
       IF(E.virtual_flag = 0, CASE J.open_invoice_type
                                  WHEN 1 THEN 8
                                  WHEN 2 THEN IF(N.dic_value = '2' OR N.dic_value = '3', 2, 1) END, -1) AS business_type,
       IFNULL(IF(A.receive_no = '', M.receive_no, A.receive_no), '')                                    AS ar_no,
       '202311'                                                                                         AS order_month,
       A.area_order_month                                                                               AS raw_order_month,
       A.area_order_month                                                                               AS fee_month,
       E.member_code                                                                                    AS member_code,
       E.member_name                                                                                    AS member_name,
       D.org_name                                                                                       AS party_b,
       REPLACE(UUID(), _utf8'-', _utf8'')                                                               AS emp_name,
       REPLACE(UUID(), _utf8'-', _utf8'')                                                               AS emp_id_no,
       ''                                                                                               AS mobile,
       CASE
           WHEN F.area_name LIKE '%（%' THEN SUBSTRING_INDEX(F.area_name, '（', 1)
           WHEN F.area_name = '重庆WK' THEN '重庆'
           ELSE F.area_name
           END                                                                                         AS region,
       F.area_name                                                                                     AS raw_region,
       CASE
           WHEN F.area_name LIKE '%（%' THEN SUBSTRING_INDEX(F.area_name, '（', 1)
           WHEN F.area_name = '重庆WK' THEN '重庆'
           ELSE F.area_name
           END                                                                                         AS order_region,
       F.area_name                                                                                     AS raw_order_region,
       '补充费用'                                                                                      AS order_item,
       CASE
           WHEN A.ods_sbt_order_20240411_id != 0 THEN ABS(S.daishou_tax_rate)
           WHEN A.ods_sbt_order_20240411_id = 0 AND R.sipr_tax_rate != 0 THEN R.sipr_tax_rate
           WHEN A.ods_sbt_order_20240411_id = 0 AND R.tax_rate != 0 THEN R.tax_rate
           WHEN O.order_no = A.order_no AND O.valid = 1 THEN I.tax_rate
           ELSE 0 END                                                                                  AS order_tax_rate,
       I.tax_rate                                                                                      AS reward_tax_rate,
       IF(A.account_property = 2, 1, 0)                                                                AS is_solo,
       IF(A.account_property = 2, 0, 1)                                                                AS is_collect,
       IF(A.area_order_month < '202311', 1, 0)                                                         AS is_cross,
       0                                                                                               AS is_refund,
       0                                                                                               AS is_extra,
       1                                                                                               AS is_sup,
       0                                                                                               AS is_cancel,
       0                                                                                               AS is_diff,
       0                                                                                               AS is_ignore,
       0                                                                                               AS is_discard,
       CASE J.open_invoice_type WHEN 1 THEN 2 WHEN 2 THEN 1 END                                        AS income_type,
       IF(B.invoice_subject = 'service', B.add_fee, 0)                                                 AS income_reward,
       IF(B.invoice_subject = 'service', B.add_fee, 0)                                                 AS raw_income_reward,
       IF(B.invoice_subject = 'service', 0, IF(J.open_invoice_type = 1, B.add_fee_no_tax, B.add_fee))  AS income_order,
       IF(B.invoice_subject = 'service', 0,
          IF(J.open_invoice_type = 1, B.add_fee_no_tax, B.add_fee))                                    AS raw_income_order,
       0                                                                                               AS income_overdue,
       0                                                                                               AS income_disabled,
       0                                                                                               AS income_added_tax,
       0                                                                                               AS income_stable,
       0                                                                                               AS income_indv_tax,
       1                                                                                               AS serve_count,
       ''                                                                                              AS supplier_code,
       ''                                                                                              AS supplier_name,
       1                                                                                               AS cost_type,
       0                                                                                               AS cost_reward,
       ''                                                                                              AS sale_emp_name,
       IFNULL(H.service_emp, -1)                                                                       AS serve_emp_id,
       IFNULL(H.achie_emp, -1)                                                                         AS sale_emp_id,
       IFNULL(H.hr_service_dept, -1)                                                                   AS serve_dept_id,
       IFNULL(H.hr_achie_dept, -1)                                                                     AS sale_dept_id,
       0                                                                                               AS order_parm,
       0                                                                                               AS indv_net_pay,
       0                                                                                               AS indv_income_tax,
       0                                                                                               AS income_indv_order,
       0                                                                                               AS income_corp_order,
       0                                                                                               AS corp_pension_amount,
       0                                                                                               AS corp_pension_rate,
       0                                                                                               AS indv_pension_amount,
       0                                                                                               AS indv_pension_rate,
       0                                                                                               AS corp_illness_amount,
       0                                                                                               AS corp_illness_rate,
       0                                                                                               AS indv_illness_amount,
       0                                                                                               AS indv_illness_rate,
       0                                                                                               AS corp_work_amount,
       0                                                                                               AS corp_work_rate,
       0                                                                                               AS indv_work_amount,
       0                                                                                               AS indv_work_rate,
       0                                                                                               AS corp_unemployed_amount,
       0                                                                                               AS corp_unemployed_rate,
       0                                                                                               AS indv_unemployed_amount,
       0                                                                                               AS indv_unemployed_rate,
       0                                                                                               AS corp_birth_amount,
       0                                                                                               AS corp_birth_rate,
       0                                                                                               AS indv_birth_amount,
       0                                                                                               AS indv_birth_rate,
       0                                                                                               AS corp_disabled_amount,
       0                                                                                               AS corp_disabled_rate,
       0                                                                                               AS indv_disabled_amount,
       0                                                                                               AS indv_disabled_rate,
       0                                                                                               AS corp_serious_illness_amount,
       0                                                                                               AS corp_serious_illness_rate,
       0                                                                                               AS indv_serious_illness_amount,
       0                                                                                               AS indv_serious_illness_rate,
       0                                                                                               AS corp_ext_illness_amount,
       0                                                                                               AS corp_ext_illness_rate,
       0                                                                                               AS indv_ext_illness_amount,
       0                                                                                               AS indv_ext_illness_rate,
       0                                                                                               AS corp_hospital_amount,
       0                                                                                               AS corp_hospital_rate,
       0                                                                                               AS indv_hospital_amount,
       0                                                                                               AS indv_hospital_rate,
       0                                                                                               AS corp_fund_amount,
       0                                                                                               AS corp_fund_rate,
       0                                                                                               AS indv_fund_amount,
       0                                                                                               AS indv_fund_rate,
       0                                                                                               AS indv_union_amount,
       0                                                                                               AS indv_other_amount,
       0                                                                                               AS corp_other_amount,
       ''                                                                                              AS debit_card_no,
       ''                                                                                              AS bank_name,
       ''                                                                                              AS bank_region,
       ''                                                                                              AS tax_corp,
       A.create_time                                                                                   AS raw_create_time,
       ''                                                                                              AS comment,
       #        ''                                                                                              AS raw_order_no,
        COALESCE(IF(A.ods_sbt_order_20240411_id = 0 OR M.ods_sbt_bill_20240412_id = 0, M.bill_no,
                    REPLACE(UUID(), _utf8'-', _utf8'')), P.bill_no, REPLACE(UUID(), _utf8'-', _utf8'')) AS batch_no
FROM ods_sbt_order_20240411 A
         INNER JOIN ods_sbt_order_add_fee_20240411 B
                    ON A.id = B.order_id
         LEFT JOIN ods_oprt_boss_organization_20240411 D
                   ON A.org_id = D.org_id
         INNER JOIN ods_mbc_member_info_20240411 E
                    ON A.member_id = E.member_id
         LEFT JOIN ods_basic_ins_area_20240411 F
                   ON A.area_id = F.area_id
    --  LEFT JOIN ods_basic_ins_area_20240411 G ON B.area_id = G.area_id
         LEFT JOIN ods_mbc_member_product_20240411 I
                   ON A.member_product_id = I.m_pr_id
         LEFT JOIN ods_basic_org_product_20240411 J
                   ON J.pr_id = I.pr_id
    --  LEFT JOIN ods_supplier_info_20240411 K ON B.vendor_id = K.supplier_id
         LEFT JOIN ods_sys_dictionary_dtl_20240411 N
                   ON A.service_type = N.dic_value AND N.dic_code = 'PR_SERVICE_TYPE'
         LEFT JOIN ods_sbt_bill_dtl_20240411 L
                   ON A.id = L.order_id AND L.data_type = 1 AND L.alive_flag = 1
         LEFT JOIN ods_sbt_bill_20240411 M
                   ON L.bill_id = M.id
         LEFT JOIN ods_fnc_receivable_account_20240411 H
                   ON IF(A.receive_no = '', M.receive_no, A.receive_no) = H.receive_no
         LEFT JOIN ods_hro_bill_constitute_20240411 O
                   ON O.order_no = A.order_no AND O.valid = 1
         LEFT JOIN ods_hro_bill_20240411 P
                   ON O.bill_id = P.id AND P.valid = 1
         LEFT JOIN (SELECT MAX(create_time) create_time, order_id
                    FROM ods_sbt_order_record_20240411
                    WHERE oprt_node = 15
                    GROUP BY order_id) Q ON Q.order_id = A.id
         LEFT JOIN (SELECT order_id, sipr_tax_rate, tax_rate
                    FROM ods_sbt_order_subject_20240411
                    WHERE fee_type = 1
                    GROUP BY order_id) R ON R.order_id = A.id AND A.ods_sbt_order_20240411_id = 0
         LEFT JOIN ods_ec_order_20240411 S #订单
ON A.ods_sbt_order_20240411_id = S.order_id
WHERE (
    (A.confirm_flag = '1' AND
    ((A.order_type = 1) OR (M.bill_state = 2 AND A.order_type = 2 AND A.ods_sbt_order_20240411_id != 0)) AND
    (
    (A.area_order_month = '202311' AND
    DATE_FORMAT(IF(Q.order_id = A.id, Q.create_time, A.confirm_time), '%Y%m') <= '202311')
   OR
    (A.area_order_month <= '202311' AND
    DATE_FORMAT(IF(Q.order_id = A.id, Q.create_time, A.confirm_time), '%Y%m') = '202311')
    ) AND A.service_type != 51
    )
   OR
    (
    M.bill_state = 2 AND A.order_type = 2 AND A.ods_sbt_order_20240411_id = 0 AND
    (
    (M.bill_month = '202311' AND
    IF(A.ods_sbt_order_20240411_id != 0, DATE_FORMAT(A.create_time, '%Y%m') <= '202311',
    DATE_FORMAT(L.create_time, '%Y%m') <= '202311') OR DATE_FORMAT(M.bill_time, '%Y%m') <= '202311')
   OR
    (M.bill_month <= '202311' AND
    IF(A.ods_sbt_order_20240411_id != 0, DATE_FORMAT(A.create_time, '%Y%m') = '202311',
    DATE_FORMAT(L.create_time, '%Y%m') = '202311') OR DATE_FORMAT(M.bill_time, '%Y%m') = '202311')
    )
    )
   OR
    (
    A.confirm_flag = '1' AND DATE_FORMAT(P.out_time, '%Y%m') = '202311' AND O.bill_has = 1
    )
   OR
    (
    M.bill_state = 2 AND A.order_type = 2 AND A.ods_sbt_order_20240411_id != 0 AND
    (M.bill_month = '202312' OR DATE_FORMAT(M.bill_time, '%Y%m') = '202312')
    )
    )
  AND A.order_no NOT IN (SELECT T.order_no
    FROM ods_sbt_order_20240411 T
    WHERE T.order_state = 5
  AND T.order_type = 2
  AND T.id != L.order_id)
  AND A.order_no NOT IN (SELECT W.order_no
    FROM ods_sbt_order_20240411 W
    WHERE A.order_state = 5
  AND DATE_FORMAT(H.confirm_time, '%Y%m') != DATE_FORMAT(Q.create_time, '%Y%m')
  AND A.order_type = 1
  AND A.area_order_month != '202312')
  AND A.order_no NOT IN (SELECT X.order_no
    FROM ods_sbt_order_20240411 X
    WHERE A.order_state = 5
  AND DATE_FORMAT(H.confirm_time, '%Y%m') != DATE_FORMAT(Q.create_time, '%Y%m')
  AND A.order_type = 2
  AND A.area_order_month != '202312'
  AND M.bill_month != '202312'
  AND DATE_FORMAT(M.bill_time, '%Y%m') != '202312')
;