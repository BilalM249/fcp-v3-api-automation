@Sanity
Feature: Shipping Promotion applicable on SKU

  Scenario: Shipping Promotion applicable on SKU
    * def product  = call read('classpath:karate/core/pim/pim.feature@ForNonVariantItem') {ItemId : '#(FCP_Shipping_OFF_ItemId)'}
    * def ItemAttributes = product.response.attributes
    * def ItemId = product.response.itemId
    * def price  = call read('classpath:karate/core/price/price.feature@PriceForSingleItems') {ItemId: '#(ItemId)'}
    * def sku = product.response.sku

    * def inventoryForItem  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfigured') {sku : '#(sku)'}

    * def cart = call read('classpath:karate/core/cart/addToCart.feature@AddingSingleItemToCart') {ItemId: '#(ItemId)', ItemAttributes:'#(ItemAttributes)'}

    * def shippingDetails = call read('classpath:karate/core/oms/GetShippingByID.feature') {shippingId: '#(shipMethodId)'}
    * def shippingId = shippingDetails.response.shippingMethodId
    * def shippingCost = shippingDetails.response.cost
    * def cartId = cart.response.id
    * def lineItemId = cart.response.lineItems[0].id
    * def createShipTo = call read('classpath:karate/core/cart/createShipTo.feature') {cartId: '#(cartId)', shippingMethodId: '#(shippingId)', shippingCost: '#(shippingCost)' }

    * def shipToId = createShipTo.response.id

    * def addShipToCart = call read('classpath:karate/core/cart/addShippingToCart.feature@SingleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', ItemId: '#(lineItemId)'}

    * def getCart = call read('classpath:karate/core/cart/getCart.feature@GetPromotionalShippingCart') {cartID: '#(cartId)' }

    * def cartAmount = getCart.response.totalAmount
    * def shippingCost = getCart.response.lineItems[0].shippingDetails.shippingCost - getCart.response.lineItems[0].discounts[0].amount
    * def checkout = call read('classpath:karate/core/checkout/checkout.feature@CheckoutSingleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', shippingCost: '#(shippingCost)', cartTotal: '#(cartAmount)'}
    * def orderId = checkout.response.orderId
    * def getOrder = call read('classpath:karate/core/oms/getOrderById.feature@GetOrderForSingleLineItem') {orderId : '#(orderId)'}
    Then print getOrder