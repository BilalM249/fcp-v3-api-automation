@Sanity
Feature: Checkout without Variant + Bundle product

  Scenario: No promotions and no coupons With Non Variant Item + Bundle Item
    * def product  = call read('classpath:karate/core/pim/pim.feature@ForNonVariantItem') {ItemId : '#(multitier_coupon_applicable_non_variant_itemId)'}
    * def ItemAttributes = product.response.attributes
    * def ItemId = product.response.itemId
    * def sku = product.response.sku

    * def productBundle  = call read('classpath:karate/core/pim/pim.feature@ForBundleItem') {ItemId : '#(Bundle_ItemId)'}
    * def ItemAttributesBundle = productBundle.response.attributes
    * def ItemIdBundle = productBundle.response.itemId
    * def Bundlesku = productBundle.response.sku

    * def price  = call read('classpath:karate/core/price/price.feature@PriceFor2Items') {ItemId1: '#(ItemIdBundle)', ItemId2: '#(ItemId)'}


    * def inventoryForItem  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfigured') {sku : '#(sku)'}
    * def inventoryForBundle  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfigured') {sku : '#(Bundlesku)'}

    * def cart = call read('classpath:karate/core/cart/addToCart.feature@AddingMultipleItemToCart') {ItemId1: '#(ItemId)', ItemAttributes1:'#(ItemAttributes)', ItemId2: '#(ItemIdBundle)', ItemAttributes2:'#(ItemAttributesBundle)'}

    * def shippingDetails = call read('classpath:karate/core/oms/GetShippingByID.feature') {shippingId: '#(shipMethodId)'}
    * def shippingId = shippingDetails.response.shippingMethodId
    * def shippingCost = shippingDetails.response.cost
    * def cartId = cart.response.id

    * def lineItemId1 = cart.response.lineItems[0].id
    * def position = cart.response.lineItems[0].position
    * def lineItemId2 = cart.response.lineItems[1].id
    * def createShipTo = call read('classpath:karate/core/cart/createShipTo.feature') {cartId: '#(cartId)', shippingMethodId: '#(shippingId)', shippingCost: '#(shippingCost)' }

    * def shipToId = createShipTo.response.id

    * def applyCoupon = call read('classpath:karate/core/cart/applyCoupon.feature@ApplyingMultiTierCoupon') {cartId: '#(cartId)', couponCode : '#(Non_Variant_Multitier_Quantity_Coupon)'}

    * def cartQuantity = call read('classpath:karate/core/cart/updateQuantity.feature@UpdateQtyForMultiLineItemAndMultiTierQuantityCoupon') {lineItemId: '#(lineItemId1)', position: '#(position)' ,productId: '#(ItemId)', cartId: '#(cartId)', Quantity: '2' }

    * def addShipToCart = call read('classpath:karate/core/cart/addShippingToCart.feature@SingleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', ItemId: '#(lineItemId1)'}
    * def addShipToCart = call read('classpath:karate/core/cart/addShippingToCart.feature@SingleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', ItemId: '#(lineItemId2)'}

    * def getCart = call read('classpath:karate/core/cart/getCart.feature@GetCartWithMultiLineItem') {cartID: '#(cartId)' }

    * def cartAmount = getCart.response.totalAmount - createShipTo.response.shippingCost

    * def checkout = call read('classpath:karate/core/checkout/checkout.feature@CheckoutMultipleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', shippingCost: '#(shippingCost)', cartTotal: '#(cartAmount)'}
    * def orderId = checkout.response.orderId
    * def getOrder = call read('classpath:karate/core/oms/getOrderById.feature@GetOrderForMultiLineItem') {orderId : '#(orderId)'}
    Then print getOrder