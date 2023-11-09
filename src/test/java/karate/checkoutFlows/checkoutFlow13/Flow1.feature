@Sanity
Feature: Checkout with variant product Along with Quantity Base Percentage OFF Promotion

  Scenario: Quantity_Promotion Applied to Cart with Variant Item
    * def product  = call read('classpath:karate/core/pim/pim.feature@ForVariantItem') {ItemId : '#(FCP_QUA_Promotional_Variant_ItemId)'}
    * def ItemId1 = product.response.variants[0].itemId
    * def ItemId2 = product.response.variants[1].itemId
    * def ItemId1Attributes = product.response.variants[0].attributes
    * def price  = call read('classpath:karate/core/price/price.feature@PriceFor2Items') {ItemId1: '#(ItemId1)', ItemId2: '#(ItemId2)'}
    * def sku1 = product.response.variants[0].sku
    * def sku2 = product.response.variants[1].sku
    * def inventoryForItem1  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfigured') {sku : '#(sku1)'}
    * def inventoryForItem2  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfigured') {sku : '#(sku2)'}
    * def cart = call read('classpath:karate/core/cart/addToCart.feature@PromotionalCartWithSingleLineItemWithMultiPleQua') {ItemId: '#(ItemId1)', ItemAttributes:'#(ItemId1Attributes)',  quantity:'2'}
    * def cartId = cart.response.id
    * def lineItemId = cart.response.lineItems[0].id

    * def shippingDetails = call read('classpath:karate/core/oms/GetShippingByID.feature') {shippingId: '#(shipMethodId)'}
    * def shippingId = shippingDetails.response.shippingMethodId
    * def shippingCost = shippingDetails.response.cost

    * def createShipTo = call read('classpath:karate/core/cart/createShipTo.feature') {cartId: '#(cartId)', shippingMethodId: '#(shippingId)', shippingCost: '#(shippingCost)' }

    * def shipToId = createShipTo.response.id

    * def addShipToCart = call read('classpath:karate/core/cart/addShippingToCart.feature@SingleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', ItemId: '#(lineItemId)'}

    * def cartAmount = cart.response.totalAmount

    * def checkout = call read('classpath:karate/core/checkout/checkout.feature@CheckoutSingleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', shippingCost: '#(shippingCost)', cartTotal: '#(cartAmount)'}
    * def orderId = checkout.response.orderId
    * def getOrder = call read('classpath:karate/core/oms/getOrderById.feature@GetOrderForSingleLineItem') {orderId : '#(orderId)'}
    Then print getOrder