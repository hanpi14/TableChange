DELETE FROM dwd_ar_mi WHERE data_source=16;

INSERT INTO dwd_ar_mi(data_source, ar_no, raw_ar_no, is_split, is_discard, is_ignore, is_cross, ar_title, income_type,
                      order_no,
                      member_code,
                      member_name,
                      order_month, raw_order_month,
                      region, raw_region, party_b, product_name, income_invoice, income_ar_order, income_reward,
                      income_reward_net, serve_count_net, serve_emp_count, serve_emp_count_net, serve_count,
                      invoice_tax_rate, reward_tax_rate, serve_emp_id, sale_emp_id, serve_dept_id, sale_dept_id,
                      raw_create_time, raw_confirm_time, est_pay_date, is_invoiced, is_paid, is_confirmed)

SELECT 16                                 AS data_source,
       A.receive_no                       AS ar_no,
       A.raw_receive_no                   AS raw_ar_no,
       IF(A.buss_type = 1, 0, 1)          AS is_split,
       A.is_discard                       AS is_discard,
       A.is_ignore                        AS is_ignore,
       IF(A.order_month < '202405', 1, 0) AS is_cross,
       A.receive_title                    AS ar_title,
       A.income_type                      AS income_type,
       A.source_no                        AS order_no,
       A.member_code                      AS member_code,
       A.member_name                      AS member_name,
       '202405'                           AS order_month,
       A.order_month                      AS raw_order_month,
       IFNULL(CASE
                  WHEN A.area_name LIKE '%（%' THEN SUBSTRING_INDEX(A.area_name, '（', 1)
                  WHEN A.area_name = '重庆WK' THEN '重庆'
                  ELSE A.area_name
                  END, '上海')            AS region,
       IFNULL(A.area_name, '上海')        AS raw_region,
       A.org_name                         AS party_b,
       A.product_name                     AS product_name,
       A.fee_amount                       AS income_invoice,
       A.fee_total                        AS income_ar_order,
       A.service_amount                   AS income_reward,
       A.service_amount_no_tax            AS income_reward_net,
       A.service_count                    AS serve_count_net,
       A.people_total                     AS serve_emp_count,
       A.servicing_people_count           AS serve_emp_count_net,
       A.servicing_count                  AS serve_count,
       IFNULL(A.invoice_tax_rate, 0)      AS invoice_tax_rate,
       A.tax_rate                         AS reward_tax_rate,
       IFNULL(A.serve_emp_id, -1)         AS serve_emp_id,
       IFNULL(A.sale_emp_id, -1)          AS sale_emp_id,
       IFNULL(A.serve_dept_id, -1)        AS serve_dept_id,
       IFNULL(A.sale_dept_id, -1)         AS sale_dept_id,
       A.create_time                      AS raw_create_time,
       A.confirm_time                     AS raw_confirm_time,
       A.last_pay_date                    AS est_pay_date,
       IF(A.invoice_status = 2, 1, 0)     AS is_invoiced,
       IF(A.check_status = 1, 1, 0)       AS is_paid,
       IF(A.confirm_status = 1, 1, 0)     AS is_confirmed
FROM (SELECT R.*,
             IF(N.receive_no IS NULL, R.receive_no, N.receive_no)                             AS raw_receive_no,
             CONCAT(T.pr_name, '(', U.dic_text, ')', '(', V.dic_text, ')')                    AS product_name,
             W.member_code,
             CASE T.open_invoice_type WHEN 1 THEN 2 WHEN 2 THEN 1 END                         AS income_type,
             W.member_name,
             X.org_name,
             Y.area_name,
             IF(Z.receive_id IS NULL, 0, 1)                                                   AS is_discard,
             IF(Z.receive_id IS NULL AND R.alive_flag = '1' AND R.confirm_status = '1', 0, 1) AS is_ignore,
             T.tax_rate                                                                       AS invoice_tax_rate,
             IFNULL(R.service_emp, S.service_emp)                                             AS serve_emp_id,
             IFNULL(R.achie_emp, S.achie_emp)                                                 AS sale_emp_id,
             IFNULL(R.hr_service_dept, S.hr_service_dept)                                     AS serve_dept_id,
             IFNULL(R.hr_achie_dept, S.hr_achie_dept)                                         AS sale_dept_id
      FROM (SELECT O.*
            FROM ods.sbt_prod.fnc_receivable_account O
                     INNER JOIN (SELECT *
                                 FROM ods.shebaotong.sbt_order S
                                 WHERE DATE_FORMAT(S.create_time, 'yyyyMM') = S.area_order_month
                                   AND DATE_FORMAT(S.confirm_time, 'yyyyMM') = '202405') P
                                ON O.order_no = P.order_no AND O.alive_flag = 1
            WHERE DATE_FORMAT(O.confirm_time, 'yyyyMM') <=
                  DATE_FORMAT(add_months(P.confirm_time, -1), 'yyyyMM')
              AND DATE_FORMAT(O.create_time, 'yyyyMM') <= '202405'
              AND O.source_no NOT IN (SELECT H.order_no
                                      FROM ods.shebaotong.sbt_order H
                                      WHERE H.confirm_flag = '0')) R
               LEFT JOIN
           ods.sbt_prod.mbc_member_product S ON R.m_pr_id = S.m_pr_id
               LEFT JOIN ods.sbt_prod.basic_org_product T ON S.pr_id = T.pr_id
               LEFT JOIN ods.sbt_prod.sys_dictionary_dtl U
                         ON T.service_type = U.dic_value AND U.dic_code = 'PR_SERVICE_TYPE'
               LEFT JOIN ods.sbt_prod.sys_dictionary_dtl V
                         ON T.service_code = V.dic_value AND V.dic_code = 'PR_SERVICE_CODE'
               LEFT JOIN ods.sbt_prod.mbc_member_info W ON R.member_id = W.member_id
               LEFT JOIN ods.sbt_prod.oprt_boss_organization X ON R.org_id = X.org_id
               LEFT JOIN ods.sbt_prod.basic_ins_area Y ON R.area_code = Y.area_code
               LEFT JOIN ods.sbt_prod.oprt_bill_manual_handle Z ON R.receive_id = Z.receive_id
               LEFT JOIN ods.sbt_prod.fnc_receivable_account N ON R.parent_id = N.receive_id
      WHERE V.dic_value != 'inter') A;
