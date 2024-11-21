{% docs event_type %}

Operation carried out by the user: 

| type            | definition                                 |
|-----------------|--------------------------------------------|
| add_to_cart     | A customer added a product to his/her cart |
| checkout        | A customer checked out his/her order       |
| package_shipped | The order was sent to the customer         |
| page_view       | A customer viewed a product                |

{% enddocs %}

{% docs order_status %}
Order status related to the order: 

| status    | definition                                           |
|-----------|------------------------------------------------------|
| delivered | The order has been received by customer              |
| preparing | The order has been checked out, not yet been shipped |
| shipped   | The order has been shipped, not yet been delivered   |

{% enddocs %}

{% docs promo_status %}
Promotion status. Whether the promotion can be applied or not: 

| status   | definition                    |
|----------|-------------------------------|
| active   | The promotion is ready to use |
| inactive | The promotion has expired     |

{% enddocs %}