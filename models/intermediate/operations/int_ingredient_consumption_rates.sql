-- int_ingredient_consumption_rates.sql

with

stg_nulogy__inventory_consumption as (

  select * from {{ ref('stg_nulogy__inventory_consumption') }}

),

stg_nulogy__work_orders as (

  select * from {{ ref('stg_nulogy__work_orders') }}

),

stg_mar_kov__raw_ingredients as (

  select * from {{ ref('stg_mar_kov__raw_ingredients') }}

),

int_ingredient_consumption_rates as (

  -- calculate average consumption rate per unit produced
  select

    ic.raw_ingredient_id,
    ic.product_id,
    ri.ingredient_name,
    ri.uom as ingredient_uom,
    wo.uom as product_uom,
    -- calculate consumption per unit (handling zero qty_planned)
    sum(ic.qty_consumed) / nullif(sum(wo.qty_planned), 0) as consumption_per_unit

  from stg_nulogy__inventory_consumption ic
  join stg_nulogy__work_orders wo
    on ic.work_order_id = wo.work_order_id
  join stg_mar_kov__raw_ingredients ri
    on ic.raw_ingredient_id = ri.raw_ingredient_id
  where ic.qty_consumed > 0  -- only include actual consumption
  group by 1, 2, 3, 4, 5

)

select * from int_ingredient_consumption_rates
