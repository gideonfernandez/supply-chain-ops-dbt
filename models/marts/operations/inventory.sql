-- marts/inventory.sql

with

nulogy as (

    select * from {{ ref('stg_nulogy__finished_goods_inventory') }}

),


cadence as (

    select * from {{ ref('stg_cadence__inventory_fg_report') }}

),

markov as (

    select * from {{ ref('stg_mar_kov__raw_ingredients') }}

),

inventory_nulogy as (

    select distinct

        warehouse,
        product_id as sku,
        product_description as description,
        'finished_good' as type,
        onhand_qty

    from nulogy

),

inventory_cadence as (

    select

        warehouse,
        product_id as sku,
        product_description as description,
        'finished_good' as type,
        onhand_qty

    from cadence

),

inventory_markov as (

    select

        warehouse,
        raw_ingredient_id as sku,
        ingredient_name as description,
        'ingredient' as type,
        onhand_qty

    from markov

)

select * from inventory_nulogy

union all

select * from inventory_cadence

union all

select * from inventory_markov