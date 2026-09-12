# Delivery Service Analysis

SQL-анализ финансовых, продуктовых и маркетинговых показателей сервиса доставки товаров.

## О проекте

Проект выполнен в рамках блока **Product Metrics** курса Karpov.Courses.

Цель проекта — провести комплексный анализ сервиса доставки с точки зрения экономики продукта и эффективности маркетинговых кампаний.

## Product Metrics

### 1. Product Economics

В первой части проекта проанализирована экономика продукта и рассчитаны ключевые финансовые и продуктовые метрики:

- Revenue и Revenue Change
- Costs
- Gross Profit и Gross Profit Ratio
- Total Revenue и Total Costs
- ARPU, ARPPU и AOV
- Running ARPU, ARPPU и AOV
- Revenue from New Users
- Revenue by Products

### 2. Marketing Metrics

Во второй части проведено сравнение двух рекламных кампаний:

- CAC — Customer Acquisition Cost
- ROI — Return on Investment
- Average Check за первую неделю
- Retention 1-го и 7-го дня
- Cumulative ARPPU vs CAC

Анализ позволяет сравнить стоимость привлечения пользователей, их поведение и удержание, а также определить окупаемость рекламных расходов.

## Dashboards

### Sales & Profitability Dashboard

![Sales & Profitability Dashboard — part 1](./screenshots/Dashboard-1.jpg)

![Sales & Profitability Dashboard — part 2](./screenshots/Dashboard-2.jpg)

### Marketing Campaigns — Comparative Analysis Dashboard

Сводный дашборд сравнивает две рекламные кампании по ключевым маркетинговым метрикам и динамике окупаемости.

> Dashboard screenshot can be added to `screenshots/` when the final Redash export is uploaded to the repository.

## SQL Analysis

SQL-запросы находятся в папке [`sql`](./sql).

### Techniques used

- CTE
- JOINs
- Aggregate functions
- Window functions
- `CASE WHEN`
- `LAG`
- `EXTRACT`
- `UNNEST`
- Conditional aggregation

## Tools

- **PostgreSQL**
- **SQL**
- **Redash**

## Project Outcome

В результате собран единый набор продуктовых метрик и два Redash-дашборда, которые позволяют оценивать экономику сервиса доставки и сравнивать эффективность рекламных кампаний.
