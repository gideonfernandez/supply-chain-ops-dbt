-- int_warehouse_inventory.sql

with 

stg_nulogy__finished_goods_inventory as (

  select * from {{ ref('stg_nulogy__finished_goods_inventory') }}

),

stg_cadence__inventory_fg_report as (

  select * from {{ ref('stg_cadence__inventory_fg_report') }}

),

warehouse_inventory as (
  -- from innova (manufacturing)
  select 
    product_id, 
    onhand_qty,
    'innova' as warehouse
  from stg_nulogy__finished_goods_inventory
  where onhand_qty > 0
  qualify row_number() over (partition by product_id order by updated_at desc) = 1

  union all

  -- from cadence (distribution)
  select 
    product_id, 
    onhand_qty,
    'cadence' as warehouse
  from stg_cadence__inventory_fg_report
  where onhand_qty > 0
  qualify row_number() over (partition by product_id order by updated_at desc) = 1

),

int_warehouse_inventory as (

  -- get current finished goods across all warehouses
  select

    product_id,
    sum(onhand_qty) as current_fg_onhand,
    count(distinct warehouse) as warehouse_count

  from warehouse_inventory
  group by product_id

)

select * from int_warehouse_inventory
