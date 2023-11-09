@Sanity
Feature: Checkout with Bundle product Along with EXPIRED_COUPON

  Scenario: EXPIRED_COUPON Coupon Applied to Cart with Bundle Item
    * def product  = call read('classpath:karate/core/pim/pim.feature@ForBundleItem') {ItemId : '#(Bundle_ItemId)'}
    * def ItemAttributes = product.response.attributes
    * def ItemId = product.response.itemId
    * def sku = product.response.sku
    * def price  = call read('classpath:karate/core/price/price.feature@PriceForSingleItems') {ItemId: '#(ItemId)'}

    * def inventoryForItem  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfigured') {sku : '#(sku)'}


    * def cart = call read('classpath:karate/core/cart/addToCart.feature@AddingSingleItemToCart') {ItemId: '#(ItemId)', ItemAttributes:'#(ItemAttributes)'}
    * def cartId = cart.response.id
    * def lineItemId = cart.response.lineItems[0].id
    * def applyCoupon = call read('classpath:karate/core/cart/applyCoupon.feature@ExpiredCoupon') {cartId: '#(cartId)', couponCode:'#(Expired_Coupon)'}