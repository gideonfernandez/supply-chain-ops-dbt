-- nulogy/base/base_nulogy__finished_goods_inventory.sql

with

source as (

    select * from {{ source('nulogy', 'raw_nulogy__finished_goods_inventory') }}

),

renamed as (

    select
        ---------- ids
        {{ dbt_utils.generate_surrogate_key(['product_code']) }} as finished_goods_inventory_uuid,
        {{ normalize_sku('product_code') }} as product_id,

        ---------- text
        description as product_description,
        {{ normalize_uom('uom') }} as uom,
        site as warehouse,

        ---------- json (parsed)
        try_parse_json(room_quantities) as room_quantities_v,

        ---------- numerics
        {{ string_to_number('onhand_qty') }} as onhand_qty,

        ---------- dates
        {{ flexible_timestamp('updated_at') }} as updated_at

    from source

)

select * from renamed
