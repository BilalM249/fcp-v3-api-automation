Feature: Add Ship To Cart

  Background:
    * url cart_endpoint
    * def tenantId = account

  @SingleLineItem
  Scenario: Add shipTo for a cart
    Given path  __arg.cartId + '/line-items/' + __arg.ItemId + '/shipping-details'
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request { "id": '#(__arg.shipToId)', "method": { "taxCode": "FR1000", "type": "SHIP_TO_ADDRESS" } }
    When method put
    Then status 200
    And print response
    And assert response.id != null || response.id != ''
