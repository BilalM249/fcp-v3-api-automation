Feature: update Cart Quantity

  Background:

    * url cart_endpoint
    * def tenantId = account

  @UpdateQtyForSingleLineItem
  Scenario: Add to Cart
    Given path __arg.cartId + '/line-items/' + __arg.lineItemId
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request {"position":"#(__arg.position)","quantity":"#(__arg.Quantity)","itemId":"#(__arg.productId)"}
    When method PUT
    Then status 200
    And print response
    And assert response.id != null && response.id != ''
#    And assert response.state == 'PENDING' - NOT IN THE RESPONSE ANYMORE
    And assert response.quantity == __arg.Quantity
    * def unitPrice = response.price.sale
#    * def totalAmount = response.totalAmount - LINE ITEM RESPONSE DOES NOT HAVE TOTAL AMOUNT
    And assert response.price.lineTotalWithDiscounts == response.price.base * response.quantity


    @UpdateQtyForMultiLineItemAndMultiTierQuantityCoupon
    Scenario: Add to Cart
      Given path __arg.cartId + '/line-items/' + __arg.lineItemId
      And header  x-fabric-tenant-id = tenantId
      And header Authorization = auth
      And header Content-Type = 'application/json'
      And request {"position":#(__arg.position),"quantity":"#(__arg.Quantity)","itemId":"#(__arg.productId)"}
      When method PUT
      Then status 200
      And print response
      And assert response.id != null && response.id != ''
      And assert response.discounts[0].promotion.value == 20.0
      And assert response.discounts[0].promotion.type == "QUANTITY"
      And assert response.discounts[0].promotion.discountType == "%OFF"