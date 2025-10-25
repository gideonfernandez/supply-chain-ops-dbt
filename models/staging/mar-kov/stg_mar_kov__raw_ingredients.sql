-- stg_mar_kov__raw_ingredients.sql

with

source as (

    select * from {{ source('mar_kov', 'raw_mar_kov__raw_ingredients') }}

),

renamed as (

    select

        ----------  ids
        {{ dbt_utils.generate_surrogate_key(['ingredient_sku']) }} as raw_ingredient_uuid,
        ingredient_sku as raw_ingredient_id,
        lot_number,

        ---------- text
        ingredient_name,
        {{ normalize_uom('uom') }} as uom,
        location as warehouse,
        room,

        ---------- numerics
        {{ string_to_number('qty_on_hand') }} as onhand_qty,

        ---------- dates
        {{ flexible_timestamp('expiry_date') }} as expiry_date,
        {{ flexible_timestamp('last_updated') }} as updated_at

    from source

)

select * from renamed