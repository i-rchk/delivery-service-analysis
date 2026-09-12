-- Marketing Metrics
-- Comparison of two advertising campaigns
-- Dataset: delivery service / Karpov.Courses

/* ============================================================
   1. CAC — Customer Acquisition Cost
   ============================================================ */

with camp_1 as (
    select
        count(distinct user_id) as users_count_1,
        'Кампания № 1' as ads_campaign
    from user_actions
    where user_id in (
        8631, 8632, 8638, 8643, 8657, 8673, 8706, 8707, 8715, 8723, 8732,
        8739, 8741, 8750, 8751, 8752, 8770, 8774, 8788, 8791, 8804, 8810,
        8815, 8828, 8830, 8845, 8853, 8859, 8867, 8869, 8876, 8879, 8883,
        8896, 8909, 8911, 8933, 8940, 8972, 8976, 8988, 8990, 9002, 9004,
        9009, 9019, 9020, 9035, 9036, 9061, 9069, 9071, 9075, 9081, 9085,
        9089, 9108, 9113, 9144, 9145, 9146, 9162, 9165, 9167, 9175, 9180,
        9182, 9197, 9198, 9210, 9223, 9251, 9257, 9278, 9287, 9291, 9313,
        9317, 9321, 9334, 9351, 9391, 9398, 9414, 9420, 9422, 9431, 9450,
        9451, 9454, 9472, 9476, 9478, 9491, 9494, 9505, 9512, 9518, 9524,
        9526, 9528, 9531, 9535, 9550, 9559, 9561, 9562, 9599, 9603, 9605,
        9611, 9612, 9615, 9625, 9633, 9652, 9654, 9655, 9660, 9662, 9667,
        9677, 9679, 9689, 9695, 9720, 9726, 9739, 9740, 9762, 9778, 9786,
        9794, 9804, 9810, 9813, 9818, 9828, 9831, 9836, 9838, 9845, 9871,
        9887, 9891, 9896, 9897, 9916, 9945, 9960, 9963, 9965, 9968, 9971,
        9993, 9998, 9999, 10001, 10013, 10016, 10023, 10030, 10051, 10057,
        10064, 10082, 10103, 10105, 10122, 10134, 10135
    )
    and order_id not in (
        select order_id
        from user_actions
        where action = 'cancel_order'
    )
),
camp_2 as (
    select
        count(distinct user_id) as users_count_2,
        'Кампания № 2' as ads_campaign
    from user_actions
    where user_id in (
        8629, 8630, 8644, 8646, 8650, 8655, 8659, 8660, 8663, 8665, 8670,
        8675, 8680, 8681, 8682, 8683, 8694, 8697, 8700, 8704, 8712, 8713,
        8719, 8729, 8733, 8742, 8748, 8754, 8771, 8794, 8795, 8798, 8803,
        8805, 8806, 8812, 8814, 8825, 8827, 8838, 8849, 8851, 8854, 8855,
        8870, 8878, 8882, 8886, 8890, 8893, 8900, 8902, 8913, 8916, 8923,
        8929, 8935, 8942, 8943, 8949, 8953, 8955, 8966, 8968, 8971, 8973,
        8980, 8995, 8999, 9000, 9007, 9013, 9041, 9042, 9047, 9064, 9068,
        9077, 9082, 9083, 9095, 9103, 9109, 9117, 9123, 9127, 9131, 9137,
        9140, 9149, 9161, 9179, 9181, 9183, 9185, 9190, 9196, 9203, 9207,
        9226, 9227, 9229, 9230, 9231, 9250, 9255, 9259, 9267, 9273, 9281,
        9282, 9289, 9292, 9303, 9310, 9312, 9315, 9327, 9333, 9335, 9337,
        9343, 9356, 9368, 9370, 9383, 9392, 9404, 9410, 9421, 9428, 9432,
        9437, 9468, 9479, 9483, 9485, 9492, 9495, 9497, 9498, 9500, 9510,
        9527, 9529, 9530, 9538, 9539, 9545, 9557, 9558, 9560, 9564, 9567,
        9570, 9591, 9596, 9598, 9616, 9631, 9634, 9635, 9636, 9658, 9666,
        9672, 9684, 9692, 9700, 9704, 9706, 9711, 9719, 9727, 9735, 9741,
        9744, 9749, 9752, 9753, 9755, 9757, 9764, 9783, 9784, 9788, 9790,
        9808, 9820, 9839, 9841, 9843, 9853, 9855, 9859, 9863, 9877, 9879,
        9880, 9882, 9883, 9885, 9901, 9904, 9908, 9910, 9912, 9920, 9929,
        9930, 9935, 9939, 9958, 9959, 9961, 9983, 10027, 10033, 10038,
        10045, 10047, 10048, 10058, 10059, 10067, 10069, 10073, 10075,
        10078, 10079, 10081, 10092, 10106, 10110, 10113, 10131
    )
    and order_id not in (
        select order_id
        from user_actions
        where action = 'cancel_order'
    )
)
select
    ads_campaign,
    round(250000 / users_count_1::numeric, 2) as cac
