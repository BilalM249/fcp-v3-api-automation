Feature: Add Coupon To Cart

  Background:
    * url cart_endpoint
    * def tenantId = account

  @SingleLineItem
  Scenario: apply coupon to cart
    Given path  __arg.cartId + '/actions/apply-coupon-code'
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request {"couponCode": "#(__arg.couponCode)"}
    When method post
    Then status 200
    And assert response.appliedPromotions.length > 0
    And assert response.appliedPromotions[0].couponCode ==  __arg.couponCode.toUpperCase()
    And assert response.appliedPromotions.length > 0
    And assert response.appliedPromotions[0].couponCode ==   __arg.couponCode.toUpperCase()
    And assert response.appliedPromotions.length > 0
    And assert response.appliedPromotions[0].couponCode ==   __arg.couponCode.toUpperCase()
    And assert response.lineItems[0].price.lineTotalWithDiscounts == response.lineItems[0].price.lineTotalWithoutDiscounts - response.lineItems[0].discounts[0].amount * response.lineItems[0].discounts[0].quantity

    And assert response.appliedPromotions.length > 0
    And assert response.appliedPromotions[0].couponCode ==  __arg.couponCode.toUpperCase()
    * def subTotal =  response.subTotal
    * def totalAmount =  response.totalAmount
    * def totalDiscount = response.totalDiscount
    And assert subTotal == totalDiscount + totalAmount


  @MultiLineItem
  Scenario: apply coupon to cart
    Given path  __arg.cartId + '/actions/apply-coupon-code'
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request {"couponCode": "#(__arg.couponCode)"}
    When method post
    Then status 200
    And assert response.appliedPromotions.length > 0
    And assert response.appliedPromotions[0].couponCode ==  __arg.couponCode.toUpperCase()
    And assert response.appliedPromotions.length > 0
    And assert response.appliedPromotions[0].couponCode ==   __arg.couponCode.toUpperCase()
    And assert response.appliedPromotions.length > 0
    And assert response.appliedPromotions[0].couponCode ==   __arg.couponCode.toUpperCase()
    And assert response.appliedPromotions.length > 0
    And assert response.appliedPromotions[0].couponCode ==  __arg.couponCode.toUpperCase()

    And assert response.lineItems[0].price.lineTotalWithoutDiscounts == response.lineItems[0].price.unitPriceWithoutDiscounts * response.lineItems[0].quantity
    And assert response.lineItems[1].price.lineTotalWithoutDiscounts == response.lineItems[1].price.unitPriceWithoutDiscounts * response.lineItems[1].quantity

    * def subTotal =  response.subTotal
    * def totalAmount =  response.totalAmount
    * def totalDiscount = response.totalDiscount
    And assert subTotal == totalDiscount + totalAmount



  @ShippingCouponWithSingleLineItem
  Scenario: apply coupon to cart
    Given path  __arg.cartId + '/actions/apply-coupon-code'
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request {"couponCode": "#(__arg.couponCode)"}
    When method post
    Then status 200
    And assert response.appliedPromotions.length > 0
    And assert response.appliedPromotions[0].couponCode ==  __arg.couponCode.toUpperCase()
    And assert response.appliedPromotions.length > 0
    And assert response.appliedPromotions[0].couponCode ==   __arg.couponCode.toUpperCase()
    And assert response.appliedPromotions.length > 0
    And assert response.appliedPromotions[0].couponCode ==   __arg.couponCode.toUpperCase()
    And assert response.totalAmount == response.subTotal - response.lineItems[0].discounts[0].amount
#    And assert response.lineItems[0].shippingDetails.shippingDiscount == 10 - Not needed - this is not populated in v2 too.
    And assert response.appliedPromotions.length > 0
    And assert response.appliedPromotions[0].couponCode ==  __arg.couponCode.toUpperCase()
    * def subTotal =  response.subTotal
    * def totalAmount =  response.totalAmount
    * def totalDiscount = response.totalDiscount
    And assert subTotal == totalDiscount + totalAmount


  @ShippingCouponOnAFreeShippingCart
  Scenario: apply coupon to cart
    Given path  __arg.cartId + '/actions/apply-coupon-code'
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request {"couponCode": "#(__arg.couponCode)"}
    When method post
    Then status 404
    And assert response.type == "NOT_FOUND"
    And match response.message contains "Promo not applicable for given item"


  @ExpiredCoupon
  Scenario: apply coupon to cart
    Given path  __arg.cartId + '/actions/apply-coupon-code'
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request {"couponCode": "#(__arg.couponCode)"}
    When method post
    Then status 404
    And assert response.type == "NOT_FOUND"
    And match response.message contains "Promo not applicable for given item"


  @ApplyingMultiTierCoupon
  Scenario: apply coupon to cart
    Given path  __arg.cartId + '/actions/apply-coupon-code'
    And header  x-fabric-tenant-id = tenantId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And request {"couponCode": "#(__arg.couponCode)"}
    When method post
    Then status 200
    And assert response.appliedPromotions.length > 0
    And match response.appliedPromotions[*].couponCode contains __arg.couponCode.toUpperCase()
    And match response.lineItems[*].discounts[*].promotion.value contains 10.0
    And match response.lineItems[*].discounts[*].promotion.type contains "QUANTITY"