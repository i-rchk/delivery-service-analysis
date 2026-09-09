-- Sales & Profitability Dashboard | SQL queries
-- PostgreSQL / Redash

-- 1. Revenue and costs

with canceled as (
   select order_id
   from user_actions
   where action = 'cancel_order'
),

couriers_cost as (
   select date, sum(couriers_cost) as couriers_cost
   from (
      select date, courier_id,
      case
      when orders_count >= 5 and date < '2022-09-01'
      then orders_count * 150 + 400
      when orders_count >= 5 and date >= '2022-09-01'
      then orders_count * 150 + 500
      when orders_count < 5 and date < '2022-09-01'
      then orders_count * 150
      when orders_count < 5 and date >= '2022-09-01'
      then orders_count * 150
      end as couriers_cost
      from (
         select date, courier_id, count(order_id) as orders_count
         from (
            select order_id, time::date as date, courier_id
            from courier_actions
            where action = 'deliver_order'
         )t
         group by date, courier_id
         order by date, courier_id
      )t1
   )t2
   group by date
),

orders_cost as (
  select date,
  case
  when date < '2022-09-01'
  then orders_count * 140
  when date >= '2022-09-01'
  then orders_count * 115
  end as order_cost
  from(
     select count(order_id) as orders_count, creation_time::date as date
     from orders
     where order_id not in (
       select order_id from user_actions where action = 'cancel_order')
     group by date
  )t3
  order by date
),
costs as (
   select date,
   case
   when date < '2022-09-01'
   then couriers_cost.couriers_cost + orders_cost.order_cost + 120000
   else couriers_cost.couriers_cost + orders_cost.order_cost + 150000
   end as costs
   from orders_cost
   join couriers_cost using(date)
),
total_costs as (
select date, sum(costs) over(order by date rows between unbounded preceding and current row) as total_costs
from costs
)

select date, revenue, total_revenue, round((revenue - total_before)/ total_before * 100, 2) as revenue_change, total_costs
from (
select date, revenue, total_revenue, lag(revenue) over(order by date ) as total_before
from(
select revenue, date, sum(revenue) over(order by date rows between unbounded preceding and current row) as total_revenue
from(
select sum(price) as revenue, date
from (
select orders.order_id, t.product_id, products.price, orders.creation_time::date as date
from orders
cross join unnest(orders.product_ids) as t(product_id)
left join products using(product_id)
where order_id not in (select order_id from user_actions where action = 'cancel_order')
) t1
group by date
) t2
)t3
order by date
)t4
left join total_costs using(date);

-- 2. Revenue, costs and gross profit

with all_products as (
select orders.creation_time::date as date, orders.order_id, t.product_id, products.price
from orders
cross join unnest(orders.product_ids) t(product_id)
left join products using(product_id)
where order_id not in (select order_id from user_actions where action = 'cancel_order')
),
revenue as (
select date, sum(price) as revenue
from all_products
group by date
),
couriers_cost as (
select date, sum(couriers_cost) as couriers_cost
from (
select date, courier_id,
case
when orders_count >= 5 and date < '2022-09-01' then orders_count * 150 + 400
when orders_count >= 5 and date >= '2022-09-01' then orders_count * 150 + 500
when orders_count < 5 and date < '2022-09-01' then orders_count * 150
when orders_count < 5 and date >= '2022-09-01' then orders_count * 150
end as couriers_cost
from (
select date, courier_id, count(order_id) as orders_count
from (
select order_id, time::date as date, courier_id
from courier_actions
where action = 'deliver_order'
)t
group by date, courier_id
order by date, courier_id
)t1
)t2
group by date
),
orders_cost as (
select date,
case
when date < '2022-09-01' then orders_count * 140
when date >= '2022-09-01' then orders_count * 115
end as order_cost
from(
select count(order_id) as orders_count, creation_time::date as date
from orders
where order_id not in (select order_id from user_actions where action = 'cancel_order')
group by date
)t3
order by date
),
costs as (
select date,
case
when date < '2022-09-01' then couriers_cost.couriers_cost + orders_cost.order_cost + 120000
else couriers_cost.couriers_cost + orders_cost.order_cost + 150000
end as costs
from orders_cost
join couriers_cost using(date)
),
tax as (
select date, sum(product_tax) as tax
from(
select date,
case when name in (
'сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 'масло оливковое',
'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины',
'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина', 'рис',
'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки',
'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины'
)
then round((price * 10)/110, 2)
else round((price * 20)/120, 2)
end as product_tax
from(
select creation_time::date as date, order_id, t.product_id, products.name, products.price
from orders
cross join unnest(orders.product_ids) t(product_id)
left join products using(product_id)
where order_id not in (select order_id from user_actions where action = 'cancel_order')
)t4
)t5
group by date
),
profit as (
select revenue.date, revenue.revenue - costs.costs - tax.tax as gross_profit
from revenue
left join costs using (date)
left join tax using (date)
)
select date, revenue, costs, tax, gross_profit, total_revenue, total_costs, total_tax,
total_gross_profit, gross_profit_ratio,
round((total_gross_profit/total_revenue)*100, 2) as total_gross_profit_ratio
from
(select date, revenue, costs, tax, gross_profit,
sum(revenue) over(order by date rows between unbounded preceding and current row) as total_revenue,
sum(costs) over(order by date rows between unbounded preceding and current row) as total_costs,
sum(tax) over(order by date rows between unbounded preceding and current row) as total_tax,
sum(gross_profit) over(order by date rows between unbounded preceding and current row) as total_gross_profit,
round((gross_profit/revenue)*100 , 2) as gross_profit_ratio
from(
select revenue.date, revenue.revenue, costs.costs, tax.tax, profit.gross_profit
from revenue
left join costs using (date)
left join tax using (date)
left join profit using(date)
)t6
)t7;

