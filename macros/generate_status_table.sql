{% macro generate_status_table() %}
select 
    status,
    status_desc
from (
    values 
        ('pending', 'The order is awaiting processing.'),
        ('completed', 'The order has been successfully processed.'),
        ('canceled', 'The order has been canceled by the user or system.'),
        ('failed', 'The order failed during processing.'),
        ('refunded', 'The order has been refunded.')
) as status_table(status, status_desc)
{% endmacro %}