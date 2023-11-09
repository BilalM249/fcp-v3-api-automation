Feature: Cart Ship To

  Background:

    * def shipToRequestBody =  read('classpath:karate/core/cart/createShipTo.json')
    * shipToRequestBody.cartId = __arg.cartId
    * shipToRequestBody.shippingCost = __arg.shippingCost
    * shipToRequestBody.shippingMethodId = __arg.shippingMethodId
    * shipToRequestBody.shippingMethodName = "FedEx Testing"
    * url cart_endpoint
    * def tenantId = account


  Scenario: Create shipTo for a cart
    Then print __arg
    Given path __arg.cartId + '/shipping-details'
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request shipToRequestBody
    When method post
    Then status 201
    And print response
    And assert response.id != null && response.id != ''
    And assert response.shippingCost == __arg.shippingCost