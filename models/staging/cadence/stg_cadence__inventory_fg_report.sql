-- stg_cadence__inventory_fg_report.sql

with

source as (

    select * from {{ source('cadence', 'raw_cadence__inventory_fg_report') }}

),

renamed as (

    select

        ----------  ids
        {{ dbt_utils.generate_surrogate_key(['sku']) }} as inventory_fg_report_uuid,
        {{ normalize_sku('sku') }} as product_id,
        

        ---------- text
        name as product_description,
        warehouse,
        {{ normalize_uom('unit') }} as uom,
        location,
        room,

        ---------- numerics
        coalesce(available_qty, 0) as onhand_qty,

        ---------- dates
        updated_at

    from source

)

select * from renamed
