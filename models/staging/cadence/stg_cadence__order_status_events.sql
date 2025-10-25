-- stg_cadence__order_status_events.sql

with

source as (

    select * from {{ source('cadence', 'raw_cadence__order_status_events') }}

),

renamed as (

    select

        ----------  ids
        {{ dbt_utils.generate_surrogate_key(['order_id', 'event_type']) }} as order_status_event_uuid,
        order_id,

        ---------- text
        event_type,
        details,

        ---------- datetimes
        {{ flexible_timestamp('event_ts') }} as event_at

    from source

)

select * from renamed
