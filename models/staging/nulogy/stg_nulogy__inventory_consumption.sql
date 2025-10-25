-- stg_nulogy__inventory_consumption.sql

with

source as (

    select * from {{ source('nulogy', 'raw_nulogy__inventory_consumption') }}

),

renamed as (

    select

        ----------  ids
        {{ dbt_utils.generate_surrogate_key(['work_order_id', 'product_code', 'ingredient_sku']) }} as inventory_consumption_uuid,
        work_order_id,
        {{ normalize_sku('product_code') }} as product_id,
        ingredient_sku as raw_ingredient_id,
        
        ---------- numerics
        coalesce(qty_consumed, 0) as qty_consumed,

        ---------- text
        {{ normalize_uom('uom') }} as uom,
        site as warehouse,

        ---------- dates
        {{ flexible_timestamp('timestamp') }} as updated_at

    from source

)

select * from renamed