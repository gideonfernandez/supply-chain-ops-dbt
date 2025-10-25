-- stg_nulogy__work_orders.sql

with

source as (

    select * from {{ source('nulogy', 'raw_nulogy__work_orders') }}

),

renamed as (

    select

        ----------  ids
        {{ dbt_utils.generate_surrogate_key(['wo_id']) }} as work_order_uuid,
        wo_id as work_order_id,
        {{ normalize_sku('product_code') }} as product_id,
        
        ---------- numerics
        coalesce(qty_planned, 0) as qty_planned,

        ---------- text
        {{ normalize_uom('uom') }} as uom,
        site as warehouse,
        status,

        ---------- dates
        {{ flexible_timestamp('start_date') }}::date as start_date,
        {{ flexible_timestamp('end_date') }}::date as end_date

    from source

)

select * from renamed
