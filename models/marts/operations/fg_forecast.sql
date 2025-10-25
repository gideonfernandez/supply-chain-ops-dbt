-- fg_forecast.sql

with 

int_ingredient_consumption_rates as (

  select * from {{ ref('int_ingredient_consumption_rates') }}

),

int_current_ingredient_inventory as (
  
  select * from {{ ref('int_current_ingredient_inventory') }} 

),

stg_nulogy__finished_goods_inventory as (

  select * from {{ ref('stg_nulogy__finished_goods_inventory') }}

),

int_warehouse_inventory as (

  select * from {{ ref('int_warehouse_inventory') }}

),

potential_production as (

  -- calculate how many units can be produced with each ingredient
  select

    icr.product_id,
    icr.raw_ingredient_id,
    cii.ingredient_name,
    cii.onhand_qty as ingredient_onhand,
    icr.consumption_per_unit,
    -- units that can be produced = available inventory / consumption rate
    floor(cii.onhand_qty / nullif(icr.consumption_per_unit, 0)) as potential_units,
    cii.expiry_date,
    cii.uom as ingredient_uom

  from int_ingredient_consumption_rates icr
  join int_current_ingredient_inventory cii
    on icr.raw_ingredient_id = cii.raw_ingredient_id

),

product_descriptions as (

  -- get product descriptions from nulogy finished goods inventory
  select 

    product_id, 
    max(product_description) as product_description

  from stg_nulogy__finished_goods_inventory
  group by product_id

)

-- final forecast: bottleneck ingredient determines max production
select

  pp.product_id,
  pd.product_description,
  wi.current_fg_onhand,
  pp.raw_ingredient_id,
  pp.ingredient_name,
  pp.ingredient_onhand,
  pp.ingredient_uom,
  pp.consumption_per_unit,
  pp.potential_units,
  pp.expiry_date,

  -- maximum potential including current inventory
  wi.current_fg_onhand + pp.potential_units as total_potential_fg,

  -- flag if this is the limiting ingredient
  case
    when pp.potential_units = min(pp.potential_units) over (partition by pp.product_id)
    then 'bottleneck'
    else 'sufficient'
  end as constraint_status

from potential_production pp
left join product_descriptions pd 
  on pp.product_id = pd.product_id
left join int_warehouse_inventory wi 
  on pp.product_id = wi.product_id
order by pp.product_id, pp.potential_units asc