-- 3. ARPU, ARPPU and AOV by Day

with users_a_day as (
select time::date date, count(distinct user_id) as total_users
from user_actions
group by date
),
daily_revenue as (
select date, sum(price) as revenue
from (
select order_id, creation_time::date as date, t.product_id, products.price
from orders
cross join unnest(orders.product_ids) as t(product_id)
left join products using(product_id)
where order_id not in (select order_id from user_actions where action = 'cancel_order')
) t2
group by date
),
pay as (
select count(distinct user_id) paying_users, time::date as date
from user_actions
where order_id not in (select order_id from user_actions where action = 'cancel_order')
group by date
),
daily_orders as (
select creation_time::date as date, count(order_id) as order_a_day
from orders
where order_id not in (select order_id from user_actions where action = 'cancel_order')
group by date
)
select date, round(revenue/total_users,2) as arpu, round(revenue/paying_users, 2) as arppu,
round(revenue/order_a_day,2) as aov
from (
select date, total_users, paying_users, revenue, order_a_day
from users_a_day
join daily_revenue using(date)
join pay using (date)
join daily_orders using(date)
order by date
)t4;

-- 4. ARPU, ARPPU and AOV by Weekday

with users_a_weekday as (
select to_char(time, 'Day') as weekday, date_part('isodow', time) as weekday_number,
count(distinct user_id) as total_users
from user_actions
where time between '2022-08-26' and '2022-09-09'
group by 1,2
),
daily_revenue as (
select weekday, weekday_number, sum(price) as revenue
from (
select order_id, to_char(creation_time, 'Day') as weekday, date_part('isodow', creation_time) as weekday_number,
t.product_id, products.price
from orders
cross join unnest(orders.product_ids) as t(product_id)
left join products using(product_id)
where order_id not in (select order_id from user_actions where action = 'cancel_order')
and creation_time between '2022-08-26' and '2022-09-09'
) t2
group by 1, 2
),
pay as (
select count(distinct user_id) paying_users, to_char(time, 'Day') as weekday,
date_part('isodow', time) as weekday_number
from user_actions
where order_id not in (select order_id from user_actions where action = 'cancel_order')
and time between '2022-08-26' and '2022-09-09'
group by weekday, weekday_number
),
daily_orders as (
select to_char(creation_time, 'Day') as weekday, date_part('isodow', creation_time) as weekday_number,
count(order_id) as order_a_day
from orders
where order_id not in (select order_id from user_actions where action = 'cancel_order')
and creation_time between '2022-08-26' and '2022-09-09'
group by weekday, weekday_number
)
select weekday, weekday_number, round(revenue/total_users,2) as arpu,
round(revenue/paying_users, 2) as arppu, round(revenue/order_a_day,2) as aov
from (
select weekday, users_a_weekday.weekday_number, total_users, paying_users, revenue, order_a_day
from users_a_weekday
join daily_revenue using(weekday)
join pay using (weekday)
join daily_orders using(weekday)
order by weekday_number
)t4;

-- 5. Running ARPU, ARPPU and AOV

with users_a_day as (
select date, sum(new_users) over(order by date rows between unbounded preceding and current row) as total_users
from(
select date, count(user_id) as new_users
from (
select min(time)::date as date, user_id
from user_actions
group by user_id) t7
group by date
)t1
),
daily_revenue as (
select date, sum(revenue) over (order by date rows between unbounded preceding and current row) revenue
from(
select date, sum(price) as revenue
from (
select order_id, creation_time::date as date, t.product_id, products.price
from orders
cross join unnest(orders.product_ids) as t(product_id)
left join products using(product_id)
where order_id not in (select order_id from user_actions where action = 'cancel_order')
) t2
group by date
)t3
),
pay as (
select date, sum(paying_users) over (order by date rows between unbounded preceding and current row) paying_users
from(
select count(paying_users) paying_users, date
from (
select user_id paying_users, min(time)::date as date
from user_actions
where order_id not in (select order_id from user_actions where action = 'cancel_order')
group by user_id
)t4
group by date
)t8
),
daily_orders as (
select date, sum(order_a_day) over (order by date rows between unbounded preceding and current row) order_a_day
from (
select creation_time::date as date, count(order_id) as order_a_day
from orders
where order_id not in (select order_id from user_actions where action = 'cancel_order')
group by date
) t5
)
select date, round(revenue/total_users,2) as running_arpu, round(revenue/paying_users, 2) as running_arppu, round(revenue/order_a_day,2) as running_aov
from (
select date, total_users, paying_users, revenue, order_a_day
from users_a_day
join daily_revenue using(date)
join pay using(date)
join daily_orders using(date)
order by date
)t6;

