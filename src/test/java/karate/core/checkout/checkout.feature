Feature: Checkout

  Background:
    * url checkout_endpoint
    * def tenantId = account

    #* url cart_endpoint
    * def checkoutRequestBody = read('classpath:karate/core/checkout/checkout.json')
    * def checkoutForMultiLineItemBody = read('classpath:karate/core/checkout/checkoutMultiLineItem.json')
    * def orderTotal = __arg.shippingCost +  __arg.cartTotal
    * print "CART TOTAL: " + __arg.cartTotal

    * checkoutRequestBody.cartId = __arg.cartId
    * checkoutRequestBody.tax.shippingTaxes[0].shippingDetailsId = __arg.shipToId
    * checkoutRequestBody.payments[0].amount = orderTotal

    * checkoutForMultiLineItemBody.cartId = __arg.cartId
    * checkoutForMultiLineItemBody.tax.shippingTaxes[0].shippingDetailsId = __arg.shipToId
    * checkoutForMultiLineItemBody.payments[0].amount = orderTotal

@CheckoutSingleLineItem
  Scenario: Checkout the cart
    Given path 'checkout/sessions'
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request checkoutRequestBody
    When method post
    Then status 200
    And assert response.state == "COMPLETED"
    And assert response.orderId != null && response.orderId != ''

  @CheckoutMultipleLineItem
  Scenario: Checkout the cart
    Given path 'checkout/sessions'
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request checkoutForMultiLineItemBody
    When method post
    Then status 200
    And assert response.state == "COMPLETED"
    And assert response.orderId != null && response.orderId != ''

