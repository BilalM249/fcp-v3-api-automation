Feature: Cart

  Background:

    * url cart_endpoint
    * def quantity = __arg.quantity
    * print quantity
    * def tenantId = account



  @AddingSingleItemToCart
  Scenario: Add to Cart
    Given path ''
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request { "cartId": null, "networkCode": "ShipToHome", "lineItems": [{"itemId": "#(__arg.ItemId)","quantity": "1", "priceListId":"#(PRICE_LIST_ID)"}]}
    When method post
    Then status 201
    And print response
    And assert response.id != null && response.id != ''
    And print response.lineItems[0].productAttributes.length
    And print __arg.ItemAttributes
    And assert response.lineItems[0].productAttributes.length == __arg.ItemAttributes.length

  @AddingMultipleItemToCart
  Scenario: Add to Cart
    Given path ''
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request { "cartId": null, "networkCode": "ShipToHome", "lineItems": [{"itemId": "#(__arg.ItemId1)","quantity": "1","priceListId":"#(PRICE_LIST_ID)"}, {"itemId": "#(__arg.ItemId2)","quantity": "1","priceListId":"#(PRICE_LIST_ID)"}]}
    When method post
    Then status 201
    And print response
    And assert response.id != null && response.id != ''
    And assert response.lineItems[0].productAttributes.length == __arg.ItemAttributes1.length
    And assert response.lineItems[1].productAttributes.length == __arg.ItemAttributes2.length

  @PromotionalCartWithSingleLineItem
  Scenario: Add to Cart
    Given path ''
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request { "cartId": null, "networkCode": "ShipToHome", "lineItems": [{"itemId": "#(__arg.ItemId)","quantity": "1","priceListId":"#(PRICE_LIST_ID)"}]}
    When method post
    Then status 201
    And print response
    And assert response.id != null && response.id != ''
    And assert response.lineItems[0].productAttributes.length == __arg.ItemAttributes.length
    And assert response.appliedPromotions.length > 0
    And assert response.subTotal == response.totalAmount + response.totalDiscount
    And assert response.lineItems[0].price.lineTotalWithoutDiscounts > response.lineItems[0].price.lineTotalWithDiscounts
    And assert response.lineItems[0].discounts.length > 0
    And assert response.lineItems[0].price.unitPriceWithoutDiscounts == response.lineItems[0].price.lineTotalWithDiscounts + response.lineItems[0].discounts[0].amount

  @PromotionalCartWithMultiLineItem
  Scenario: Add to Cart
    Given path ''
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request { "cartId": null, "networkCode": "ShipToHome", "lineItems": [{"itemId": "#(__arg.ItemId1)","quantity": "1","priceListId":"#(PRICE_LIST_ID)"}, {"itemId": "#(__arg.ItemId2)","quantity": "1","priceListId":"#(PRICE_LIST_ID)"}]}
    When method post
    Then status 201
    And print response
    And assert response.id != null && response.id != ''
    And assert response.status == 'PENDING'
    And assert response.lineItems[0].productAttributes.length == __arg.ItemAttributes1.length
    And assert response.lineItems[1].productAttributes.length == __arg.ItemAttributes2.length
    And assert response.appliedPromotions.length > 0
    And assert response.subTotal == response.totalAmount + response.totalDiscount
    And assert response.lineItems[0].price.base > response.lineItems[0].price.lineTotalWithDiscounts
    And assert response.lineItems[0].discounts.length > 0
    And assert response.lineItems[0].price.unitPriceWithoutDiscounts == response.lineItems[0].price.lineTotalWithDiscounts + response.lineItems[0].discounts[0].amount
    And assert response.lineItems[1].price.base > response.lineItems[1].price.lineTotalWithDiscounts
    And assert response.lineItems[0].discounts.length > 0
    And assert response.lineItems[1].price.unitPriceWithoutDiscounts == response.lineItems[1].price.lineTotalWithDiscounts + response.lineItems[1].discounts[0].amount

  @PromotionalCartWithSingleLineItemWithMultiPleQua
  Scenario: Add to Cart
    Given path ''
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request { "cartId": null, "networkCode": "ShipToHome", "lineItems": [{"itemId": "#(__arg.ItemId)","quantity": '#(quantity)',"priceListId":"#(PRICE_LIST_ID)"}]}
    When method post
    Then status 201
    And print response
    And assert response.id != null && response.id != ''
    And assert response.status == 'PENDING'
    And assert response.lineItems[0].productAttributes.length == __arg.ItemAttributes.length
    And assert response.appliedPromotions.length > 0
    And assert response.subTotal == response.totalAmount + response.totalDiscount
    And assert response.lineItems[0].price.lineTotalWithoutDiscounts > response.lineItems[0].price.lineTotalWithDiscounts
    And assert response.lineItems[0].discounts.length > 0
    And assert response.lineItems[0].price.lineTotalWithDiscounts == response.lineItems[0].price.lineTotalWithoutDiscounts - (response.lineItems[0].discounts[0].amount * response.lineItems[0].discounts[0].quantity)



  @AddingSingleItemToCartWithExpiredPromotion
    # Same as add to cart with no promo
  Scenario: Add to Cart
    Given path ''
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request { "cartId": null, "networkCode": "ShipToHome", "lineItems": [{"itemId": "#(__arg.ItemId)","quantity": "1","priceListId":"#(PRICE_LIST_ID)"}]}
    When method post
    Then status 201
    And print response
    And assert response.id != null && response.id != ''
    And assert response.lineItems[0].productAttributes.length == __arg.ItemAttributes.length
    And assert response.appliedPromotions.length == 0


  @AddingNon_PriceItem
  Scenario: Add to Cart
    Given path ''
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request { "cartId": null, "networkCode": "ShipToHome", "lineItems": [{"itemId": "#(__arg.ItemId)","quantity": "1", "priceListId":"#(PRICE_LIST_ID)"}]}
    When method post
    And print response
    And assert response.type == "BAD_REQUEST"
    Then print "Error: Unable to get Price"

  @AddingNon_InventoryItem
  Scenario: Add to Cart
    Given path ''
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request { "cartId": null, "networkCode": "ShipToHome", "lineItems": [{"itemId": "#(__arg.ItemId)","quantity": "1", "priceListId":"#(PRICE_LIST_ID)"}]}
    When method post
    Then assert responseStatus == 400
    And print response
    And assert response.message == "Item is out of stock"
    And print "Error: The inventory doesn't configured for the item"