from camp_1
union all
select
    ads_campaign,
    round(250000 / users_count_2::numeric, 2) as cac
from camp_2
order by cac desc;


/* ============================================================
   2. ROI — Return on Investment
   ============================================================ */

with users_camp_1 as (
    select distinct user_id, 'Кампания № 1' as ads_campaign
    from user_actions
    where user_id in (
        8631, 8632, 8638, 8643, 8657, 8673, 8706, 8707, 8715, 8723, 8732,
        8739, 8741, 8750, 8751, 8752, 8770, 8774, 8788, 8791, 8804, 8810,
        8815, 8828, 8830, 8845, 8853, 8859, 8867, 8869, 8876, 8879, 8883,
        8896, 8909, 8911, 8933, 8940, 8972, 8976, 8988, 8990, 9002, 9004,
        9009, 9019, 9020, 9035, 9036, 9061, 9069, 9071, 9075, 9081, 9085,
        9089, 9108, 9113, 9144, 9145, 9146, 9162, 9165, 9167, 9175, 9180,
        9182, 9197, 9198, 9210, 9223, 9251, 9257, 9278, 9287, 9291, 9313,
        9317, 9321, 9334, 9351, 9391, 9398, 9414, 9420, 9422, 9431, 9450,
        9451, 9454, 9472, 9476, 9478, 9491, 9494, 9505, 9512, 9518, 9524,
        9526, 9528, 9531, 9535, 9550, 9559, 9561, 9562, 9599, 9603, 9605,
        9611, 9612, 9615, 9625, 9633, 9652, 9654, 9655, 9660, 9662, 9667,
        9677, 9679, 9689, 9695, 9720, 9726, 9739, 9740, 9762, 9778, 9786,
        9794, 9804, 9810, 9813, 9818, 9828, 9831, 9836, 9838, 9845, 9871,
        9887, 9891, 9896, 9897, 9916, 9945, 9960, 9963, 9965, 9968, 9971,
        9993, 9998, 9999, 10001, 10013, 10016, 10023, 10030, 10051, 10057,
        10064, 10082, 10103, 10105, 10122, 10134, 10135
    )
    and order_id not in (select order_id from user_actions where action = 'cancel_order')
),
users_camp_2 as (
    select distinct user_id, 'Кампания № 2' as ads_campaign
    from user_actions
    where user_id in (
        8629, 8630, 8644, 8646, 8650, 8655, 8659, 8660, 8663, 8665, 8670,
        8675, 8680, 8681, 8682, 8683, 8694, 8697, 8700, 8704, 8712, 8713,
        8719, 8729, 8733, 8742, 8748, 8754, 8771, 8794, 8795, 8798, 8803,
        8805, 8806, 8812, 8814, 8825, 8827, 8838, 8849, 8851, 8854, 8855,
        8870, 8878, 8882, 8886, 8890, 8893, 8900, 8902, 8913, 8916, 8923,
        8929, 8935, 8942, 8943, 8949, 8953, 8955, 8966, 8968, 8971, 8973,
        8980, 8995, 8999, 9000, 9007, 9013, 9041, 9042, 9047, 9064, 9068,
        9077, 9082, 9083, 9095, 9103, 9109, 9117, 9123, 9127, 9131, 9137,
        9140, 9149, 9161, 9179, 9181, 9183, 9185, 9190, 9196, 9203, 9207,
        9226, 9227, 9229, 9230, 9231, 9250, 9255, 9259, 9267, 9273, 9281,
        9282, 9289, 9292, 9303, 9310, 9312, 9315, 9327, 9333, 9335, 9337,
        9343, 9356, 9368, 9370, 9383, 9392, 9404, 9410, 9421, 9428, 9432,
        9437, 9468, 9479, 9483, 9485, 9492, 9495, 9497, 9498, 9500, 9510,
        9527, 9529, 9530, 9538, 9539, 9545, 9557, 9558, 9560, 9564, 9567,
        9570, 9591, 9596, 9598, 9616, 9631, 9634, 9635, 9636, 9658, 9666,
        9672, 9684, 9692, 9700, 9704, 9706, 9711, 9719, 9727, 9735, 9741,
        9744, 9749, 9752, 9753, 9755, 9757, 9764, 9783, 9784, 9788, 9790,
        9808, 9820, 9839, 9841, 9843, 9853, 9855, 9859, 9863, 9877, 9879,
        9880, 9882, 9883, 9885, 9901, 9904, 9908, 9910, 9912, 9920, 9929,
        9930, 9935, 9939, 9958, 9959, 9961, 9983, 10027, 10033, 10038,
        10045, 10047, 10048, 10058, 10059, 10067, 10069, 10073, 10075,
        10078, 10079, 10081, 10092, 10106, 10110, 10113, 10131
    )
    and order_id not in (select order_id from user_actions where action = 'cancel_order')
),
orders_price as (
    select user_id, sum(price) as user_paid
    from (
        select user_id, order_id, price
        from (
            select order_id, unnest(product_ids) as product_id, user_id
            from orders
            left join user_actions using(order_id)
            where order_id not in (
                select order_id from user_actions where action = 'cancel_order'
            )
        ) t
        left join products using(product_id)
    ) t2
    group by user_id
),
camp_1 as (
    select ads_campaign, sum(user_paid) as camp_revenue
    from users_camp_1
    left join orders_price using(user_id)
    group by ads_campaign
),
camp_2 as (
    select ads_campaign, sum(user_paid) as camp_revenue
    from users_camp_2
    left join orders_price using(user_id)
    group by ads_campaign
)
select
    ads_campaign,
    round((camp_revenue - 250000)::numeric / 250000 * 100, 2) as roi
