{% macro convert_to_base_uom(qty, uom) %}
/* 
    Map everything to a chosen base UOM per ingredient family.
*/
  case upper({{ uom }})
    when 'LB' then {{ qty }} * 0.453592     -- lb -> kg
    when 'CS' then {{ qty }} * 1            -- if each case is already base unit; replace with true factor
    when 'KG' then {{ qty }}
    else {{ qty }}                          -- fallback
  end
{% endmacro %}
