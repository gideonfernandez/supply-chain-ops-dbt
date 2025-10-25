-- macros/normalize_sku.sql
{% macro normalize_sku(field) %}
nullif(regexp_replace(upper(trim({{ field }})), '[^0-9]', ''), '')
{% endmacro %}
