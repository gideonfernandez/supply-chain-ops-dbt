-- macros/string_to_number.sql
{% macro string_to_number(field) %}
coalesce(
  try_cast(replace({{ field }}, ',', '') as number),
  0
)
{% endmacro %}