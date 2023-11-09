@Sanity
Feature: Checkout with variant product Along with EXPIRED COUPON

  Scenario: EXPIRED_COUPON Coupon Applied to Cart with Variant Item
    * def product  = call read('classpath:karate/core/pim/pim.feature@ForVariantItem') {ItemId : '#(variant_itemId)'}
    * def ItemId1 = product.response.variants[0].itemId
    * def ItemId2 = product.response.variants[1].itemId
    * def ItemId1Attributes = product.response.variants[0].attributes
    * def price  = call read('classpath:karate/core/price/price.feature@PriceFor2Items') {ItemId1: '#(ItemId1)', ItemId2: '#(ItemId2)'}
    * def priceForItem = price.response.data[0].offer.price.base
    * def sku1 = product.response.variants[0].sku
    * def sku2 = product.response.variants[1].sku
    * def inventoryForItem1  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfigured') {sku : '#(sku1)'}
    * def inventoryForItem2  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfigured') {sku : '#(sku2)'}

    * def cart = call read('classpath:karate/core/cart/addToCart.feature@AddingSingleItemToCart') {ItemId: '#(ItemId1)', amount: '#(priceForItem)', ItemAttributes:'#(ItemId1Attributes)'}
    * def cartId = cart.response.id
    * def lineItemId = cart.response.lineItems[0].id

    * def applyCoupon = call read('classpath:karate/core/cart/applyCoupon.feature@ExpiredCoupon') {cartId: '#(cartId)', couponCode : '#(Expired_Coupon)'}
