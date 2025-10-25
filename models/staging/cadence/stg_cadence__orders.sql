-- stg_cadence__orders.sql

with

source as (

    select * from {{ source('cadence', 'raw_cadence__orders') }}

),

renamed as (

    select

        ----------  ids
        {{ dbt_utils.generate_surrogate_key(['order_id']) }} as order_uuid,
        order_id,

        ---------- text
        customer,
        warehouse,
        status,
        ship_method,

        ---------- dates
        {{ flexible_timestamp('order_date') }} as order_date

    from source

)

select * from renamed