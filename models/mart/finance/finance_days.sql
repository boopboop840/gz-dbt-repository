
with orders_margin as (
    select *
    from {{ ref('int_orders_margin') }}
),

orders_operational as (
    select *
    from {{ ref('int_orders_operational') }}
),

ship as (
    select *
    from {{ ref('stg_raw__ship') }}
),

joined as (
    select
        orders_margin.orders_id,
        orders_margin.date_date,
        orders_margin.revenue,
        orders_margin.quantity,
        orders_margin.purchase_cost,
        orders_operational.operational_margin,
        ship.shipping_fee,
        ship.logcost
    from orders_margin
    left join orders_operational
        on orders_margin.orders_id = orders_operational.orders_id
    left join ship
        on orders_margin.orders_id = ship.orders_id
)

select
    date_date,
    count(distinct orders_id) as nb_transactions,
    sum(revenue) as revenue,
    sum(revenue) / count(distinct orders_id) as average_basket,
    sum(operational_margin) as operational_margin,
    sum(purchase_cost) as purchase_cost,
    sum(shipping_fee) as shipping_fee,
    sum(logcost) as logcost,
    sum(quantity) as quantity
from joined
group by date_date