-- 6. New users

with new_users as (
select user_id, min(time)::date as first_action
from user_actions
group by user_id
),
user_orders as (
select distinct user_id, order_id
from user_actions
),
new_users_revenue as (
select orders.creation_time::date as date, sum(products.price) as new_users_revenue
from new_users
join user_orders on new_users.user_id = user_orders.user_id
join orders using(order_id)
cross join unnest(orders.product_ids) as t(product_id)
left join products using(product_id)
where new_users.first_action = orders.creation_time::date
and orders.order_id not in (select order_id from user_actions where action = 'cancel_order')
group by date
),
total_revenue as (
select date, sum(price) as revenue
from (
select orders.order_id, t.product_id, products.price, orders.creation_time::date as date
from orders
cross join unnest(orders.product_ids) as t(product_id)
left join products using(product_id)
where order_id not in (select order_id from user_actions where action = 'cancel_order')
) t1
group by date
)
select date, revenue, new_users_revenue,
round((new_users_revenue/revenue)*100, 2) as new_users_revenue_share,
round(((revenue - new_users_revenue)/revenue)*100, 2) as old_users_revenue_share
from new_users_revenue
join total_revenue using(date);

-- 7. Revenue, costs and gross profit (final version)

with all_products as (
select orders.creation_time::date as date, orders.order_id, t.product_id, products.price
from orders
cross join unnest(orders.product_ids) t(product_id)
left join products using(product_id)
where order_id not in (select order_id from user_actions where action = 'cancel_order')
),
revenue as (
select date, sum(price) as revenue
from all_products
group by date
),
couriers_cost as (
select date, sum(couriers_cost) as couriers_cost
from (
select date, courier_id,
case
when orders_count >= 5 and date < '2022-09-01' then orders_count * 150 + 400
when orders_count >= 5 and date >= '2022-09-01' then orders_count * 150 + 500
when orders_count < 5 and date < '2022-09-01' then orders_count * 150
when orders_count < 5 and date >= '2022-09-01' then orders_count * 150
end as couriers_cost
from (
select date, courier_id, count(order_id) as orders_count
from (
select order_id, time::date as date, courier_id
from courier_actions
where action = 'deliver_order'
)t
group by date, courier_id
order by date, courier_id
)t1
)t2
group by date
),
orders_cost as (
select date,
case
when date < '2022-09-01' then orders_count * 140
when date >= '2022-09-01' then orders_count * 115
end as order_cost
from(
select count(order_id) as orders_count, creation_time::date as date
from orders
where order_id not in (select order_id from user_actions where action = 'cancel_order')
group by date
)t3
order by date
),
costs as (
select date,
case
when date < '2022-09-01' then couriers_cost.couriers_cost + orders_cost.order_cost + 120000
else couriers_cost.couriers_cost + orders_cost.order_cost + 150000
end as costs
from orders_cost
join couriers_cost using(date)
),
tax as (
select date, sum(product_tax) as tax
from(
select date,
case when name in (
'сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 'масло оливковое',
'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины',
'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина', 'рис',
'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки',
'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины'
)
then round((price * 10)/110, 2)
else round((price * 20)/120, 2)
end as product_tax
from(
select creation_time::date as date, order_id, t.product_id, products.name, products.price
from orders
cross join unnest(orders.product_ids) t(product_id)
left join products using(product_id)
where order_id not in (select order_id from user_actions where action = 'cancel_order')
)t4
)t5
group by date
),
profit as (
select revenue.date, revenue.revenue - costs.costs - tax.tax as gross_profit
from revenue
left join costs using (date)
left join tax using (date)
)
select date, revenue, costs, tax, gross_profit, total_revenue, total_costs, total_tax,
total_gross_profit, gross_profit_ratio,
round((total_gross_profit/total_revenue)*100, 2) as total_gross_profit_ratio
from
(select date, revenue, costs, tax, gross_profit,
sum(revenue) over(order by date rows between unbounded preceding and current row) as total_revenue,
sum(costs) over(order by date rows between unbounded preceding and current row) as total_costs,
sum(tax) over(order by date rows between unbounded preceding and current row) as total_tax,
sum(gross_profit) over(order by date rows between unbounded preceding and current row) as total_gross_profit,
round((gross_profit/revenue)*100 , 2) as gross_profit_ratio
from(
select revenue.date, revenue.revenue, costs.costs, tax.tax, profit.gross_profit
from revenue
left join costs using (date)
left join tax using (date)
left join profit using(date)
)t6
)t7;