from camp_1
union all
select
    ads_campaign,
    round((camp_revenue - 250000)::numeric / 250000 * 100, 2) as roi
from camp_2
order by roi desc;


/* ============================================================
   3. Average Check — first week of the campaigns
   ============================================================ */

with users_camp_1 as (
    select distinct user_id, 'Кампания № 1' as ads_campaign
    from user_actions
    where user_id in (
        8631, 8632, 8638, 8643, 8657, 8673, 8706, 8707, 8715, 8723, 8732,
        8739, 8741, 8750, 8751, 8752, 8770, 8774, 8788, 8791, 8804, 8810,
        8815, 8828, 8830, 8845, 8853, 8859, 8867, 8869, 8876, 8879, 8883,
        8896, 8909, 8911, 8933, 8940, 8972, 8976, 8988, 8990, 9002, 9004,
        9009, 9019, 9020, 9035, 9036, 9061, 9069, 9071, 9075, 9081, 9085,
        9089, 9108, 9113, 9144, 9145, 9146, 9162, 9165, 9167, 9175, 9180,
        9182, 9197, 9198, 9210, 9223, 9251, 9257, 9278, 9287, 9291, 9313,
        9317, 9321, 9334, 9351, 9391, 9398, 9414, 9420, 9422, 9431, 9450,
        9451, 9454, 9472, 9476, 9478, 9491, 9494, 9505, 9512, 9518, 9524,
        9526, 9528, 9531, 9535, 9550, 9559, 9561, 9562, 9599, 9603, 9605,
        9611, 9612, 9615, 9625, 9633, 9652, 9654, 9655, 9660, 9662, 9667,
        9677, 9679, 9689, 9695, 9720, 9726, 9739, 9740, 9762, 9778, 9786,
        9794, 9804, 9810, 9813, 9818, 9828, 9831, 9836, 9838, 9845, 9871,
        9887, 9891, 9896, 9897, 9916, 9945, 9960, 9963, 9965, 9968, 9971,
        9993, 9998, 9999, 10001, 10013, 10016, 10023, 10030, 10051, 10057,
        10064, 10082, 10103, 10105, 10122, 10134, 10135
    )
    and order_id not in (select order_id from user_actions where action = 'cancel_order')
),
users_camp_2 as (
    select distinct user_id, 'Кампания № 2' as ads_campaign
    from user_actions
    where user_id in (
        8629, 8630, 8644, 8646, 8650, 8655, 8659, 8660, 8663, 8665, 8670,
        8675, 8680, 8681, 8682, 8683, 8694, 8697, 8700, 8704, 8712, 8713,
        8719, 8729, 8733, 8742, 8748, 8754, 8771, 8794, 8795, 8798, 8803,
        8805, 8806, 8812, 8814, 8825, 8827, 8838, 8849, 8851, 8854, 8855,
        8870, 8878, 8882, 8886, 8890, 8893, 8900, 8902, 8913, 8916, 8923,
        8929, 8935, 8942, 8943, 8949, 8953, 8955, 8966, 8968, 8971, 8973,
        8980, 8995, 8999, 9000, 9007, 9013, 9041, 9042, 9047, 9064, 9068,
        9077, 9082, 9083, 9095, 9103, 9109, 9117, 9123, 9127, 9131, 9137,
        9140, 9149, 9161, 9179, 9181, 9183, 9185, 9190, 9196, 9203, 9207,
        9226, 9227, 9229, 9230, 9231, 9250, 9255, 9259, 9267, 9273, 9281,
        9282, 9289, 9292, 9303, 9310, 9312, 9315, 9327, 9333, 9335, 9337,
        9343, 9356, 9368, 9370, 9383, 9392, 9404, 9410, 9421, 9428, 9432,
        9437, 9468, 9479, 9483, 9485, 9492, 9495, 9497, 9498, 9500, 9510,
        9527, 9529, 9530, 9538, 9539, 9545, 9557, 9558, 9560, 9564, 9567,
        9570, 9591, 9596, 9598, 9616, 9631, 9634, 9635, 9636, 9658, 9666,
        9672, 9684, 9692, 9700, 9704, 9706, 9711, 9719, 9727, 9735, 9741,
        9744, 9749, 9752, 9753, 9755, 9757, 9764, 9783, 9784, 9788, 9790,
        9808, 9820, 9839, 9841, 9843, 9853, 9855, 9859, 9863, 9877, 9879,
        9880, 9882, 9883, 9885, 9901, 9904, 9908, 9910, 9912, 9920, 9929,
        9930, 9935, 9939, 9958, 9959, 9961, 9983, 10027, 10033, 10038,
        10045, 10047, 10048, 10058, 10059, 10067, 10069, 10073, 10075,
        10078, 10079, 10081, 10092, 10106, 10110, 10113, 10131
    )
    and order_id not in (select order_id from user_actions where action = 'cancel_order')
),
avg_price_camp_1 as (
    select round(avg(avg_order_price), 2) as avg_check
    from (
        select user_id, avg(order_price) as avg_order_price
        from (
            select user_id, order_id, sum(price) as order_price
            from (
                select user_id, order_id, price
                from (
                    select order_id, unnest(product_ids) as product_id, user_id
                    from orders
                    left join user_actions using(order_id)
                    where order_id not in (
                        select order_id from user_actions where action = 'cancel_order'
                    )
                    and creation_time >= '2022-09-01'
                    and creation_time < '2022-09-08'
                ) t
                left join products using(product_id)
            ) t2
            where user_id in (select user_id from users_camp_1)
            group by order_id, user_id
        ) t3
        group by user_id
    ) t4
),
avg_price_camp_2 as (
    select round(avg(avg_order_price), 2) as avg_check
    from (
        select user_id, avg(order_price) as avg_order_price
        from (
            select user_id, order_id, sum(price) as order_price
            from (
                select user_id, order_id, price
                from (
                    select order_id, unnest(product_ids) as product_id, user_id
                    from orders
                    left join user_actions using(order_id)
                    where order_id not in (
                        select order_id from user_actions where action = 'cancel_order'
                    )
                    and creation_time >= '2022-09-01'
                    and creation_time < '2022-09-08'
                ) t
                left join products using(product_id)
            ) t2
            where user_id in (select user_id from users_camp_2)
            group by order_id, user_id
        ) t3
        group by user_id
    ) t4
)
select
    distinct ads_campaign,
    (select avg_check from avg_price_camp_1) as avg_check
