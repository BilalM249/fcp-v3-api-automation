@Sanity
 Feature: Checkout without Variant product

   Scenario: No promotions and no coupons With Non Variant Item
     * def product  = call read('classpath:karate/core/pim/pim.feature@ForNonVariantItem') {ItemId : '#(non_variant_itemId)'}
     * def ItemAttributes = product.response.attributes
     * print "ITEM ATTRIBUTES: " + ItemAttributes
     * def ItemId = product.response.itemId
     * def price  = call read('classpath:karate/core/price/price.feature@PriceForSingleItems') {ItemId: '#(ItemId)'}
     * def priceForItem = price.response.data[0].offer.price.base
     * def sku = product.response.sku

     * def inventoryForItem  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfigured') {sku : '#(sku)'}

     * def cart = call read('classpath:karate/core/cart/addToCart.feature@AddingSingleItemToCart') {ItemId: '#(ItemId)', amount: '#(priceForItem)',  ItemAttributes:'#(ItemAttributes)'}

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