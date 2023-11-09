@Sanity
Feature: Checkout with  variant and Non Variant  promotional product

  Scenario:  promotions but no coupons With Variant Item + Non Variant Product
    * def variantProduct  = call read('classpath:karate/core/pim/pim.feature@ForVariantItem') {ItemId : '#(FCP_Promotional_Variant_ItemId)'}
    * def ItemId1 = variantProduct.response.variants[0].itemId
    * def ItemId2 = variantProduct.response.variants[1].itemId
    * def ItemId1Attributes = variantProduct.response.variants[0].attributes
    * def ItemId2Attributes = variantProduct.response.variants[1].attributes
    * def sku1 = variantProduct.response.variants[0].sku
    * def sku2 = variantProduct.response.variants[1].sku

    * def nonVariantProduct  = call read('classpath:karate/core/pim/pim.feature@ForNonVariantItem') {ItemId : '#(FCP_Promotional_Non_Variant_ItemId)'}
    * def ItemAttributes = nonVariantProduct.response.attributes
    * def ItemId = nonVariantProduct.response.itemId
    * def sku =  nonVariantProduct.response.sku

    * def price  = call read('classpath:karate/core/price/price.feature@PriceFor2Items') {ItemId1: '#(ItemId1)', ItemId2: '#(ItemId)'}


    * def inventoryForItem1  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfigured') {sku : '#(sku1)'}
    * def inventoryForItem2  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfigured') {sku : '#(sku)'}

    * def cart = call read('classpath:karate/core/cart/addToCart.feature@PromotionalCartWithMultiLineItem') {ItemId1: '#(ItemId1)', ItemAttributes1:'#(ItemId1Attributes)', ItemId2: '#(ItemId)', ItemAttributes2:'#(ItemAttributes)'}

    * def shippingDetails = call read('classpath:karate/core/oms/GetShippingByID.feature') {shippingId: '#(shipMethodId)'}
    * def shippingId = shippingDetails.response.shippingMethodId
    * def shippingCost = shippingDetails.response.cost
    * def cartId = cart.response.id
    * def lineItemId1 = cart.response.lineItems[0].id
    * def lineItemId2 = cart.response.lineItems[1].id
    * def createShipTo = call read('classpath:karate/core/cart/createShipTo.feature') {cartId: '#(cartId)', shippingMethodId: '#(shippingId)', shippingCost: '#(shippingCost)' }

    * def shipToId = createShipTo.response.id

    * def addShipToCart = call read('classpath:karate/core/cart/addShippingToCart.feature@SingleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', ItemId: '#(lineItemId1)'}
    * def addShipToCart = call read('classpath:karate/core/cart/addShippingToCart.feature@SingleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', ItemId: '#(lineItemId2)'}

    * def cartAmount = cart.response.totalAmount

    * def checkout = call read('classpath:karate/core/checkout/checkout.feature@CheckoutMultipleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', shippingCost: '#(shippingCost)', cartTotal: '#(cartAmount)'}
    * def orderId = checkout.response.orderId
    * def getOrder = call read('classpath:karate/core/oms/getOrderById.feature@GetOrderForMultiLineItem') {orderId : '#(orderId)'}
    Then print getOrder