-- stg_nulogy__finished_goods_inventory.sql

with

base as (

    select * from {{ ref('base_nulogy__finished_goods_inventory') }}

),

-- Explode the array of {room, qty} objects to rows
rooms as (
    select
        {{ dbt_utils.generate_surrogate_key(['product_id', 'index']) }} as finished_goods_inventory_uuid,
        r.product_id,
        r.product_description,
        r.uom,
        r.warehouse,

        -- from the array
        f.index as room_index,
        f.value:"room"::string                                  as room,
        coalesce(try_to_number(f.value:"qty"::string), 0)       as room_qty,

        r.onhand_qty,
        r.updated_at

    from base r,
         lateral flatten(input => r.room_quantities_v, outer => true) f

)

select * from rooms