from users_camp_1
union all
select
    distinct ads_campaign,
    (select avg_check from avg_price_camp_2) as avg_check
from users_camp_2
order by avg_check desc;


/* ============================================================
   4. Retention — day 1 and day 7
   ============================================================ */

with users_camp_1 as (
    select distinct user_id, 'Кампания № 1' as ads_campaign, time
    from user_actions
    where user_id in (
        8631, 8632, 8638, 8643, 8657, 8673, 8706, 8707, 8715, 8723, 8732,
        8739, 8741, 8750, 8751, 8752, 8770, 8774, 8788, 8791, 8804, 8810,
        8815, 8828, 8830, 8845, 8853, 8859, 8867, 8869, 8876, 8879, 8883,
        8896, 8909, 8911, 8933, 8940, 8972, 8976, 8988, 8990, 9002, 9004,
        9009, 9019, 9020, 9035, 9036, 9061, 9069, 9071, 9075, 9081, 9085,
        9089, 9108, 9113, 9144, 9145, 9146, 9162, 9165, 9167, 9175, 9180,
        9182, 9197, 9198, 9210, 9223, 9251, 9257, 9278, 9287, 9291, 9313,
        9317, 9321, 9334, 9351, 9391, 9398, 9414, 9420, 9422, 9431, 9450,
        9451, 9454, 9472, 9476, 9478, 9491, 9494, 9505, 9512, 9518, 9524,
        9526, 9528, 9531, 9535, 9550, 9559, 9561, 9562, 9599, 9603, 9605,
        9611, 9612, 9615, 9625, 9633, 9652, 9654, 9655, 9660, 9662, 9667,
        9677, 9679, 9689, 9695, 9720, 9726, 9739, 9740, 9762, 9778, 9786,
        9794, 9804, 9810, 9813, 9818, 9828, 9831, 9836, 9838, 9845, 9871,
        9887, 9891, 9896, 9897, 9916, 9945, 9960, 9963, 9965, 9968, 9971,
        9993, 9998, 9999, 10001, 10013, 10016, 10023, 10030, 10051, 10057,
        10064, 10082, 10103, 10105, 10122, 10134, 10135
    )
),
users_camp_2 as (
    select distinct user_id, 'Кампания № 2' as ads_campaign, time
    from user_actions
    where user_id in (
        8629, 8630, 8644, 8646, 8650, 8655, 8659, 8660, 8663, 8665, 8670,
        8675, 8680, 8681, 8682, 8683, 8694, 8697, 8700, 8704, 8712, 8713,
        8719, 8729, 8733, 8742, 8748, 8754, 8771, 8794, 8795, 8798, 8803,
        8805, 8806, 8812, 8814, 8825, 8827, 8838, 8849, 8851, 8854, 8855,
        8870, 8878, 8882, 8886, 8890, 8893, 8900, 8902, 8913, 8916, 8923,
        8929, 8935, 8942, 8943, 8949, 8953, 8955, 8966, 8968, 8971, 8973,
        8980, 8995, 8999, 9000, 9007, 9013, 9041, 9042, 9047, 9064, 9068,
        9077, 9082, 9083, 9095, 9103, 9109, 9117, 9123, 9127, 9131, 9137,
        9140, 9149, 9161, 9179, 9181, 9183, 9185, 9190, 9196, 9203, 9207,
        9226, 9227, 9229, 9230, 9231, 9250, 9255, 9259, 9267, 9273, 9281,
        9282, 9289, 9292, 9303, 9310, 9312, 9315, 9327, 9333, 9335, 9337,
        9343, 9356, 9368, 9370, 9383, 9392, 9404, 9410, 9421, 9428, 9432,
        9437, 9468, 9479, 9483, 9485, 9492, 9495, 9497, 9498, 9500, 9510,
        9527, 9529, 9530, 9538, 9539, 9545, 9557, 9558, 9560, 9564, 9567,
        9570, 9591, 9596, 9598, 9616, 9631, 9634, 9635, 9636, 9658, 9666,
        9672, 9684, 9692, 9700, 9704, 9706, 9711, 9719, 9727, 9735, 9741,
        9744, 9749, 9752, 9753, 9755, 9757, 9764, 9783, 9784, 9788, 9790,
        9808, 9820, 9839, 9841, 9843, 9853, 9855, 9859, 9863, 9877, 9879,
        9880, 9882, 9883, 9885, 9901, 9904, 9908, 9910, 9912, 9920, 9929,
        9930, 9935, 9939, 9958, 9959, 9961, 9983, 10027, 10033, 10038,
        10045, 10047, 10048, 10058, 10059, 10067, 10069, 10073, 10075,
        10078, 10079, 10081, 10092, 10106, 10110, 10113, 10131
    )
)
select
    ads_campaign,
    start_date,
    day_number,
    retention
