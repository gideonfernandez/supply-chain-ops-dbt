-- macros/normalize_uom.sql
{% macro normalize_uom(field) %}
case
  when {{ field }} is null then null
  else
    {# Normalize once: trim -> upper -> drop non-alphanumerics #}
    {% set norm = "regexp_replace(upper(trim(" ~ field ~ ")), '[^A-Z0-9]', '')" %}

    case
      when {{ norm }} in ('EA','EACH','UNIT','UNITS') then 'EA'
      when {{ norm }} in ('KG','KGS','KILOGRAM','KILOGRAMS') then 'KG'
      when {{ norm }} in ('LB','LBS','POUND','POUNDS')       then 'LB'
      when {{ norm }} in ('CS','CASE','CASES')               then 'CS'
      else {{ norm }}   -- fallback to the normalized token
    end
end
{% endmacro %}