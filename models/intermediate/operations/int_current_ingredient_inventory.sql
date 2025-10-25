-- int_current_ingredient_inventory.sql

with

stg_mar_kov__raw_ingredients as (

  select * from {{ ref('stg_mar_kov__raw_ingredients') }}

),

int_current_ingredient_inventory as (

  -- get latest inventory per ingredient (one row per ingredient)
  select

    raw_ingredient_id,
    ingredient_name,
    uom,
    onhand_qty,
    expiry_date,
    updated_at

  from stg_mar_kov__raw_ingredients
  qualify row_number() over (partition by raw_ingredient_id order by updated_at desc) = 1

)

select * from int_current_ingredient_inventory
