with operational as (select * from {{ref('int_orders_margin')}}
),

ship as (select * from {{ref('stg_raw__ship')}}
)

select operational.orders_id,
    operational.date_date,
    operational.margin + ship.shipping_fee - ship.logcost - ship.ship_cost as operational_margin
 from operational
left join ship 
ON operational.orders_id = ship.orders_id 