-- macros/flexible_timestamp.sql
{% macro flexible_timestamp(field) %}
coalesce(
    -- ISO 8601 formats
    try_to_timestamp({{ field }}, 'YYYY-MM-DDTHH24:MI:SSZ'),
    try_to_timestamp({{ field }}, 'YYYY-MM-DD HH24:MI:SS'),
    try_to_timestamp({{ field }}, 'YYYY-MM-DD HH24:MI'),
    try_to_timestamp({{ field }}, 'YYYY-MM-DD'),
    
    -- US-style formats (more specific, should come before slash-separated)
    try_to_timestamp({{ field }}, 'MM/DD/YYYY HH24:MI'),
    try_to_timestamp({{ field }}, 'MM/DD/YY HH24:MI:SS'),
    try_to_timestamp({{ field }}, 'MM/DD/YY'),
    try_to_timestamp({{ field }}, 'MM/DD/YYYY'),
    
    -- Slash-separated formats
    try_to_timestamp({{ field }}, 'YYYY/MM/DD HH24:MI'),
    try_to_timestamp({{ field }}, 'YYYY/MM/DD')
)
{% endmacro %}
