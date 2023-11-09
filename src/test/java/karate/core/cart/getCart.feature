Feature: Get Cart By Cart ID

  Background:

    * url cart_endpoint
    * def cartId = __arg.cartID
    * print cartId
    * def tenantId = account

  @GetPromotionalShippingCart
  Scenario: Get Cart By Cart ID
    Given path cartId
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    And print response
    And assert response.id != null && response.id != ''
    And assert response.status == 'PENDING'
    And assert response.appliedPromotions.length > 0
    And assert response.subTotal == response.totalAmount + response.totalDiscount
    And assert response.lineItems[0].price.base == response.lineItems[0].price.sale
    And assert response.lineItems[0].discounts.length > 0
    And assert response.totalAmount == response.subTotal - response.lineItems[0].discounts[0].amount
    And assert response.lineItems[0].discounts[0].promotion.value ==  response.subTotal - response.totalAmount


  @GetCartWithSingleItemAndFreeShipping
  Scenario: Get Cart By Cart ID
    Given path cartId
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    And print response
    And assert response.id != null && response.id != ''
    And assert response.status == 'PENDING'
    And assert response.subTotal == response.totalAmount + response.totalDiscount
    And assert response.lineItems[0].price.base == response.lineItems[0].price.sale


  @GetCartWithMultiLineItem
  Scenario: Get Cart By Cart ID
    Given path cartId
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    And print response
    And assert response.id != null && response.id != ''
    And assert response.status == 'PENDING'
    And assert response.lineItems[0].sku != null && response.lineItems[0].sku != ''
    And assert response.lineItems[0].itemId != null && response.lineItems[0].itemId != ''
    And assert response.lineItems[0].title != null && response.lineItems[0].title != ''
    And assert response.lineItems[0].price != null && response.lineItems[0].price != ''
    And assert response.lineItems[1].sku != null && response.lineItems[1].sku != ''
    And assert response.lineItems[1].itemId != null && response.lineItems[1].itemId != ''
    And assert response.lineItems[1].title != null && response.lineItems[1].title != ''
    And assert response.lineItems[1].price != null && response.lineItems[1].price != ''
    And assert response.totalAmount != null && response.totalAmount != ''