from (
    select
        start_date,
        date - start_date as day_number,
        round(
            count(distinct user_id)::numeric /
            max(count(distinct user_id)) over (
                partition by ads_campaign, start_date
            ),
            2
        ) as retention,
        ads_campaign
    from (
        select
            user_id,
            '2022-09-01'::date as start_date,
            time::date as date,
            ads_campaign
        from (
            select user_id, ads_campaign, time from users_camp_1
            union all
            select user_id, ads_campaign, time from users_camp_2
        ) t1
    ) t2
    where date >= '2022-09-01'
    group by ads_campaign, start_date, date
) t3
where day_number in (0, 1, 7)
order by ads_campaign, day_number;


/* ============================================================
   5. Cumulative ARPPU vs CAC — Campaign 1 and Campaign 2
   ============================================================ */

with users_camp_1 as (
    select distinct user_id, 'Кампания № 1' as ads_campaign, time
    from user_actions
    where user_id in (
        8631, 8632, 8638, 8643, 8657, 8673, 8706, 8707, 8715, 8723, 8732,
        8739, 8741, 8750, 8751, 8752, 8770, 8774, 8788, 8791, 8804, 8810,
        8815, 8828, 8830, 8845, 8853, 8859, 8867, 8869, 8876, 8879, 8883,
        8896, 8909, 8911, 8933, 8940, 8972, 8976, 8988, 8990, 9002, 9004,
        9009, 9019, 9020, 9035, 9036, 9061, 9069, 9071, 9075, 9081, 9085,
        9089, 9108, 9113, 9144, 9145, 9146, 9162, 9165, 9167, 9175, 9180,
        9182, 9197, 9198, 9210, 9223, 9251, 9257, 9278, 9287, 9291, 9313,
        9317, 9321, 9334, 9351, 9391, 9398, 9414, 9420, 9422, 9431, 9450,
        9451, 9454, 9472, 9476, 9478, 9491, 9494, 9505, 9512, 9518, 9524,
        9526, 9528, 9531, 9535, 9550, 9559, 9561, 9562, 9599, 9603, 9605,
        9611, 9612, 9615, 9625, 9633, 9652, 9654, 9655, 9660, 9662, 9667,
        9677, 9679, 9689, 9695, 9720, 9726, 9739, 9740, 9762, 9778, 9786,
        9794, 9804, 9810, 9813, 9818, 9828, 9831, 9836, 9838, 9845, 9871,
        9887, 9891, 9896, 9897, 9916, 9945, 9960, 9963, 9965, 9968, 9971,
        9993, 9998, 9999, 10001, 10013, 10016, 10023, 10030, 10051, 10057,
        10064, 10082, 10103, 10105, 10122, 10134, 10135
    )
),
users_camp_2 as (
    select distinct user_id, 'Кампания № 2' as ads_campaign, time
    from user_actions
    where user_id in (
        8629, 8630, 8644, 8646, 8650, 8655, 8659, 8660, 8663, 8665, 8670,
        8675, 8680, 8681, 8682, 8683, 8694, 8697, 8700, 8704, 8712, 8713,
        8719, 8729, 8733, 8742, 8748, 8754, 8771, 8794, 8795, 8798, 8803,
        8805, 8806, 8812, 8814, 8825, 8827, 8838, 8849, 8851, 8854, 8855,
        8870, 8878, 8882, 8886, 8890, 8893, 8900, 8902, 8913, 8916, 8923,
        8929, 8935, 8942, 8943, 8949, 8953, 8955, 8966, 8968, 8971, 8973,
        8980, 8995, 8999, 9000, 9007, 9013, 9041, 9042, 9047, 9064, 9068,
        9077, 9082, 9083, 9095, 9103, 9109, 9117, 9123, 9127, 9131, 9137,
        9140, 9149, 9161, 9179, 9181, 9183, 9185, 9190, 9196, 9203, 9207,
        9226, 9227, 9229, 9230, 9231, 9250, 9255, 9259, 9267, 9273, 9281,
        9282, 9289, 9292, 9303, 9310, 9312, 9315, 9327, 9333, 9335, 9337,
        9343, 9356, 9368, 9370, 9383, 9392, 9404, 9410, 9421, 9428, 9432,
        9437, 9468, 9479, 9483, 9485, 9492, 9495, 9497, 9498, 9500, 9510,
        9527, 9529, 9530, 9538, 9539, 9545, 9557, 9558, 9560, 9564, 9567,
        9570, 9591, 9596, 9598, 9616, 9631, 9634, 9635, 9636, 9658, 9666,
        9672, 9684, 9692, 9700, 9704, 9706, 9711, 9719, 9727, 9735, 9741,
        9744, 9749, 9752, 9753, 9755, 9757, 9764, 9783, 9784, 9788, 9790,
        9808, 9820, 9839, 9841, 9843, 9853, 9855, 9859, 9863, 9877, 9879,
        9880, 9882, 9883, 9885, 9901, 9904, 9908, 9910, 9912, 9920, 9929,
        9930, 9935, 9939, 9958, 9959, 9961, 9983, 10027, 10033, 10038,
        10045, 10047, 10048, 10058, 10059, 10067, 10069, 10073, 10075,
        10078, 10079, 10081, 10092, 10106, 10110, 10113, 10131
    )
),
all_users as (
    select * from users_camp_1
    union all
    select * from users_camp_2
),
campaign_users as (
    select distinct user_id, ads_campaign
    from all_users
),
paying_users as (
    select count(distinct user_id) as paid_users, ads_campaign
    from (
        select
            user_actions.user_id,
            count(order_id) as user_orders,
            ads_campaign
        from user_actions
        left join all_users using(user_id)
        where order_id not in (
            select order_id
            from user_actions
            where action = 'cancel_order'
        )
        and user_id in (select user_id from all_users)
        group by user_id, ads_campaign
    ) t
    where user_orders >= 1
    group by ads_campaign
),
cac as (
    select
        ads_campaign,
        round(250000 / paid_users::numeric, 2) as cac
    from paying_users
),
revenue_camp_1 as (
    select
        date,
        sum(revenue) over (
            order by date
            rows between unbounded preceding and current row
        ) as running_revenue,
        ads_campaign
    from (
        select
            date,
            sum(price) as revenue,
            ads_campaign
        from (
            select
                order_id,
                creation_time::date as date,
                t.product_id,
                products.price,
                user_actions.user_id,
                ads_campaign
            from orders
            cross join unnest(orders.product_ids) as t(product_id)
            left join products using(product_id)
            left join user_actions using(order_id)
            left join campaign_users using(user_id)
            where order_id not in (
                select order_id
                from user_actions
                where action = 'cancel_order'
            )
            and user_id in (select user_id from all_users)
        ) t2
        where ads_campaign = 'Кампания № 1'
        group by date, ads_campaign
    ) t3
),
revenue_camp_2 as (
    select
        date,
        sum(revenue) over (
            order by date
            rows between unbounded preceding and current row
        ) as running_revenue,
        ads_campaign
    from (
        select
            date,
            sum(price) as revenue,
            ads_campaign
        from (
            select
                order_id,
                creation_time::date as date,
                t.product_id,
                products.price,
                user_actions.user_id,
                ads_campaign
            from orders
            cross join unnest(orders.product_ids) as t(product_id)
            left join products using(product_id)
            left join user_actions using(order_id)
            left join campaign_users using(user_id)
            where order_id not in (
                select order_id
                from user_actions
                where action = 'cancel_order'
            )
            and user_id in (select user_id from all_users)
        ) t2
        where ads_campaign = 'Кампания № 2'
        group by date, ads_campaign
    ) t3
)
select
    ads_campaign,
    'Day ' || (date - '2022-09-01'::date) as day,
    round(running_revenue / paid_users, 2) as cumulative_arppu,
    cac
from (
    select date, ads_campaign, running_revenue, cac, paid_users
    from revenue_camp_1
    left join cac using(ads_campaign)
    left join paying_users using(ads_campaign)

    union all

    select date, ads_campaign, running_revenue, cac, paid_users
    from revenue_camp_2
    left join cac using(ads_campaign)
    left join paying_users using(ads_campaign)
) t
order by ads_campaign, day;
